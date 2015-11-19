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

double process_tree_solid_mrpc(TTree *tree_solid_mrpc)
{
  double totEdep=0;
//     for (Int_t j=0;j<1;j++) {  
    for (Int_t j=0;j<solid_mrpc_hitn->size();j++) {
//       cout << "solid_mrpc " << " !!! " << solid_mrpc_hitn->at(j) << " " << solid_mrpc_id->at(j) << " " << solid_mrpc_pid->at(j) << " " << solid_mrpc_mpid->at(j) << " " << solid_mrpc_tid->at(j) << " " << solid_mrpc_mtid->at(j) << " " << solid_mrpc_trackE->at(j) << " " << solid_mrpc_totEdep->at(j) << " " << solid_mrpc_avg_x->at(j) << " " << solid_mrpc_avg_y->at(j) << " " << solid_mrpc_avg_z->at(j) << " " << solid_mrpc_avg_lx->at(j) << " " << solid_mrpc_avg_ly->at(j) << " " << solid_mrpc_avg_lz->at(j) << " " << solid_mrpc_px->at(j) << " " << solid_mrpc_py->at(j) << " " << solid_mrpc_pz->at(j) << " " << solid_mrpc_vx->at(j) << " " << solid_mrpc_vy->at(j) << " " << solid_mrpc_vz->at(j) << " " << solid_mrpc_mvx->at(j) << " " << solid_mrpc_mvy->at(j) << " " << solid_mrpc_mvz->at(j) << " " << solid_mrpc_avg_t->at(j) << endl;  

      int detector_ID=solid_mrpc_id->at(j)/1000000;
      int subdetector_ID=(solid_mrpc_id->at(j)%1000000)/100000;
      int subsubdetector_ID=((solid_mrpc_id->at(j)%1000000)%100000)/10000;
      int component_ID=solid_mrpc_id->at(j)%10000;
      
    cout << detector_ID << " " << subdetector_ID << " "  << subsubdetector_ID  << " " << component_ID << ", " << solid_mrpc_totEdep->at(j) << endl; 
           
      if (detector_ID==4 && subdetector_ID == 1 && subsubdetector_ID == 0) totEdep +=solid_mrpc_totEdep->at(j);     
         
    }    

return totEdep;

}

