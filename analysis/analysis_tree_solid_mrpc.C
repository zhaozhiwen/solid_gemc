#include <iostream> 
#include <fstream>
#include <cmath> 
#include <math.h> 
#include <TCanvas.h>
#include <TFile.h>
#include <TTree.h>
#include <TChain.h>
#include <TH1.h>
#include <TH2.h>
#include <TH3.h>
#include <TF1.h>
#include <TLorentzVector.h>
#include <TROOT.h>
#include <TStyle.h>
#include <TMinuit.h>
#include <TPaveText.h>
#include <TText.h>
#include <TSystem.h>
#include <TArc.h>
#include <TMath.h>

using namespace std;

vector<int> *solid_mrpc_id=0,*solid_mrpc_hitn=0;
vector<int> *solid_mrpc_pid=0,*solid_mrpc_mpid=0,*solid_mrpc_tid=0,*solid_mrpc_mtid=0,*solid_mrpc_otid=0;
vector<double> *solid_mrpc_trackE=0,*solid_mrpc_totEdep=0,*solid_mrpc_avg_x=0,*solid_mrpc_avg_y=0,*solid_mrpc_avg_z=0,*solid_mrpc_avg_lx=0,*solid_mrpc_avg_ly=0,*solid_mrpc_avg_lz=0,*solid_mrpc_px=0,*solid_mrpc_py=0,*solid_mrpc_pz=0,*solid_mrpc_vx=0,*solid_mrpc_vy=0,*solid_mrpc_vz=0,*solid_mrpc_mvx=0,*solid_mrpc_mvy=0,*solid_mrpc_mvz=0,*solid_mrpc_avg_t=0;

void setup_tree_solid_mrpc(TTree *tree_solid_mrpc)
{  
tree_solid_mrpc->SetBranchAddress("hitn",&solid_mrpc_hitn);
tree_solid_mrpc->SetBranchAddress("id",&solid_mrpc_id);
tree_solid_mrpc->SetBranchAddress("pid",&solid_mrpc_pid);
tree_solid_mrpc->SetBranchAddress("mpid",&solid_mrpc_mpid);
tree_solid_mrpc->SetBranchAddress("tid",&solid_mrpc_tid);
tree_solid_mrpc->SetBranchAddress("mtid",&solid_mrpc_mtid);
tree_solid_mrpc->SetBranchAddress("otid",&solid_mrpc_otid);
tree_solid_mrpc->SetBranchAddress("trackE",&solid_mrpc_trackE);
tree_solid_mrpc->SetBranchAddress("totEdep",&solid_mrpc_totEdep);
tree_solid_mrpc->SetBranchAddress("avg_x",&solid_mrpc_avg_x);
tree_solid_mrpc->SetBranchAddress("avg_y",&solid_mrpc_avg_y);
tree_solid_mrpc->SetBranchAddress("avg_z",&solid_mrpc_avg_z);
tree_solid_mrpc->SetBranchAddress("avg_lx",&solid_mrpc_avg_lx);
tree_solid_mrpc->SetBranchAddress("avg_ly",&solid_mrpc_avg_ly);
tree_solid_mrpc->SetBranchAddress("avg_lz",&solid_mrpc_avg_lz);
tree_solid_mrpc->SetBranchAddress("px",&solid_mrpc_px);
tree_solid_mrpc->SetBranchAddress("py",&solid_mrpc_py);
tree_solid_mrpc->SetBranchAddress("pz",&solid_mrpc_pz);
tree_solid_mrpc->SetBranchAddress("vx",&solid_mrpc_vx);
tree_solid_mrpc->SetBranchAddress("vy",&solid_mrpc_vy);
tree_solid_mrpc->SetBranchAddress("vz",&solid_mrpc_vz);
tree_solid_mrpc->SetBranchAddress("mvx",&solid_mrpc_mvx);
tree_solid_mrpc->SetBranchAddress("mvy",&solid_mrpc_mvy);
tree_solid_mrpc->SetBranchAddress("mvz",&solid_mrpc_mvz);
tree_solid_mrpc->SetBranchAddress("avg_t",&solid_mrpc_avg_t);

return ;

}

bool find_id_mrpc_FA(double hit_phi,double r,int &sector,int &block,bool Is_debug=false)
{  
  double DEG=180./3.1415926;   //rad to degree  
  
  int sec_shift=0;  // shift to match electron turning in field
  if (hit_phi>=90+sec_shift) sector=int((hit_phi-90-sec_shift)/7.2+1);
  else sector=int((hit_phi+360-90-sec_shift)/7.2+1);			

  //block from 105 to 210cm with 15,30,60cm length		  
  if(105<=r && r<120){
	  block=0;
  }else if(120<=r && r<150){
	  block=1;
  }else if(150<=r && r<210){
	  block=2;
  }	
  //do a check for index
  if(sector<1||sector>50 || block<1 || block>3){
	  if(Is_debug) cout<<"MRPC index is wrong "<<sector<<"	"<<block<<endl;
	  return false;
  }
  else return true; 
}

bool process_tree_solid_mrpc_trigger(TTree *tree_solid_mrpc,int *trigger_mrpc_FA,int &ntrigsecs_mrpc_FA,double mrpc_block_threshold_FA = 5,bool Is_debug=false)
{
    double DEG=180./3.1415926;   //rad to degree  
  
    double mrpc_edep_threshold=16.0e-6; //in unit of MeV

    double  counter_mrpc_FA[50][3][10] = {0};    //50 sector, 3 blocks, 10 gas layers
    ntrigsecs_mrpc_FA=0;
    
    //loop over data tree
    for (int j=0;j<solid_mrpc_hitn->size();j++) {

    int detector_ID=solid_mrpc_id->at(j)/1000000;
    int subdetector_ID=(solid_mrpc_id->at(j)%1000000)/100000;
    int subsubdetector_ID=((solid_mrpc_id->at(j)%1000000)%100000)/10000;
    int component_ID=solid_mrpc_id->at(j)%10000;

    if (detector_ID==4 && subdetector_ID == 1 && subsubdetector_ID == 0){//in gas
      
      if(component_ID<1 || component_ID>10){
	      cout<<"MRPC index is wrong "<<solid_mrpc_id->at(j)<<endl;
	      continue;
      }		  
      
      double hit_phi=atan2(solid_mrpc_avg_y->at(j), solid_mrpc_avg_x->at(j))*DEG;  //(-180,180)
      double r=sqrt(solid_mrpc_avg_y->at(j)*solid_mrpc_avg_y->at(j)+solid_mrpc_avg_x->at(j)*solid_mrpc_avg_x->at(j))/10.; // in cm
				    
      int sector=0,block=0;
      if (find_id_mrpc_FA(hit_phi,r,sector,block,Is_debug)){	    
	if (solid_mrpc_totEdep->at(j)>mrpc_edep_threshold){
		counter_mrpc_FA[sector-1][block-1][component_ID-1] ++;
	}
      }

      }  // process this hit is done

    } // process all the hits

    for(int l_sec=0; l_sec< 50; l_sec++){
	for(int l_block=0; l_block<3; l_block++){
		int sum_hit=0;					
		for(int l_component_ID=0; l_component_ID<10; l_component_ID++){
			if(counter_mrpc_FA[l_sec][l_block][l_component_ID]>0) sum_hit++;
		}
		
		if(sum_hit>mrpc_block_threshold_FA) {
		  ntrigsecs_mrpc_FA++;
// 		  trigger_mrpc_FA[l_sec][l_block]=1;
		  trigger_mrpc_FA[l_sec*3+l_block]=1;		  
		}
	}
    }	
    
    return true;

}


