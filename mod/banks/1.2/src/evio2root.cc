// EVIO headers
#include "evioUtil.hxx"
#include "evioFileChannel.hxx"
using namespace evio;

// gemc headers
#include "options.h"
#include "gbank.h"
#include "string_utilities.h"

// C++ headers
#include <string>
#include <iostream>
#include <vector>
using namespace std;

// banks header
#include "banks.h"
#include "rootTrees.h"



int main(int argc, char **argv)
{
	// argument is input file name.
	try
	{
		// loading options
		goptions gemcOpt;
		gemcOpt.setGoptions();
		
		if(argc == 1)
		{
			char *nargv[2];
			const char buf[] = "-help-all";
			strcpy(nargv[0], buf);
			strcpy(nargv[1], buf);
			gemcOpt.setOptMap(2, nargv);
		}

		gemcOpt.setOptMap(argc, argv);
		
		// verbosity
		double verbosity  = gemcOpt.optMap["BANK_VERBOSITY"].arg;
		double MAXN       = gemcOpt.optMap["N"].arg;
		string WRAW       = gemcOpt.optMap["WRITE_RAWS"].args;
		double addEvent   = gemcOpt.optMap["ADDEVN"].arg ;
		
		// list of banks
		string banklist = gemcOpt.optMap["B"].args ;
		
		// for now let's get all systems from TEXT factories, variation "original"
		string factories = "TEXT";
				
		// loading veriables definitions from factories db
		vector<string> whichSystems = get_strings_except(banklist, "all");
		map<string, string> allSystems;
		
		for(unsigned b=0; b<whichSystems.size(); b++)
			allSystems[whichSystems[b]] = factories;
		
		map<string, gBank> banksMap = read_banks(gemcOpt, allSystems);

		// selecting input, output file
		string inputfile = gemcOpt.optMap["INPUTF"].args ;
		
		// ROOT file for output; defining tree
		// ROOT does not recognize vector<float> but vector<doubles> are fine
		string outputfile = inputfile.substr(0, inputfile.rfind(".")) + ".root";
		TFile *f = new TFile(outputfile.c_str(),"RECREATE");
		cout << "  > Output File set to: " << outputfile << endl;
		
		
		map<string, rTree> rTrees;

		// header bank
		// loading all variables as double
		// maybe we can make it more general later
		rTrees["header"] = rTree(banksMap["header"].bankName, banksMap["header"].bdescription, verbosity);
		for(unsigned i=0; i<banksMap["header"].name.size(); i++)
		{
			if(banksMap["header"].name[i] == "time")
				rTrees["header"].addVariable(banksMap["header"].name[i], "Ns");
			else
				rTrees["header"].addVariable(banksMap["header"].name[i], "Nd");
		}
		
		// generated bank
		rTrees["generated"] = rTree(banksMap["generated"].bankName, banksMap["generated"].bdescription, verbosity);
		for(unsigned i=0; i<banksMap["generated"].name.size(); i++)
			rTrees["generated"].addVariable(banksMap["generated"].name[i], banksMap["generated"].type[i]);


		// hit banks
		for(map<string, gBank>::iterator it = banksMap.begin(); it != banksMap.end(); it++)
		{
			if(it->first != "header" && it->first != "generated" && it->first != "raws" && it->first != "psummary")
			{
				rTrees[it->first] = rTree(banksMap[it->first].bankName, banksMap[it->first].bdescription, verbosity);
				for(unsigned i=0; i<banksMap[it->first].name.size(); i++)
				{
					// Using Nd for all variables.
					rTrees[it->first].addVariable(banksMap[it->first].name[i], "Nd");
				}
				if(WRAW == "yes")
				{
					// adding raws infos to bank
					for(unsigned i=0; i<banksMap["raws"].name.size(); i++)
						if(banksMap["raws"].name[i] != "hitn")
							// Using Nd for all variables.
							rTrees[it->first].addVariable(banksMap["raws"].name[i], "Nd");
				}
			}
		}
		
		
		// starting from -3
		// first event is option
		// ++ inside loop
		// equal sign for maxn
		int evn = -3 + addEvent;
		
		evioFileChannel *chan = new evioFileChannel(inputfile, "r", 3000000);
		chan->open();
		
		// skip first event, its the configuration file
		chan->read();

		while(chan->read() && (evn++ <= MAXN || MAXN == 0))
		{
			evioDOMTree EDT(chan);

			// read all defined banks
			for(map<string, gBank>::iterator it = banksMap.begin(); it != banksMap.end(); it++)
			{
				// header
				if(it->first == "header")
				{
					map<string, double>  headerBank = getHeaderBank(EDT, getBankFromMap("header", &banksMap), 0);
					
					rTrees["header"].init();

					for(map<string, double>::iterator head_it = headerBank.begin(); head_it != headerBank.end(); head_it++)
					{
						// time value is -999
						if(head_it->second == -999)
							rTrees["header"].insertVariable("time", "Ns", head_it->first);
						
						else
						{
							if(head_it->first == "evn")
								rTrees["header"].insertVariable(head_it->first, "Nd", head_it->second + addEvent);
							else
								rTrees["header"].insertVariable(head_it->first, "Nd", head_it->second);
						}
					}
					rTrees["header"].fill();
				}
				
				
				
				// generated particles
				else if(it->first == "generated")
				{
					vector<generatedParticle> parts = getGenerated(EDT, getBankFromMap(it->first, &banksMap), verbosity);
					
					rTrees["generated"].init();
					
					for(unsigned i=0; i<banksMap["generated"].name.size(); i++)
					{
						string varname = banksMap["generated"].name[i];
						string vartype = banksMap["generated"].type[i];
									
						for(unsigned p=0; p<parts.size(); p++)
						{
							rTrees["generated"].insertVariable(varname, vartype, parts[p].getVariableFromStringI(varname));
							rTrees["generated"].insertVariable(varname, vartype, parts[p].getVariableFromStringD(varname));
						}
					}
					rTrees["generated"].fill();
				}
				
				
				// hit banks
				else if(it->first != "psummary" && it->first != "raws")
				{
					
					vector<hitOutput> dgtHits = getDgtIntDataBank(EDT, it->first, &banksMap, verbosity);
					vector<hitOutput> rawHits = getRawIntDataBank(EDT, it->first, &banksMap, verbosity);
					
					// looping over hits
					// hit index must be the same
					unsigned long nrawhits = rawHits.size();
					unsigned long ndgthits = dgtHits.size();
					
					// if both banks are present they must have same size
					// if one bank is switched off it will have dimension zero
					if((nrawhits == ndgthits && ndgthits > 0) || nrawhits*ndgthits == 0)
					{
						rTrees[it->first].init();
						if(WRAW == "yes")
						{
							for(unsigned long h=0; h<nrawhits; h++)
							{
								map<string, double> raws = rawHits[h].getRaws();
								for(map<string, double>::iterator raws_it = raws.begin(); raws_it != raws.end(); raws_it++)
									if(raws_it->first!= "hitn")
										rTrees[it->first].insertVariable(raws_it->first, "Nd", raws_it->second);
							}
						}
						for(unsigned long h=0; h<ndgthits; h++)
						{
							map<string, double> dgts = dgtHits[h].getDgtz();
							for(map<string, double>::iterator dgts_it = dgts.begin(); dgts_it != dgts.end(); dgts_it++)
								rTrees[it->first].insertVariable(dgts_it->first, "Nd", dgts_it->second);
						}

						rTrees[it->first].fill();
					}

				}
				
				
			}
			
		}
		chan->close();
	
		f->Write();
		delete f;

	
	}

	catch (evioException e)
	{
		cerr << e.toString() << endl;
	}
		
}









