#include <iostream> 
#include <fstream>
#include <cmath> 
#include "math.h" 
#include "TCanvas.h"
#include "TFile.h"
#include "TTree.h"
#include "TChain.h"
#include "TH1.h"
#include "TH2.h"
#include "TH3.h"
#include "TF1.h"
#include "TH1F.h"
#include "TLorentzVector.h"
#include "TROOT.h"
#include "TStyle.h"
#include "TMinuit.h"
#include "TPaveText.h"
#include "TText.h"
#include "TSystem.h"
#include "TArc.h"
#include "TString.h"
#include <vector>
#include "TRandom3.h"
#include "TGraphErrors.h"
#include "TString.h"
#include "TFile.h"

using namespace std;

//the wiser curve
#include "SIDIS_He3_FAEC_electron_trigger_WiserJinHuang.C"
#include "SIDIS_He3_LAEC_electron_trigger_WiserJinHuang.C"
#include "SIDIS_He3_FAEC_hadron_trigger_WiserJinHuang.C"
// EC efficiency table inside

#include "analysis_tree_solid_lgc.C"
#include "analysis_tree_solid_spd.C"
#include "analysis_tree_solid_mrpc.C"


// some numbers to be hard coded 
// make sure they are correct while using this script
//################################################################################################################################################## 
// const double filenum=50; //file numbers while running GEMC in order to be correct for normalization
const int loop_time=1;   //electron to be 1, pion to be many times to take advantage of statistics, pion has low efficiency on EC
const int add_norm=1; // additional normalization factor
// const double threshold_distance=0;
// const double threshold_distance=0.1;
const double threshold_distance=32.5;

// lgc threshold
const double PEthresh=2; //lgc pe shreshold for each pmt
const double PMTthresh=2; //lgc pmt shreshold, at least 2pmts are fired in each sector
const int with_background_on_lgc=0;     //0: no background on lgc, 1: yes background on lgc

//spd threshold
// const double spd_threshold=0.35;         //0.35 MeV
const double spd_threshold_FA=0.5;         //0.5 MeV
const double spd_threshold_LA=1.5;         //1.5 MeV

//mrpc threshold
const double mrpc_block_threshold_FA=5;  //how many layers are required to be fired

//check if original particle
// bool Is_tellorig=false;
// bool Is_tellorig=true;

bool Is_debug=false;

const double DEG=180./3.1415926;   //rad to degree

//#####################################################################################################################################################

int analysis_SIDIS(string inputfile_name,bool Is_tellorig=false,string filetype=""){

// gStyle->SetOptStat(11111111);
  gStyle->SetOptStat(0);

bool Is_singlefile=false;
bool Is_pi0=false;
if(Is_tellorig){
if(filetype.find("single",0) != string::npos) {
  Is_singlefile=true;
  cout << "this is a single file" << endl;  
}
else if(filetype.find("sidis",0) != string::npos) {
  Is_singlefile=false;
  cout << "this is a sidis file" << endl;      
}
else {cout << "unknown file type, choose either single or sidis" << endl;return 0;}

if (inputfile_name.find("pi0",0) != string::npos) {
  Is_pi0=true;
  cout << "this is a pi0 file" << endl;  
}
else {cout << "this is NOT a pi0 file" << endl;}
}

bool Is_SIDIS_He3=false,Is_SIDIS_NH3=false;
if(inputfile_name.find("SIDIS_He3",0) != string::npos) {
  Is_SIDIS_He3=true;
  cout << "SIDIS_He3 setup" << endl;  
}
else if(inputfile_name.find("SIDIS_NH3",0) != string::npos) {
  Is_SIDIS_NH3=true;
  cout << "SIDIS_NH3 setup" << endl;  
}
else {
    cout << "Not SIDIS_He3 or SIDIS_NH3 setup" << endl;    
    return 0;
}

double filenum=1;
if (inputfile_name.find("_filenum",0) != string::npos) {
  filenum=atof(inputfile_name.substr(inputfile_name.find("_filenum")+8,inputfile_name.find("_")).c_str());
    cout << "filenum " << filenum << " for addtional normalization, YOU Need to Make Sure It's CORRECT!" <<  endl;
}
else {cout << "this file has no filnum, please check if you need filenum for addtional normalization" << endl;}

TFile *file=new TFile(inputfile_name.c_str());

// 	TString background_inputfile_name="parametrized_lgc.root";      //h_pe is here	
// 	TFile *background_file=new TFile(background_inputfile_name);
// 	TH1F *h_pe=(TH1F*)background_file->Get("h_pe");

// 	TFile *output_file=new TFile("SIDIS_trigger.root","RECREATE");
	
// prepare for outputs
// define histograms, output txt files etc...


	TH2F *hvertex_rz=new TH2F("hvertex_rz","hvertex_rz",1800,-400,500,600,0,300);
	
	TH1F *hangle_FAEC_FASPD=new TH1F("hangle_FAEC_FASPD","hangle_FAEC_FASPD",720,-360,360);
	TH1F *hangle_FAEC_LASPD=new TH1F("hangle_FAEC_LASPD","hangle_FAEC_LASPD",720,-360,360);	
	
	//LGC
	TH1F *h_n_trigger_sectors_LGC=new TH1F("h_n_trigger_sectors_LGC","number of triggered sectors",30,0,30);	
	//SPD
	TH1F *h_n_trigger_sectors_spd_FA=new TH1F("h_n_trigger_sectors_spd_FA","number of triggered sectors for spd at FA",240,0,240);
	TH1F *h_n_trigger_sectors_spd_LA=new TH1F("h_n_trigger_sectors_spd_LA","number of triggered sectors for spd at LA",240,0,240);	
	//MRPC
	TH1F *h_n_trigger_sectors_mrpc=new TH1F("h_n_trigger_sectors_mrpc","number of triggered sectors for mrpc",150,0,150);
	
	TH1F *h_counter_e_FA_EC=new TH1F("h_counter_e_FA_EC","e counter rate at forward angle", 10,0,10);
	TH1F *h_counter_e_FA_EC_lgc=new TH1F("h_counter_e_FA_EC_lgc","e counter rate at forward angle", 10,0,10);
	TH1F *h_counter_e_FA_EC_lgc_spd=new TH1F("h_counter_e_FA_EC_lgc_spd","e counter rate at forward angle", 10,0,10);	
	TH1F *h_counter_e_FA_EC_lgc_spd_mrpc=new TH1F("h_counter_e_FA_EC_lgc_spd_mrpc","e counter rate at forward angle", 10,0,10);
	
	TH1F *h_counter_e_LA_EC=new TH1F("h_counter_e_LA_EC","e counter rate at large angle", 10,0,10);
	TH1F *h_counter_e_LA_EC_spd=new TH1F("h_counter_e_LA_EC_spd","e counter rate at large angle", 10,0,10);

	TH1F *h_counter_h_FA_EC=new TH1F("h_counter_h_FA_EC","h counter rate on at forward angle", 10,0,10);
	TH1F *h_counter_h_FA_EC_spd=new TH1F("h_counter_h_FA_EC_spd","h counter rate on at forward angle", 10,0,10);
	TH1F *h_counter_h_FA_EC_spd_mrpc=new TH1F("h_counter_h_FA_EC_spd_mrpc","h counter rate on at forward angle", 10,0,10);
	
	// coin trigger rate with e forward angle and h forward angle
	TH1F *h_counter_e_FA_h_FA=new TH1F("h_counter_e_FA_h_FA","coincidence counter rate with e forward angle and h forward angle", 10,0,10);
	// coin counter rate with e large angle and h forward angle
	TH1F *h_counter_e_LA_h_FA=new TH1F("h_counter_e_LA_h_FA","coincidence counter rate with e large angle and h forward angle", 10,0,10);	

	TH1F *h_trigger_e_FA_EC=new TH1F("h_trigger_e_FA_EC","e trigger rate at forward angle", 60, 0, 300);
	TH1F *h_trigger_e_FA_EC_lgc=new TH1F("h_trigger_e_FA_EC_lgc","e trigger rate at forward angle", 60, 0, 300);
	TH1F *h_trigger_e_FA_EC_lgc_spd=new TH1F("h_trigger_e_FA_EC_lgc_spd","e trigger rate at forward angle", 60, 0, 300);	
	TH1F *h_trigger_e_FA_EC_lgc_spd_mrpc=new TH1F("h_trigger_e_FA_EC_lgc_spd_mrpc","e trigger rate at forward angle", 60, 0, 300);
	
	TH1F *h_trigger_e_LA_EC=new TH1F("h_trigger_e_LA_EC","e trigger rate at large angle", 60, 0, 300);
	TH1F *h_trigger_e_LA_EC_spd=new TH1F("h_trigger_e_LA_EC_spd","e trigger rate at large angle", 60, 0, 300);

	TH1F *h_trigger_h_FA_EC=new TH1F("h_trigger_h_FA_EC","h trigger rate on at forward angle", 60, 0, 300);
	TH1F *h_trigger_h_FA_EC_spd=new TH1F("h_trigger_h_FA_EC_spd","h trigger rate on at forward angle", 60, 0, 300);
	TH1F *h_trigger_h_FA_EC_spd_mrpc=new TH1F("h_trigger_h_FA_EC_spd_mrpc","h trigger rate on at forward angle", 60, 0, 300);
	
	// coin trigger rate with e forward angle and h forward angle
	TH1F *h_trigger_e_FA_h_FA=new TH1F("h_trigger_e_FA_h_FA","coincidence trigger rate with e forward angle and h forward angle", 60, 0, 300);
	// coin trigger rate with e large angle and h forward angle
	TH1F *h_trigger_e_LA_h_FA=new TH1F("h_trigger_e_LA_h_FA","coincidence trigger rate with e large angle and h forward angle", 60, 0, 300);
	
	TH2F *hgen_ThetaP=new TH2F("gen_ThetaP","generated events;vertex Theta (deg);vertex P (GeV)",60,5,35,110,0,11);     
	TH2F *hacceptance_ThetaP[2];
	hacceptance_ThetaP[0]=new TH2F("acceptance_ThetaP_FA","acceptance by FA;vertex Theta (deg);vertex P (GeV)",60,5,35,110,0,11);     
	hacceptance_ThetaP[1]=new TH2F("acceptance_ThetaP_LA","acceptance by LA;vertex Theta (deg);vertex P (GeV)",60,5,35,110,0,11);
	
	const int n=12;
	TH2F *hhit_xy[n],*hhit_PhiR[n];
	for(int i=0;i<n;i++){
	  char hstname[100];
	  sprintf(hstname,"hit_xy_%i",i);
	  hhit_xy[i]=new TH2F(hstname,hstname,600,-300,300,600,-300,300);        
	  sprintf(hstname,"hit_PhiR_%i",i);
	  hhit_PhiR[i]=new TH2F(hstname,hstname,360,-180,180,300,0,300);
	}
	
	//-------------------------
	//   get trees in the real data file
	//-------------------------
	
	//---header tree
	TTree *tree_header = (TTree*) file->Get("header");
	vector <int> *evn=0,*evn_type=0;
	vector <double> *beamPol=0;
	vector <double> *var1=0,*var2=0,*var3=0,*var4=0,*var5=0,*var6=0,*var7=0,*var8=0;
	tree_header->SetBranchAddress("evn",&evn);      // event number 
	tree_header->SetBranchAddress("evn_type",&evn_type);  // evn_type==-1 for simulated events
	tree_header->SetBranchAddress("beamPol",&beamPol);   //beam polarization
	tree_header->SetBranchAddress("var1",&var1);     // W+ rate
	tree_header->SetBranchAddress("var2",&var2);     // W- rate
	tree_header->SetBranchAddress("var3",&var3);     // target pol
	tree_header->SetBranchAddress("var4",&var4);     //x
	tree_header->SetBranchAddress("var5",&var5);     //y
	tree_header->SetBranchAddress("var6",&var6);     //w
	tree_header->SetBranchAddress("var7",&var7);     //Q2
	tree_header->SetBranchAddress("var8",&var8);     //rate, Hz, should check the input file of the simulation

	//---generated tree
	//particle generated with certain momentum at certain vertex
	TTree *tree_generated = (TTree*) file->Get("generated");
	vector <int> *gen_pid=0;
	vector <double> *gen_px=0,*gen_py=0,*gen_pz=0,*gen_vx=0,*gen_vy=0,*gen_vz=0;
	tree_generated->SetBranchAddress("pid",&gen_pid);   //particle ID 
	tree_generated->SetBranchAddress("px",&gen_px);     //momentum of the generated particle at target
	tree_generated->SetBranchAddress("py",&gen_py);
	tree_generated->SetBranchAddress("pz",&gen_pz);
	tree_generated->SetBranchAddress("vx",&gen_vx);    //vertex of the generated particle at target
	tree_generated->SetBranchAddress("vy",&gen_vy);
	tree_generated->SetBranchAddress("vz",&gen_vz);

	//--- flux
	//the real deal output from the GEMC simulation
	TTree *tree_flux = (TTree*) file->Get("flux");
	vector<int> *flux_id=0,*flux_hitn=0;
	vector<int> *flux_pid=0,*flux_mpid=0,*flux_tid=0,*flux_mtid=0,*flux_otid=0;
	vector<double> *flux_trackE=0,*flux_totEdep=0,*flux_avg_x=0,*flux_avg_y=0,*flux_avg_z=0,*flux_avg_lx=0,*flux_avg_ly=0,*flux_avg_lz=0,*flux_px=0,*flux_py=0,*flux_pz=0,*flux_vx=0,*flux_vy=0,*flux_vz=0,*flux_mvx=0,*flux_mvy=0,*flux_mvz=0,*flux_avg_t=0;
	tree_flux->SetBranchAddress("hitn",&flux_hitn);     // hit number
	tree_flux->SetBranchAddress("id",&flux_id);         //hitting detector ID
	tree_flux->SetBranchAddress("pid",&flux_pid);       //pid
	tree_flux->SetBranchAddress("mpid",&flux_mpid);     // mother pid
	tree_flux->SetBranchAddress("tid",&flux_tid);       // track id
	tree_flux->SetBranchAddress("mtid",&flux_mtid);     // mother track id
	tree_flux->SetBranchAddress("otid",&flux_otid);     // original track id
	tree_flux->SetBranchAddress("trackE",&flux_trackE);  // track energy of 1st step,  track here is G4 track
	tree_flux->SetBranchAddress("totEdep",&flux_totEdep); // totEdep in all steps, track here is G4 track
	tree_flux->SetBranchAddress("avg_x",&flux_avg_x);     //average x, weighted by energy deposition in each step
	tree_flux->SetBranchAddress("avg_y",&flux_avg_y);     //average y
	tree_flux->SetBranchAddress("avg_z",&flux_avg_z);     //average z
	tree_flux->SetBranchAddress("avg_lx",&flux_avg_lx);   // local average x 
	tree_flux->SetBranchAddress("avg_ly",&flux_avg_ly);   // local average y
	tree_flux->SetBranchAddress("avg_lz",&flux_avg_lz);   // local average z
	tree_flux->SetBranchAddress("px",&flux_px);          // px of 1st step
	tree_flux->SetBranchAddress("py",&flux_py);          // py of 1st step
	tree_flux->SetBranchAddress("pz",&flux_pz);          // pz of 1st step
	tree_flux->SetBranchAddress("vx",&flux_vx);          // x coordinate of 1st step
	tree_flux->SetBranchAddress("vy",&flux_vy);          // y coordinate of 1st step
	tree_flux->SetBranchAddress("vz",&flux_vz);          // z coordinate of 1st step
	tree_flux->SetBranchAddress("mvx",&flux_mvx);        // mother
	tree_flux->SetBranchAddress("mvy",&flux_mvy);
	tree_flux->SetBranchAddress("mvz",&flux_mvz);
	tree_flux->SetBranchAddress("avg_t",&flux_avg_t);     //average time stamp

	//---lgc
	//information recorded by lgc
	TTree* tree_solid_lgc= (TTree*) file->Get("solid_lgc");
	setup_tree_solid_lgc(tree_solid_lgc);

	//---SPD
	//information recorded by SPD
	TTree* tree_solid_spd= (TTree*) file->Get("solid_spd");
	setup_tree_solid_spd(tree_solid_spd);

	//---MRPC
	//information recorded by MRPC
	TTree *tree_solid_mrpc = (TTree*) file->Get("solid_mrpc");
	setup_tree_solid_mrpc(tree_solid_mrpc);

	TRandom3 rand;
	rand.SetSeed(0);
	
	long int N_events = (long int)tree_header->GetEntries();
	//debug
	//N_events=10000;
	cout << "total number of events : " << N_events << endl;	

	//----------------------------
	//      loop trees
	//---------------------------
	for(int loop_id=1;loop_id<=loop_time;loop_id++){
		cout<<"loop.....  "<<loop_id<<endl;
	
	for(long int i=0;i<N_events;i++){	  
// 			cout<<"event " << i<<endl;
// 			cout<<i<<"\r";
		
		//---
		//---header tree
		//---
		tree_header->GetEntry(i);
		double rate=var8->at(0);
		rate=rate/filenum/loop_time*add_norm;     ///---warning, should make sure filenum is right
		double x=var4->at(0);	
		double y=var5->at(0);
		double W=var6->at(0);		
		double Q2=var7->at(0);		
		//cout<<"header tree: "<<rate<<endl;
		

		//---
		//---generated tree
		//---
		tree_generated->GetEntry(i);
		int n_gen=gen_pid->size();
		//cout<<"generated : "<<n_gen<<endl;
		int pid_gen=0;
		double theta_gen=0,phi_gen=0,p_gen=0,px_gen=0,py_gen=0,pz_gen=0,vx_gen=0,vy_gen=0,vz_gen=0;      
	      //       cout << "gen_pid->size() " << gen_pid->size() << endl;        
		for (int j=0;j<gen_pid->size();j++) {
	      //       cout << gen_pid->at(j) << " " << gen_px->at(j) << endl;//<< " " << gen_py->at(j) << " " << gen_pz->at(j) << " " << gen_vx->at(j) << " " << gen_vy->at(j) << " " << gen_vz->at(j) << endl; 
		    pid_gen=gen_pid->at(j);
		    px_gen=gen_px->at(j);
		    py_gen=gen_py->at(j);
		    pz_gen=gen_pz->at(j);
		    vx_gen=gen_vx->at(j);
		    vy_gen=gen_vy->at(j);
		    vz_gen=gen_vz->at(j);
		    p_gen=sqrt(px_gen*px_gen+py_gen*py_gen+pz_gen*pz_gen);
		    theta_gen=acos(pz_gen/p_gen);
		    phi_gen=atan2(py_gen,px_gen);
		    
	      //       cout << "p_gen " << p_gen << endl; 
		    hgen_ThetaP->Fill(theta_gen*DEG,p_gen/1e3,rate);                  
		}		

		///////////////////////////////////////////////////////////////////////////////////////
		//       do trigger
		////////////////////////////////////////////////////////////////////////////////////////
		//---	
		//---flux tree
		//---
		tree_flux->GetEntry(i);
		
		double hit_phi_FAEC=1000,hit_phi_FASPD=1000,hit_phi_LASPD=1000;

		int pass_EC_electron_forward=0;
		int pass_EC_electron_large=0;
		int pass_EC_hadron=0;
		
		int trigger_e_FA_EC_sec[100],trigger_e_LA_EC_sec[100],trigger_h_FA_EC_sec[100];
		int trigger_e_FA_EC_pid[100],trigger_e_LA_EC_pid[100],trigger_h_FA_EC_pid[100];
		double trigger_e_FA_EC_p[100],trigger_e_LA_EC_p[100],trigger_h_FA_EC_p[100];
		double trigger_e_FA_EC_x[100],trigger_e_LA_EC_x[100],trigger_h_FA_EC_x[100];
		double trigger_e_FA_EC_y[100],trigger_e_LA_EC_y[100],trigger_h_FA_EC_y[100];
		double trigger_e_FA_EC_r[100],trigger_e_LA_EC_r[100],trigger_h_FA_EC_r[100];
		double trigger_e_FA_EC_vx[100],trigger_e_LA_EC_vx[100],trigger_h_FA_EC_vx[100];
		double trigger_e_FA_EC_vy[100],trigger_e_LA_EC_vy[100],trigger_h_FA_EC_vy[100];		
		double trigger_e_FA_EC_vr[100],trigger_e_LA_EC_vr[100],trigger_h_FA_EC_vr[100];
		double trigger_e_FA_EC_vz[100],trigger_e_LA_EC_vz[100],trigger_h_FA_EC_vz[100];		
		
		int counter_e_FA_EC=0,counter_e_LA_EC=0,counter_h_FA_EC=0;

		for (Int_t j=0;j<flux_hitn->size();j++) {
	    //       cout << "flux " << " !!! " << flux_hitn->at(j) << " " << flux_id->at(j) << " " << flux_pid->at(j) << " " << flux_mpid->at(j) << " " << flux_tid->at(j) << " " << flux_mtid->at(j) << " " << flux_trackE->at(j) << " " << flux_totEdep->at(j) << " " << flux_avg_x->at(j) << " " << flux_avg_y->at(j) << " " << flux_avg_z->at(j) << " " << flux_avg_lx->at(j) << " " << flux_avg_ly->at(j) << " " << flux_avg_lz->at(j) << " " << flux_px->at(j) << " " << flux_py->at(j) << " " << flux_pz->at(j) << " " << flux_vx->at(j) << " " << flux_vy->at(j) << " " << flux_vz->at(j) << " " << flux_mvx->at(j) << " " << flux_mvy->at(j) << " " << flux_mvz->at(j) << " " << flux_avg_t->at(j) << endl;  

		  int detector_ID=flux_id->at(j)/1000000;
		  int subdetector_ID=(flux_id->at(j)%1000000)/100000;
		  int subsubdetector_ID=((flux_id->at(j)%1000000)%100000)/10000;		  
		  int component_ID=flux_id->at(j)%10000;      

		double hit_vr=sqrt(pow(flux_vx->at(j),2)+pow(flux_vy->at(j),2))/1e1; //mm to cm
		double hit_vy=flux_vy->at(j)/1e1,hit_vx=flux_vx->at(j)/1e1,hit_vz=flux_vz->at(j)/1e1;           //mm to cm		  
		double hit_r=sqrt(pow(flux_avg_x->at(j),2)+pow(flux_avg_y->at(j),2))/1e1; //mm to cm
		double hit_y=flux_avg_y->at(j)/1e1,hit_x=flux_avg_x->at(j)/1e1,hit_z=flux_avg_z->at(j)/1e1;           //mm to cm		
		double hit_phi=atan2(hit_y,hit_x)*DEG;       //rad to  deg
		double hit_p=sqrt(flux_px->at(j)*flux_px->at(j)+flux_py->at(j)*flux_py->at(j)+flux_pz->at(j)*flux_pz->at(j))/1e3;  //MeV to GeV
		  
		  int hit_id=-1;
		  if (detector_ID==1 && subdetector_ID == 1 && subsubdetector_ID == 1) hit_id=0;
		  if (detector_ID==1 && subdetector_ID == 2 && subsubdetector_ID == 1) hit_id=1;	  
		  if (detector_ID==1 && subdetector_ID == 3 && subsubdetector_ID == 1) hit_id=2;	  
		  if (detector_ID==1 && subdetector_ID == 4 && subsubdetector_ID == 1) hit_id=3;	  
		  if (detector_ID==1 && subdetector_ID == 5 && subsubdetector_ID == 1) hit_id=4;	  
		  if (detector_ID==1 && subdetector_ID == 6 && subsubdetector_ID == 1) hit_id=5;	        
		  if (detector_ID==2 && subdetector_ID == 1 && subsubdetector_ID == 1) hit_id=6;
		  if (detector_ID==2 && subdetector_ID == 2 && subsubdetector_ID == 1) hit_id=7;	              
		  if (detector_ID==5 && subdetector_ID == 1 && subsubdetector_ID == 1) hit_id=8;
		  if (detector_ID==5 && subdetector_ID == 2 && subsubdetector_ID == 1) hit_id=9;	                          
		  if (detector_ID==3 && subdetector_ID == 1 && subsubdetector_ID == 1) hit_id=10;
		  if (detector_ID==3 && subdetector_ID == 2 && subsubdetector_ID == 1) hit_id=11;
		  
		  if (0<=hit_id && hit_id<=11){
		    hhit_xy[hit_id]->Fill(hit_x,hit_y);
		    hhit_PhiR[hit_id]->Fill(hit_phi,hit_r);		  
		  }
// 		  else cout << flux_id->at(j) << endl;
		  
		  if(hit_id==10 && flux_tid->at(j)==1) hit_phi_FAEC=hit_phi;
		  if(hit_id==8 && flux_tid->at(j)==1) hit_phi_FASPD=hit_phi;
		  if(hit_id==9 && flux_tid->at(j)==1) hit_phi_LASPD=hit_phi;
		  
// 		  if (0<=hit_id && hit_id<=11) hflux_hitxy[hit_id]->Fill(flux_avg_x->at(j)/10.,flux_avg_y->at(j)/10.);
	    //       else cout << "flux_id->at(j) " << flux_id->at(j) << endl;
		  
		  //check hit on EC and find sec_ec
		  if(hit_id==10){   //FAEC 
		    if (hit_r<105 || hit_r>235) continue; //trigger cut on R

		    int sec_ec=0;
		    int sec_shift=1.7;  // shift to match electron turning in field
		    if (hit_phi>=90+sec_shift) sec_ec=int((hit_phi-90-sec_shift)/12+1);
		    else sec_ec=int((hit_phi+360-90-sec_shift)/12+1);
// 	    	cout << " hit_phi " << hit_phi << " sec_ec " << sec_ec << endl;	
		    
		    //check trigger_e_FA_EC
		    double EC_efficiency=0;

		    if(Is_SIDIS_He3){
// 		    double hit_r_tmp;
// 		    if (105<=hit_r && hit_r<120) hit_r_tmp=100;     //trigger at 5GeV
// 		    else if(120<=hit_r && hit_r<135) hit_r_tmp=110; //trigger at 4GeV
// 		    else if(135<=hit_r && hit_r<149) hit_r_tmp=120; //trigger at 3GeV
// 		    else if(149<=hit_r && hit_r<163) hit_r_tmp=120; //trigger at 3GeV		    
// 		    else if(163<=hit_r && hit_r<177) hit_r_tmp=140; //trigger at 2GeV
// 		    else if(177<=hit_r && hit_r<191) hit_r_tmp=170; //trigger at 1GeV		    
// 		    else if(191<=hit_r && hit_r<235) hit_r_tmp=170; //trigger at 1GeV		       
// 		    else {hit_r_tmp=0; cout << "hit_r " << hit_r << " out of range"  << endl;}
		    
		    
// 		    double hit_r_tmp;
// 		    if (105<=hit_r && hit_r<115) hit_r_tmp=100;     //trigger at 5GeV
// 		    else if(115<=hit_r && hit_r<130) hit_r_tmp=110; //trigger at 4GeV
// 		    else if(130<=hit_r && hit_r<150) hit_r_tmp=120; //trigger at 3GeV
// 		    else if(150<=hit_r && hit_r<170) hit_r_tmp=120; //trigger at 3GeV		    
// 		    else if(170<=hit_r && hit_r<235) hit_r_tmp=120; //trigger at 3GeV		    
// 		    else {hit_r_tmp=0; cout << "hit_r " << hit_r << " out of range"  << endl;}
		    
		    //cut Q2>1.3		    
// 		    double hit_r_tmp;
// 		    if (105<=hit_r && hit_r<115) hit_r_tmp=100;     //trigger at 5GeV
// 		    else if(115<=hit_r && hit_r<130) hit_r_tmp=110; //trigger at 4GeV
// 		    else if(130<=hit_r && hit_r<150) hit_r_tmp=120; //trigger at 3GeV
// 		    else if(150<=hit_r && hit_r<170) hit_r_tmp=140; //trigger at 2GeV		    
// 		    else if(170<=hit_r && hit_r<235) hit_r_tmp=170; //trigger at 1GeV		    
// 		    else {hit_r_tmp=0; cout << "hit_r " << hit_r << " out of range"  << endl;}


		    //cut P>5GeV when theta<10deg, Q2>1.7GeV when theta>10deg		    
// 		    double hit_r_tmp;
// 		    if (105<=hit_r && hit_r<115) hit_r_tmp=100;     //trigger at 5GeV
// 		    else if(115<=hit_r && hit_r<130) hit_r_tmp=100; //trigger at 4GeV
// 		    else if(130<=hit_r && hit_r<150) hit_r_tmp=110; //trigger at 3GeV
// 		    else if(150<=hit_r && hit_r<170) hit_r_tmp=120; //trigger at 2GeV		    
// 		    else if(170<=hit_r && hit_r<235) hit_r_tmp=140; //trigger at 1GeV		    
// 		    else {hit_r_tmp=0; cout << "hit_r " << hit_r << " out of range"  << endl;}
		    
/*		    if(abs(int(flux_pid->at(j))) == 11)		      EC_efficiency=get_forward_electron_trigger_e_eff(hit_r_tmp, hit_p);		      
		    else if(int(flux_pid->at(j)) == 22)		      EC_efficiency=get_forward_electron_trigger_e_eff(hit_r_tmp, hit_p);	    
		    else if(abs(int(flux_pid->at(j))) == 211)		      EC_efficiency=get_forward_electron_trigger_pi_eff(hit_r_tmp, hit_p);		      
		    else if(abs(int(flux_pid->at(j))) == 321)		      EC_efficiency=0.5*get_forward_electron_trigger_pi_eff(hit_r_tmp, hit_p);		
		    else if(int(flux_pid->at(j)) == 130)		      EC_efficiency=0.5*get_forward_electron_trigger_pi_eff(hit_r_tmp, hit_p);   
		    else if(int(flux_pid->at(j)) == 2212)		      EC_efficiency=0.5*get_forward_electron_trigger_pi_eff(hit_r_tmp, hit_p);
		    else {EC_efficiency=0; 
		      if (Is_debug) cout << "unknown particle pid" << flux_pid->at(j) << endl;	      
		    }	*/	    
		    
		    if(abs(int(flux_pid->at(j))) == 11)		      EC_efficiency=get_forward_electron_trigger_e_eff(hit_r, hit_p);		      
		    else if(int(flux_pid->at(j)) == 22)		      EC_efficiency=get_forward_electron_trigger_e_eff(hit_r, hit_p);	    
		    else if(abs(int(flux_pid->at(j))) == 211)		      EC_efficiency=get_forward_electron_trigger_pi_eff(hit_r, hit_p);		      
		    else if(abs(int(flux_pid->at(j))) == 321)		      EC_efficiency=0.5*get_forward_electron_trigger_pi_eff(hit_r, hit_p);		
		    else if(int(flux_pid->at(j)) == 130)		      EC_efficiency=0.5*get_forward_electron_trigger_pi_eff(hit_r, hit_p);   
		    else if(int(flux_pid->at(j)) == 2212)		      EC_efficiency=0.5*get_forward_electron_trigger_pi_eff(hit_r, hit_p);
		    else {EC_efficiency=0; 
		      if (Is_debug) cout << "unknown particle pid" << flux_pid->at(j) << endl;	      
		    }
		    }
		    else if(Is_SIDIS_NH3){
// 		      EC_efficiency=1;		      
		      if ((-74<hit_phi && hit_phi<-38 && hit_r/1e1<195)||(-92<hit_phi && hit_phi<-88 && hit_r/1e1<120)||(50<hit_phi && hit_phi<80 && hit_r/1e1<195)) EC_efficiency=0;
		      else EC_efficiency=1;
		    }

		    //check to make sure eff is ok
		    if(isnan(EC_efficiency)) cout << "trigger_e_FA_EC " << EC_efficiency << " " << flux_pid->at(j) << endl;		    

		    if (rand.Uniform(0,1)<EC_efficiency){
		      bool Is_ok=false;
		      if (Is_tellorig){
			if (Is_singlefile){
			  if(Is_pi0){
			    if(abs(flux_pid->at(j))==11) Is_ok=true;
			  }
			  else {
			    if(flux_tid->at(j)==1) Is_ok=true;
			  }
			}
			else {
			  if(flux_tid->at(j)==1) Is_ok=true;
			}
		      }
		      else Is_ok=true;
			    
		      if(Is_ok){						
			pass_EC_electron_forward=1;
			counter_e_FA_EC++;
			trigger_e_FA_EC_sec[counter_e_FA_EC-1]=sec_ec;
			trigger_e_FA_EC_pid[counter_e_FA_EC-1]=flux_pid->at(j);		      
			trigger_e_FA_EC_p[counter_e_FA_EC-1]=hit_p;		      
			trigger_e_FA_EC_x[counter_e_FA_EC-1]=hit_x;
			trigger_e_FA_EC_y[counter_e_FA_EC-1]=hit_y;
			trigger_e_FA_EC_r[counter_e_FA_EC-1]=hit_r;		      		      
			trigger_e_FA_EC_vx[counter_e_FA_EC-1]=hit_vx;
			trigger_e_FA_EC_vy[counter_e_FA_EC-1]=hit_vy;
			trigger_e_FA_EC_vr[counter_e_FA_EC-1]=hit_vr;
			trigger_e_FA_EC_vz[counter_e_FA_EC-1]=hit_vz;			
		      }		      
		    }
		    
		    //check trigger_h_FA_EC
		    if(Is_SIDIS_He3){
		      
		    if(abs(int(flux_pid->at(j))) == 11){
		      double hit_Ekin=sqrt(hit_p*hit_p+0.511e-3*0.511e-3)-0.511e-3;
		      EC_efficiency=get_forward_hadron_trigger_e_eff(hit_Ekin);
		    }
		    else if(int(flux_pid->at(j)) == 22){
		      double hit_Ekin=hit_p;
		      EC_efficiency=get_forward_hadron_trigger_gamma_eff(hit_Ekin);	    
		    }
		    else if(abs(int(flux_pid->at(j))) == 211){ 		
		      double hit_Ekin=sqrt(hit_p*hit_p+0.14*0.14)-0.14;		      
		      EC_efficiency=get_forward_hadron_trigger_pion_eff(hit_Ekin);		      
		    }
		    else if(abs(int(flux_pid->at(j))) == 321){ 		
		      double hit_Ekin=sqrt(hit_p*hit_p+0.494*0.494)-0.494;		      
		      EC_efficiency=get_forward_hadron_trigger_pion_eff(hit_Ekin);		      
		    }
		    else if(int(flux_pid->at(j)) == 130){ 		
		      double hit_Ekin=sqrt(hit_p*hit_p+0.498*0.498)-0.498;		      
		      EC_efficiency=get_forward_hadron_trigger_pion_eff(hit_Ekin);		      
		    }		    
		    else if(int(flux_pid->at(j)) == 2212){
		      double hit_Ekin=sqrt(hit_p*hit_p+0.938*0.938)-0.938;		       
		      EC_efficiency=get_forward_hadron_trigger_proton_eff(hit_Ekin);
		    }
		    else {EC_efficiency=0; 
		      if (Is_debug) cout << "unknown particle pid" << flux_pid->at(j) << endl;	      
		    }
		    }
		    else if(Is_SIDIS_NH3){
		      EC_efficiency=1;
		    }
		    
		    //check to make sure eff is ok
		    if(isnan(EC_efficiency)) cout << "trigger_h_FA_EC " << EC_efficiency << " " << flux_pid->at(j) << endl;		    
		    
		    if (rand.Uniform(0,1)<EC_efficiency){
		      bool Is_ok=false;
		      if (Is_tellorig){
			if (Is_singlefile){
			  if(Is_pi0){
			    if(abs(flux_pid->at(j))==11) Is_ok=true;
			  }
			  else {
			    if(flux_tid->at(j)==1) Is_ok=true;
			  }
			}
			else {
			  if(flux_tid->at(j)==2) Is_ok=true;
			}
		      }
		      else Is_ok=true;
			    
		      if(Is_ok){     
		      pass_EC_hadron=1;		      
		      counter_h_FA_EC++;
		      trigger_h_FA_EC_sec[counter_h_FA_EC-1]=sec_ec;
		      trigger_h_FA_EC_pid[counter_h_FA_EC-1]=flux_pid->at(j);		      
		      trigger_h_FA_EC_p[counter_h_FA_EC-1]=hit_p;		      		      
		      trigger_h_FA_EC_x[counter_h_FA_EC-1]=hit_x;
		      trigger_h_FA_EC_y[counter_h_FA_EC-1]=hit_y;		      
		      trigger_h_FA_EC_r[counter_h_FA_EC-1]=hit_r;
		      trigger_h_FA_EC_vx[counter_h_FA_EC-1]=hit_vx;
		      trigger_h_FA_EC_vy[counter_h_FA_EC-1]=hit_vy;		      
		      trigger_h_FA_EC_vr[counter_h_FA_EC-1]=hit_vr;	
		      trigger_h_FA_EC_vz[counter_h_FA_EC-1]=hit_vz;		      
		      }
		    }	
		    
		  } //end of FAEC
		  
		  if(hit_id==11){   //LAEC 

		    if (hit_r<80 || hit_r>140) continue; //trigger cut on R

		    int sec_ec=0;
		    int sec_shift=0;  // shift to match electron turning in field
		    if (hit_phi>=90+sec_shift) sec_ec=int((hit_phi-90-sec_shift)/12+1);
		    else sec_ec=int((hit_phi+360-90-sec_shift)/12+1);
	    // 	cout << " hit_phi " << hit_phi << " sec_ec " << sec_ec << endl;	
		    
		    //check trigger_e_FA_EC
		    double EC_efficiency=0;
		    
		    if(Is_SIDIS_He3){
		      
		    if(abs(int(flux_pid->at(j))) == 11)		      EC_efficiency=get_large_electron_trigger_e_eff(hit_r, hit_p);		      
		    else if(int(flux_pid->at(j)) == 22)		      EC_efficiency=get_large_electron_trigger_e_eff(hit_r, hit_p);	    
		    else if(abs(int(flux_pid->at(j))) == 211)		      EC_efficiency=get_large_electron_trigger_pi_eff(hit_r, hit_p);		      
		    else if(abs(int(flux_pid->at(j))) == 321)		      EC_efficiency=0.5*get_large_electron_trigger_pi_eff(hit_r, hit_p);		      
		    else if(int(flux_pid->at(j)) == 130)		      EC_efficiency=0.5*get_large_electron_trigger_pi_eff(hit_r, hit_p);		      
		    else if(int(flux_pid->at(j)) == 2212)		      EC_efficiency=0.5*get_large_electron_trigger_pi_eff(hit_r, hit_p);
		    else {EC_efficiency=0; 
		      if (Is_debug) cout << "unknown particle pid" << flux_pid->at(j) << endl;	      
		    }
		    }
		    else if(Is_SIDIS_NH3){
// 		      EC_efficiency=1;
		      if ((-85<hit_phi && hit_phi<-60)||(65<hit_phi && hit_phi<85)) EC_efficiency=0;
		      else EC_efficiency=1;		      
		    }		    
		    
		    //check to make sure eff is ok
		    if(isnan(EC_efficiency)) cout << "trigger_e_LA_EC " << EC_efficiency << " " << flux_pid->at(j) << endl;				    
		    
		    if (rand.Uniform(0,1)<EC_efficiency){
		      bool Is_ok=false;		      
		      if (Is_tellorig){
			if (Is_singlefile){
			  if(Is_pi0){
			    if(abs(flux_pid->at(j))==11) Is_ok=true;
			  }
			  else {
			    if(flux_tid->at(j)==1) Is_ok=true;
			  }
			}
			else {
			  if(flux_tid->at(j)==1) Is_ok=true;
			}
		      }
		      else Is_ok=true;
		      
		      if(Is_ok){
		      pass_EC_electron_large=1;
		      counter_e_LA_EC++;
		      trigger_e_LA_EC_sec[counter_e_LA_EC-1]=sec_ec;
		      trigger_e_LA_EC_pid[counter_e_LA_EC-1]=flux_pid->at(j);		      
		      trigger_e_LA_EC_p[counter_e_LA_EC-1]=hit_p;		      		      
		      trigger_e_LA_EC_x[counter_e_LA_EC-1]=hit_x;
		      trigger_e_LA_EC_y[counter_e_LA_EC-1]=hit_y;		      
		      trigger_e_LA_EC_r[counter_e_LA_EC-1]=hit_r;
		      trigger_e_LA_EC_vx[counter_e_LA_EC-1]=hit_vx;
		      trigger_e_LA_EC_vy[counter_e_LA_EC-1]=hit_vy;		      
		      trigger_e_LA_EC_vr[counter_e_LA_EC-1]=hit_vr;
		      trigger_e_LA_EC_vz[counter_e_LA_EC-1]=hit_vz;		      
		      }
		    }
		  } // end of LAEC 
		    		
		}			

		if(Is_debug){
		if (counter_e_FA_EC==1 && counter_h_FA_EC==1 && counter_e_LA_EC==0) {}
		else if (counter_e_FA_EC==0 && counter_h_FA_EC==0 && counter_e_LA_EC==1) {}
		else if (counter_e_FA_EC==0 && counter_h_FA_EC==1 && counter_e_LA_EC==0) {}			
		else if (counter_e_FA_EC==0 && counter_h_FA_EC==0 && counter_e_LA_EC==0) {}		
		else cout << counter_e_FA_EC << " " << counter_h_FA_EC << " " << counter_e_LA_EC  << endl;
		}
		
		if(counter_e_FA_EC>0) hangle_FAEC_FASPD->Fill(hit_phi_FAEC-hit_phi_FASPD);
		if(counter_e_FA_EC>0) hangle_FAEC_LASPD->Fill(hit_phi_FAEC-hit_phi_LASPD);	
// 		hangle_FAEC_FASPD->Fill(hit_phi_FAEC-hit_phi_FASPD);
		
		//-----------------------	
		//--- lgc trigger
		//-----------------------
		tree_solid_lgc->GetEntry(i);

		int trigger_lgc[30]={0};
		int ntrigsecs_lgc=0;
		process_tree_solid_lgc_trigger(tree_solid_lgc,trigger_lgc,ntrigsecs_lgc,PMTthresh,PEthresh);	//---------------------------------------------------------------------------------------------------------
		//add in backgrounds based on parametrized lgc study	
// 			if(with_background_on_lgc){	
// 				int N_random_pe=(int)h_pe->GetRandom();
// 				if(N_random_pe!=0){
// 					for(int id_random_pe=0; id_random_pe<N_random_pe;id_random_pe++){
// 						sectorhits[rand.Integer(30)][rand.Integer(9)] += 1;
// 					}
// 				}
// 			
// 			}  //scater random electrons on pmts based on parametrized EM-only performance

	
		int pass_lgc=0;	
		if(ntrigsecs_lgc){
			pass_lgc=1;
			//cout<<"passed lgc"<<endl;
		}else{
			pass_lgc=0;
		}		
		
		//-----------------------	
		//--- spd trigger
		//-----------------------
		tree_solid_spd->GetEntry(i);
		
// 		int trigger_spd_FA[60][4]={0},trigger_spd_LA[60]={0};
		int trigger_spd_FA[240]={0},trigger_spd_LA[60]={0};
		int ntrigsecs_spd_FA=0,ntrigsecs_spd_LA=0;					
		process_tree_solid_spd_trigger(tree_solid_spd,trigger_spd_FA,trigger_spd_LA,ntrigsecs_spd_FA,ntrigsecs_spd_LA,spd_threshold_FA,spd_threshold_LA);

		int pass_spd_forward=0;		
		if(ntrigsecs_spd_FA){
			pass_spd_forward=1;
		}else{
			pass_spd_forward=0;
		}
		
		int pass_spd_large=0;		
		if(ntrigsecs_spd_LA){
			pass_spd_large=1;
		}else{
			pass_spd_large=0;
		}
		
		//---------------------
		//--- MRPC trigger
		//---------------------
		tree_solid_mrpc->GetEntry(i);
		
// 		int trigger_mrpc_FA[50][3]={0};		
		int trigger_mrpc_FA[150]={0};					
		int ntrigsecs_mrpc_FA=0;					
		process_tree_solid_mrpc_trigger(tree_solid_mrpc,trigger_mrpc_FA,ntrigsecs_mrpc_FA,mrpc_block_threshold_FA);

		int pass_mrpc=0;		
		if(ntrigsecs_mrpc_FA){
			pass_mrpc=1;
		}else{
			pass_mrpc=0;
		}
 		
		//---
		//---fill histograms based on trigger flag
		//---		
		//only LGC
		if(pass_lgc){
			h_n_trigger_sectors_LGC->Fill(ntrigsecs_lgc,rate);
		}

		//only spd
		if(pass_spd_forward){
			h_n_trigger_sectors_spd_FA->Fill(ntrigsecs_spd_FA,rate);
		}		
		if(pass_spd_large){
			h_n_trigger_sectors_spd_LA->Fill(ntrigsecs_spd_LA,rate);
		}
		
		//only mrpc
		if(pass_mrpc){
			h_n_trigger_sectors_mrpc->Fill(ntrigsecs_mrpc_FA,rate);
		}				


		int i_e_FA_EC_good[100]={0},i_e_LA_EC_good[100]={0},i_h_FA_EC_good[100]={0};
		
		//get single trigger rate, get counter first, then fill hist with correct weight	
		int counter_e_FA_EC_lgc=0,counter_e_FA_EC_lgc_spd=0,counter_e_FA_EC_lgc_spd_mrpc=0;
		for(int i_e_FA_EC=0; i_e_FA_EC<counter_e_FA_EC; i_e_FA_EC++){		  

		    int this_sec=trigger_e_FA_EC_sec[i_e_FA_EC];
		    int last_sec=-1,next_sec=-1;
		    if (this_sec==1) {last_sec=30;next_sec=2;}
		    else if (this_sec==30) {last_sec=29;next_sec=1;}
		    else {last_sec=this_sec-1;next_sec=this_sec+1;}		    		  

		    if (trigger_lgc[last_sec-1]==1 || trigger_lgc[this_sec-1]==1 || trigger_lgc[next_sec-1]==1){
		    
			counter_e_FA_EC_lgc++;			      
				
			double hit_phi=atan2(trigger_e_FA_EC_y[i_e_FA_EC], trigger_e_FA_EC_x[i_e_FA_EC])*DEG;			
			double hit_r=trigger_e_FA_EC_r[i_e_FA_EC]; // in cm			
			double hit_vr=trigger_e_FA_EC_vr[i_e_FA_EC]; // in cm
			double hit_vz=trigger_e_FA_EC_vz[i_e_FA_EC]; // in cm		

			hvertex_rz->Fill(hit_vz,hit_vr);			
			
			int sector_spd=0,block_spd=0;
// 			if(find_id_spd_LA(hit_phi,hit_r,sector_spd)){			
			if(find_id_spd_FA(hit_phi,hit_r,sector_spd,block_spd)){			
// 			 if(trigger_spd_FA[sector_spd-1][block_spd-1]==1){
			 if(trigger_spd_FA[(sector_spd-1)*4+block_spd-1]==1){	
// 			 if(trigger_spd_FA[(sector_spd-1)*4+1-1]==1){				  
// 			  if(ntrigsecs_spd_FA>0){
			  //from FAEC hit, check +-60 deg on FASPD to see any trigger
/*			 bool Is_ok=false;
			 for(int index_sector_spd=sector_spd-3; index_sector_spd<=sector_spd+3; index_sector_spd++){
			    int check_sector_spd=0;
			    if(index_sector_spd<1) check_sector_spd=index_sector_spd+60;
			    else if (index_sector_spd>60) check_sector_spd=index_sector_spd-60;
			    else check_sector_spd=index_sector_spd;

// 			    if (trigger_spd_LA[(check_sector_spd-1)]==1) Is_ok=true;	    
			    if (trigger_spd_FA[(check_sector_spd-1)*4+1-1]==1) Is_ok=true;
			 }
			 if(Is_ok){*/				 
// 			    if (hit_vz<95) counter_e_FA_EC_lgc_spd++;
			    counter_e_FA_EC_lgc_spd++;			    
			   
			    int sector_mrpc=0,block_mrpc=0;
// 			    if(find_id_mrpc_FA(hit_phi,hit_r,sector_mrpc,block_mrpc)){
// 			      if(trigger_mrpc_FA[sector_mrpc-1][block_mrpc-1]==1){			

				i_e_FA_EC_good[counter_e_FA_EC_lgc_spd_mrpc]=i_e_FA_EC;			
				
				counter_e_FA_EC_lgc_spd_mrpc++;				
				
// 				cout <<"event " << i<< " counter_e_FA " <<  counter_e_FA_EC_lgc_spd_mrpc << "\t" << trigger_e_FA_EC_pid[i_e_FA_EC] << " " << trigger_e_FA_EC_p[i_e_FA_EC] << " " << trigger_e_FA_EC_sec[i_e_FA_EC] << " " << 	trigger_e_FA_EC_r[i_e_FA_EC] << endl;	
// 			      }
// 			    }				   
			 }
			}	      
		    }	
		}
		h_counter_e_FA_EC->Fill(counter_e_FA_EC);		
		h_counter_e_FA_EC_lgc->Fill(counter_e_FA_EC_lgc);		
		h_counter_e_FA_EC_lgc_spd->Fill(counter_e_FA_EC_lgc_spd);			
		h_counter_e_FA_EC_lgc_spd_mrpc->Fill(counter_e_FA_EC_lgc_spd_mrpc);		
		for(int i_e_FA_EC=0; i_e_FA_EC<counter_e_FA_EC; i_e_FA_EC++){		  

		    h_trigger_e_FA_EC->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate/counter_e_FA_EC);	
// 		    h_trigger_e_FA_EC->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate); 
		    
		    int this_sec=trigger_e_FA_EC_sec[i_e_FA_EC];
		    int last_sec=-1,next_sec=-1;
		    if (this_sec==1) {last_sec=30;next_sec=2;}
		    else if (this_sec==30) {last_sec=29;next_sec=1;}
		    else {last_sec=this_sec-1;next_sec=this_sec+1;}		    		      

		    if (trigger_lgc[last_sec-1]==1 || trigger_lgc[this_sec-1]==1 || trigger_lgc[next_sec-1]==1){

			h_trigger_e_FA_EC_lgc->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate/counter_e_FA_EC_lgc);		      
// 			h_trigger_e_FA_EC_lgc->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate);		      		      
				
			double hit_phi=atan2(trigger_e_FA_EC_y[i_e_FA_EC], trigger_e_FA_EC_x[i_e_FA_EC])*DEG;			
			double hit_r=trigger_e_FA_EC_r[i_e_FA_EC]; // in cm
			double hit_vr=trigger_e_FA_EC_vr[i_e_FA_EC]; // in cm
			double hit_vz=trigger_e_FA_EC_vz[i_e_FA_EC]; // in cm		
			
			int sector_spd=0,block_spd=0;
// 			if(find_id_spd_LA(hit_phi,hit_r,sector_spd)){			
			if(find_id_spd_FA(hit_phi,hit_r,sector_spd,block_spd)){
// 			 if(trigger_spd_FA[sector_spd-1][block_spd-1]==1){			   
			 if(trigger_spd_FA[(sector_spd-1)*4+block_spd-1]==1){			 
// 			 if(trigger_spd_FA[(sector_spd-1)*4+1-1]==1){				  	
// 			  if(ntrigsecs_spd_FA>0){			  
			  //from FAEC hit, check +-90 deg on FASPD to see any trigger
/*			 bool Is_ok=false;
			 for(int index_sector_spd=sector_spd-3; index_sector_spd<=sector_spd+3; index_sector_spd++){
			    int check_sector_spd=0;
			    if(index_sector_spd<1) check_sector_spd=index_sector_spd+60;
			    else if (index_sector_spd>60) check_sector_spd=index_sector_spd-60;
			    else check_sector_spd=index_sector_spd;

// 			    if (trigger_spd_LA[(check_sector_spd-1)]==1) Is_ok=true;	    
			    if (trigger_spd_FA[(check_sector_spd-1)*4+1-1]==1) Is_ok=true;
			 }			
			 if(Is_ok){*/				 
// 			    if (hit_vz<95) h_trigger_e_FA_EC_lgc_spd->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate/counter_e_FA_EC_lgc_spd);	
			    h_trigger_e_FA_EC_lgc_spd->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate/counter_e_FA_EC_lgc_spd);	
// 			    h_trigger_e_FA_EC_lgc_spd->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate);	
			    
			    int sector_mrpc=0,block_mrpc=0;
// 			    if(find_id_mrpc_FA(hit_phi,hit_r,sector_mrpc,block_mrpc)){
// 			      if(trigger_mrpc_FA[sector_mrpc-1][block_mrpc-1]==1){			   							
				h_trigger_e_FA_EC_lgc_spd_mrpc->Fill(trigger_e_FA_EC_r[i_e_FA_EC], rate/counter_e_FA_EC_lgc_spd_mrpc);	
				
				hacceptance_ThetaP[0]->Fill(theta_gen*DEG,p_gen/1e3,rate/counter_e_FA_EC_lgc_spd_mrpc);             		
// 			      }
// 			    }				   
			 }
			}	      
		    }	
		}		

		int counter_e_LA_EC_spd=0;
		for(int i_e_LA_EC=0; i_e_LA_EC<counter_e_LA_EC; i_e_LA_EC++){
		  
		    double hit_phi=atan2(trigger_e_LA_EC_y[i_e_LA_EC],trigger_e_LA_EC_x[i_e_LA_EC])*DEG;			
		    double hit_r=trigger_e_LA_EC_r[i_e_LA_EC]; // in cm
		    
		    int sector_spd=0;
		    if(find_id_spd_LA(hit_phi,hit_r,sector_spd)){
		      if(trigger_spd_LA[sector_spd-1]==1){			   

			    i_e_LA_EC_good[counter_e_LA_EC_spd]=i_e_LA_EC;
			    counter_e_LA_EC_spd++;				
			    
// 			    cout << "event " << i<< " counter_e_LA " <<  counter_e_LA_EC_spd << "\t" << trigger_e_LA_EC_pid[i_e_LA_EC] << " " << trigger_e_LA_EC_p[i_e_LA_EC] << " " << trigger_e_LA_EC_sec[i_e_LA_EC] << " " << 	trigger_e_LA_EC_r[i_e_LA_EC] << endl;			   
		      }
		    }	    	  
		}
		h_counter_e_LA_EC->Fill(counter_e_LA_EC);				
		h_counter_e_LA_EC_spd->Fill(counter_e_LA_EC_spd);
		for(int i_e_LA_EC=0; i_e_LA_EC<counter_e_LA_EC; i_e_LA_EC++){

		    h_trigger_e_LA_EC->Fill(trigger_e_LA_EC_r[i_e_LA_EC],rate/counter_e_LA_EC);			    
		    double hit_phi=atan2(trigger_e_LA_EC_y[i_e_LA_EC], trigger_e_LA_EC_x[i_e_LA_EC])*DEG;			
		    double hit_r=trigger_e_LA_EC_r[i_e_LA_EC]; // in cm
		    
		    int sector_spd=0;
		    if(find_id_spd_LA(hit_phi,hit_r,sector_spd)){
		      if(trigger_spd_LA[sector_spd-1]==1){			   
										    
			    h_trigger_e_LA_EC_spd->Fill(trigger_e_LA_EC_r[i_e_LA_EC], rate/counter_e_LA_EC_spd);
			    
			    hacceptance_ThetaP[1]->Fill(theta_gen*DEG,p_gen/1e3,rate/counter_e_LA_EC_spd);             
		      }
		    }	      		  
		}		
		
		int counter_h_FA_EC_spd=0, counter_h_FA_EC_spd_mrpc=0;
		for(int i_h_FA_EC=0; i_h_FA_EC<counter_h_FA_EC; i_h_FA_EC++){
		  
			double hit_phi=atan2(trigger_h_FA_EC_y[i_h_FA_EC], trigger_h_FA_EC_x[i_h_FA_EC])*DEG;			
			double hit_r=trigger_h_FA_EC_r[i_h_FA_EC]; // in cm
			
			int sector_spd=0,block_spd=0;
			if(find_id_spd_FA(hit_phi,hit_r,sector_spd,block_spd)){

// 			 if(trigger_spd_FA[sector_spd-1][block_spd-1]==1){
			 if(trigger_spd_FA[(sector_spd-1)*4+block_spd-1]==1){			   
			  //from FAEC hit, check +-60 deg on FASPD to see any trigger
// 			 bool Is_ok=false;
// 			 for(int index_sector_spd=sector_spd-10; index_sector_spd<=sector_spd+10; index_sector_spd++){
// 			    int check_sector_spd=0;
// 			    if(index_sector_spd<1) check_sector_spd=index_sector_spd+60;
// 			    else if (index_sector_spd>60) check_sector_spd=index_sector_spd-60;
// 			    else check_sector_spd=index_sector_spd;
// 
// 			    if (trigger_spd_FA[(check_sector_spd-1)*4+1-1]==1) Is_ok=true;
// 			 }
// 			 if(Is_ok){
			    counter_h_FA_EC_spd++;			   
			   
			    int sector_mrpc=0,block_mrpc=0;
// 			    if(find_id_mrpc_FA(hit_phi,hit_r,sector_mrpc,block_mrpc)){
// 			      if(trigger_mrpc_FA[sector_mrpc-1][block_mrpc-1]==1){		   					
				i_h_FA_EC_good[counter_h_FA_EC_spd_mrpc]=i_h_FA_EC;
				
				counter_h_FA_EC_spd_mrpc++;
			
// 				cout << "event " << i<< " counter_h_FA " << counter_h_FA_EC_spd_mrpc << "\t" << trigger_h_FA_EC_pid[i_h_FA_EC] << " " << trigger_h_FA_EC_p[i_h_FA_EC] << " " << trigger_h_FA_EC_sec[i_h_FA_EC] << " " << 	trigger_h_FA_EC_r[i_h_FA_EC] << endl;	
// 			      }
// 			    }
			 }
			}			  
		}
		h_counter_h_FA_EC->Fill(counter_h_FA_EC);		
		h_counter_h_FA_EC_spd->Fill(counter_h_FA_EC_spd);			
		h_counter_h_FA_EC_spd_mrpc->Fill(counter_h_FA_EC_spd_mrpc);		
		for(int i_h_FA_EC=0; i_h_FA_EC<counter_h_FA_EC; i_h_FA_EC++){

			h_trigger_h_FA_EC->Fill(trigger_h_FA_EC_r[i_h_FA_EC], rate/counter_h_FA_EC);    
		    
			double hit_phi=atan2(trigger_h_FA_EC_y[i_h_FA_EC], trigger_h_FA_EC_x[i_h_FA_EC])*DEG;			
			double hit_r=trigger_h_FA_EC_r[i_h_FA_EC]; // in cm
			
			int sector_spd=0,block_spd=0;
			if(find_id_spd_FA(hit_phi,hit_r,sector_spd,block_spd)){
			  
// 			 if(trigger_spd_FA[sector_spd-1][block_spd-1]==1){			   
			 if(trigger_spd_FA[(sector_spd-1)*4+block_spd-1]==1){			   	
			  //from FAEC hit, check +-60 deg on FASPD to see any trigger
/*			 bool Is_ok=false;
			 for(int index_sector_spd=sector_spd-10; index_sector_spd<=sector_spd+10; index_sector_spd++){
			    int check_sector_spd=0;
			    if(index_sector_spd<1) check_sector_spd=index_sector_spd+60;
			    else if (index_sector_spd>60) check_sector_spd=index_sector_spd-60;
			    else check_sector_spd=index_sector_spd;

			    if (trigger_spd_FA[(check_sector_spd-1)*4+1-1]==1) Is_ok=true;
			 }
			 if(Is_ok){*/			  

			    h_trigger_h_FA_EC_spd->Fill(trigger_h_FA_EC_r[i_h_FA_EC], rate/counter_h_FA_EC_spd);				    
			   
			    int sector_mrpc=0,block_mrpc=0;
// 			    if(find_id_mrpc_FA(hit_phi,hit_r,sector_mrpc,block_mrpc)){
// 			      if(trigger_mrpc_FA[sector_mrpc-1][block_mrpc-1]==1){		   							
				h_trigger_h_FA_EC_spd_mrpc->Fill(trigger_h_FA_EC_r[i_h_FA_EC], rate/counter_h_FA_EC_spd_mrpc);	
// 			      }
// 			    }	
			 }
			}	  
		}	
		
		int counter_e_FA_h_FA=0;
		for(int k=0; k<counter_e_FA_EC_lgc_spd_mrpc; k++){		
		  for(int j=0; j<counter_h_FA_EC_spd_mrpc; j++){
		    double dist=sqrt(pow(trigger_e_FA_EC_y[i_e_FA_EC_good[k]]-trigger_h_FA_EC_y[i_h_FA_EC_good[j]],2)+pow(trigger_e_FA_EC_x[i_e_FA_EC_good[k]]-trigger_h_FA_EC_x[i_h_FA_EC_good[j]],2));
		    if (dist>=threshold_distance){
		      counter_e_FA_h_FA++;
		      
// 		      cout << "event " << i<< " counter_e_FA_h_FA " << counter_e_FA_h_FA << "\t" << trigger_e_FA_EC_pid[i_e_FA_EC_good[k]] << " " << trigger_h_FA_EC_pid[i_h_FA_EC_good[j]] << " " <<  trigger_e_FA_EC_sec[i_e_FA_EC_good[k]] << " " << trigger_h_FA_EC_sec[i_h_FA_EC_good[j]] << " " <<		      trigger_e_FA_EC_p[i_e_FA_EC_good[k]] << " " << trigger_h_FA_EC_p[i_h_FA_EC_good[j]] << endl;			      		      
		    }
		  }
		}
		h_counter_e_FA_h_FA->Fill(counter_e_FA_h_FA);
		for(int k=0; k<counter_e_FA_EC_lgc_spd_mrpc; k++){		
		  for(int j=0; j<counter_h_FA_EC_spd_mrpc; j++){
		    double dist=sqrt(pow(trigger_e_FA_EC_y[i_e_FA_EC_good[k]]-trigger_h_FA_EC_y[i_h_FA_EC_good[j]],2)+pow(trigger_e_FA_EC_x[i_e_FA_EC_good[k]]-trigger_h_FA_EC_x[i_h_FA_EC_good[j]],2));
		    if (dist>=threshold_distance) h_trigger_e_FA_h_FA->Fill(trigger_e_FA_EC_r[i_e_FA_EC_good[k]],rate/counter_e_FA_h_FA);
		  }
		}	
		
		int counter_e_LA_h_FA=0;		
		for(int k=0; k<counter_e_LA_EC_spd; k++){		
		  for(int j=0; j<counter_h_FA_EC_spd_mrpc; j++){
		    counter_e_LA_h_FA++;
		    
// 		      cout << "event " << i<< " counter_e_LA_h_FA " << counter_e_LA_h_FA << "\t" << trigger_e_LA_EC_pid[i_e_LA_EC_good[k]] << " " << trigger_h_FA_EC_pid[i_h_FA_EC_good[j]] << " " << trigger_e_LA_EC_sec[i_e_LA_EC_good[k]] << " " << trigger_h_FA_EC_sec[i_h_FA_EC_good[j]] << " " << trigger_e_LA_EC_sec[i_e_LA_EC_good[k]] << " " << trigger_h_FA_EC_sec[i_h_FA_EC_good[j]] << endl;	 		      
		  }
		}
		h_counter_e_LA_h_FA->Fill(counter_e_LA_h_FA);
		for(int k=0; k<counter_e_LA_EC_spd; k++){		
		  for(int j=0; j<counter_h_FA_EC_spd_mrpc; j++){
		    h_trigger_e_LA_h_FA->Fill(trigger_e_LA_EC_r[i_e_LA_EC_good[k]],rate/counter_e_LA_h_FA);
		  }
		}		
		

	} //end event loop
	
	} //end loop time


/*
	TCanvas *can=new TCanvas("can","can");
	can->cd();

	h_flux_EC_lgc->Draw();
	cout<<"EC&lgc trigger rate:"<<h_flux_EC_lgc->Integral(1,60)<<endl;

*/
	//do outputs

TCanvas *c_hit = new TCanvas("hit","hit",1800,800);
c_hit->Divide(n,2);
for(int i=0;i<n;i++){
c_hit->cd(i+1);
gPad->SetLogz(1);
hhit_xy[i]->Draw("colz");
c_hit->cd(n+i+1);
gPad->SetLogz(1);
hhit_PhiR[i]->Draw("colz");
}	
	
TCanvas *c_gen = new TCanvas("gen","gen",900,800);
hgen_ThetaP->Draw("colz");
gPad->SetLogz(1);

TCanvas *c_acc = new TCanvas("acc","acc",1800,800);
c_acc->Divide(2,1);
c_acc->cd(1);
hacceptance_ThetaP[0]->Divide(hacceptance_ThetaP[0],hgen_ThetaP);  
hacceptance_ThetaP[0]->SetMinimum(0);  
hacceptance_ThetaP[0]->SetMaximum(1);    
hacceptance_ThetaP[0]->Draw("colz");
c_acc->cd(2);
hacceptance_ThetaP[1]->Divide(hacceptance_ThetaP[1],hgen_ThetaP);  
hacceptance_ThetaP[1]->SetMinimum(0);  
hacceptance_ThetaP[1]->SetMaximum(1);    
hacceptance_ThetaP[1]->Draw("colz");

TCanvas *c_trigger_onedet = new TCanvas("trigger_onedet", "trigger_onedet",1400,900);
c_trigger_onedet->Divide(4,2);
c_trigger_onedet->cd(1);
h_trigger_e_FA_EC->Draw();
c_trigger_onedet->cd(2);
h_trigger_e_LA_EC->Draw();
c_trigger_onedet->cd(3);
h_trigger_h_FA_EC->Draw();
c_trigger_onedet->cd(4);
h_n_trigger_sectors_LGC->Draw();
c_trigger_onedet->cd(5);
h_n_trigger_sectors_spd_FA->Draw();
c_trigger_onedet->cd(6);
h_n_trigger_sectors_spd_LA->Draw();
c_trigger_onedet->cd(7);
h_n_trigger_sectors_mrpc->Draw();

cout<<"only h_trigger_e_FA_EC in kHz: "<<h_trigger_e_FA_EC->Integral(1,60)/1e3<<endl;
cout<<"only h_trigger_e_LA_EC in kHz: "<<h_trigger_e_LA_EC->Integral(1,60)/1e3<<endl;
cout<<"only h_trigger_h_FA_EC in kHz: "<<h_trigger_h_FA_EC->Integral(1,60)/1e3<<endl;
cout<<"only lgc in kHz: "<<h_n_trigger_sectors_LGC->Integral(1,30)/1e3<<endl;
cout<<"only spd FA in kHz: "<<h_n_trigger_sectors_spd_FA->Integral(1,240)/1e3<<endl;
cout<<"only spd LA in kHz: "<<h_n_trigger_sectors_spd_LA->Integral(1,240)/1e3<<endl;
cout<<"only mrpc in kHz: "<<h_n_trigger_sectors_mrpc->Integral(1,240)/1e3<<endl;
// cout<<"EC lgc spd mrpc be fired in kHz: "<<h_flux_EC_lgc_spd_mrpc->Integral(1,60)<<endl;	

// cout<<"$$$$$$$$$$$$$$$   :"<<h_flux_EC_electron->Integral(1,60)<<"	"<<h_flux_EC_hadron->Integral(1,60)<<endl;

TCanvas *c_counter = new TCanvas("counter", "counter",1400,900);
c_counter->Divide(4,4);
c_counter->cd(1);
h_counter_e_FA_EC->Draw();
gPad->SetLogy();
c_counter->cd(2);
h_counter_e_FA_EC_lgc->Draw();
gPad->SetLogy();
c_counter->cd(3);
h_counter_e_FA_EC_lgc_spd->Draw();
gPad->SetLogy();
c_counter->cd(4);
h_counter_e_FA_EC_lgc_spd_mrpc->Draw();
gPad->SetLogy();
c_counter->cd(5);
h_counter_e_LA_EC->Draw();
gPad->SetLogy();
c_counter->cd(6);
h_counter_e_LA_EC_spd->Draw();
gPad->SetLogy();
c_counter->cd(9);
h_counter_h_FA_EC->Draw();
gPad->SetLogy();
c_counter->cd(10);
h_counter_h_FA_EC_spd->Draw();
gPad->SetLogy();
c_counter->cd(11);
h_counter_h_FA_EC_spd_mrpc->Draw();
gPad->SetLogy();
c_counter->cd(13);
h_counter_e_FA_h_FA->Draw();
gPad->SetLogy();
c_counter->cd(14);
h_counter_e_LA_h_FA->Draw();
gPad->SetLogy();



TCanvas *c_trigger = new TCanvas("trigger", "trigger",1400,900);
c_trigger->Divide(4,4);
c_trigger->cd(1);
h_trigger_e_FA_EC->Draw();
c_trigger->cd(2);
h_trigger_e_FA_EC_lgc->Draw();
c_trigger->cd(3);
h_trigger_e_FA_EC_lgc_spd->Draw();
c_trigger->cd(4);
h_trigger_e_FA_EC_lgc_spd_mrpc->Draw();
c_trigger->cd(5);
h_trigger_e_LA_EC->Draw();
c_trigger->cd(6);
h_trigger_e_LA_EC_spd->Draw();
c_trigger->cd(9);
h_trigger_h_FA_EC->Draw();
c_trigger->cd(10);
h_trigger_h_FA_EC_spd->Draw();
c_trigger->cd(11);
h_trigger_h_FA_EC_spd_mrpc->Draw();
c_trigger->cd(13);
h_trigger_e_FA_h_FA->Draw();
c_trigger->cd(14);
h_trigger_e_LA_h_FA->Draw();

   
cout<<"only h_trigger_e_FA in kHz: "<<h_trigger_e_FA_EC->Integral(1,60)/1e3<<" "<<h_trigger_e_FA_EC_lgc->Integral(1,60)/1e3<<" "<<h_trigger_e_FA_EC_lgc_spd->Integral(1,60)/1e3<<" "<<h_trigger_e_FA_EC_lgc_spd_mrpc->Integral(1,60)/1e3<< endl;
cout<<"only h_trigger_e_LA in kHz: "<<h_trigger_e_LA_EC->Integral(1,60)/1e3<<" "<<h_trigger_e_LA_EC_spd->Integral(1,60)/1e3<< endl;
cout<<"only h_trigger_h_FA in kHz: "<<h_trigger_h_FA_EC->Integral(1,60)/1e3<<" "<<h_trigger_h_FA_EC_spd->Integral(1,60)/1e3<<" "<<h_trigger_h_FA_EC_spd_mrpc->Integral(1,60)/1e3<<" "<<endl;
cout<<"only h_trigger_e_FA_h_FA in kHz: "<<h_trigger_e_FA_h_FA->Integral(1,60)/1e3<< endl; 
cout<<"only h_trigger_e_LA_h_FA in kHz: "<<h_trigger_e_LA_h_FA->Integral(1,60)/1e3<< endl;

TCanvas *c_vertex = new TCanvas("vertex", "vertex",1400,900);
hvertex_rz->Draw("colz");

TCanvas *c_angle_FAEC_FASPD = new TCanvas("angle_FAEC_FASPD", "angle_FAEC_FASPD",1400,900);
hangle_FAEC_FASPD->Draw();

TCanvas *c_angle_FAEC_LASPD = new TCanvas("angle_FAEC_LASPD", "angle_FAEC_LASPD",1400,900);
hangle_FAEC_LASPD->Draw();

// 	h_flux_EC_electron->SetDirectory(output_file);
// 	output_file->Write();
/*

	ofstream OUTPUT_rate;
	
	//OUTPUT_rate.open("SIDIS_LGC_singles.txt");
	//OUTPUT_rate.open("SIDIS_EC_singles.txt");
	//OUTPUT_rate.open("SIDIS_spd_singles.txt");
	//OUTPUT_rate.open("SIDIS_mrpc_singles.txt");
	//OUTPUT_rate.open("SIDIS_EC_lgc_spd_mrpc.txt");
	
	OUTPUT_rate.open("SIDIS_truth.txt");
	
	if(!OUTPUT_rate){
		cout<<"can't open output file"<<endl;
		return 1;
	}
	
	//OUTPUT_rate<<"EC be fired only: "<<h_flux_EC->Integral(1,60)<<endl;
	//OUTPUT_rate<<"EC&lgc both fired:"<<h_flux_EC_lgc->Integral(1,60)<<endl;
	//OUTPUT_rate<<"EC but no lgc fired:"<<h_flux_EC_no_lgc->Integral(1,60)<<endl;
	//OUTPUT_rate<<"LGC be fired only: "<<h_n_trigger_sectors_LGC->Integral(1,30)<<endl;
	//OUTPUT_rate<<"SPD be fired only: "<<h_n_trigger_sectors_spd->Integral(1,240)<<endl;
	//OUTPUT_rate<<"mrpc be fired only: "<<h_n_trigger_sectors_mrpc->Integral(1,240)<<endl;
	OUTPUT_rate<<"SIDIS truth: "<<h_flux_EC->Integral(1,60)<<endl;

	TFile *output_file=new TFile("SIDIS_LGC_singles.root","RECREATE");
	//TFile *output_file=new TFile("SIDIS_EC_singles.root","RECREATE");
	//TFile *output_file=new TFile("SIDIS_spd_singles.root","RECREATE");
	//TFile *output_file=new TFile("SIDIS_mrpc_singles.root","RECREATE");
	//TFile *output_file=new TFile("SIDIS_EC_lgc_spd_mrpc.root","RECREATE");
	TFile *output_file=new TFile("SIDIS_truth.root","RECREATE");
	
	//h_flux_EC->SetDirectory(output_file);
	//h_flux_EC_lgc->SetDirectory(output_file);
	//h_flux_EC_no_lgc->SetDirectory(output_file);	
	//h_n_trigger_sectors_LGC->SetDirectory(output_file);
	//h_n_trigger_sectors_spd->SetDirectory(output_file);
	//h_n_trigger_sectors_mrpc->SetDirectory(output_file);
	//h_trigger_e_FA->SetDirectory(output_file);
	h_flux_EC->SetDirectory(output_file);
	
	output_file->Write();

*/

}
