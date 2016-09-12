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

vector<int> *solid_ec_id=0,*solid_ec_hitn=0;
vector<int> *solid_ec_pid=0,*solid_ec_mpid=0,*solid_ec_tid=0,*solid_ec_mtid=0,*solid_ec_otid=0;
vector<double> *solid_ec_trackE=0,*solid_ec_totEdep=0,*solid_ec_avg_x=0,*solid_ec_avg_y=0,*solid_ec_avg_z=0,*solid_ec_avg_lx=0,*solid_ec_avg_ly=0,*solid_ec_avg_lz=0,*solid_ec_px=0,*solid_ec_py=0,*solid_ec_pz=0,*solid_ec_vx=0,*solid_ec_vy=0,*solid_ec_vz=0,*solid_ec_mvx=0,*solid_ec_mvy=0,*solid_ec_mvz=0,*solid_ec_avg_t=0;

void setup_tree_solid_ec(TTree *tree_solid_ec)
{  
tree_solid_ec->SetBranchAddress("hitn",&solid_ec_hitn);
tree_solid_ec->SetBranchAddress("id",&solid_ec_id);
tree_solid_ec->SetBranchAddress("pid",&solid_ec_pid);
tree_solid_ec->SetBranchAddress("mpid",&solid_ec_mpid);
tree_solid_ec->SetBranchAddress("tid",&solid_ec_tid);
tree_solid_ec->SetBranchAddress("mtid",&solid_ec_mtid);
tree_solid_ec->SetBranchAddress("otid",&solid_ec_otid);
tree_solid_ec->SetBranchAddress("trackE",&solid_ec_trackE);
tree_solid_ec->SetBranchAddress("totEdep",&solid_ec_totEdep);
tree_solid_ec->SetBranchAddress("avg_x",&solid_ec_avg_x);
tree_solid_ec->SetBranchAddress("avg_y",&solid_ec_avg_y);
tree_solid_ec->SetBranchAddress("avg_z",&solid_ec_avg_z);
tree_solid_ec->SetBranchAddress("avg_lx",&solid_ec_avg_lx);
tree_solid_ec->SetBranchAddress("avg_ly",&solid_ec_avg_ly);
tree_solid_ec->SetBranchAddress("avg_lz",&solid_ec_avg_lz);
tree_solid_ec->SetBranchAddress("px",&solid_ec_px);
tree_solid_ec->SetBranchAddress("py",&solid_ec_py);
tree_solid_ec->SetBranchAddress("pz",&solid_ec_pz);
tree_solid_ec->SetBranchAddress("vx",&solid_ec_vx);
tree_solid_ec->SetBranchAddress("vy",&solid_ec_vy);
tree_solid_ec->SetBranchAddress("vz",&solid_ec_vz);
tree_solid_ec->SetBranchAddress("mvx",&solid_ec_mvx);
tree_solid_ec->SetBranchAddress("mvy",&solid_ec_mvy);
tree_solid_ec->SetBranchAddress("mvz",&solid_ec_mvz);
tree_solid_ec->SetBranchAddress("avg_t",&solid_ec_avg_t);

return;
}

double process_tree_solid_ec(TTree *tree_solid_ec)
{
  double totEdep=0;
//     for (Int_t j=0;j<1;j++) {  
    for (Int_t j=0;j<solid_ec_hitn->size();j++) {
//       cout << "solid_ec " << " !!! " << solid_ec_hitn->at(j) << " " << solid_ec_id->at(j) << " " << solid_ec_pid->at(j) << " " << solid_ec_mpid->at(j) << " " << solid_ec_tid->at(j) << " " << solid_ec_mtid->at(j) << " " << solid_ec_trackE->at(j) << " " << solid_ec_totEdep->at(j) << " " << solid_ec_avg_x->at(j) << " " << solid_ec_avg_y->at(j) << " " << solid_ec_avg_z->at(j) << " " << solid_ec_avg_lx->at(j) << " " << solid_ec_avg_ly->at(j) << " " << solid_ec_avg_lz->at(j) << " " << solid_ec_px->at(j) << " " << solid_ec_py->at(j) << " " << solid_ec_pz->at(j) << " " << solid_ec_vx->at(j) << " " << solid_ec_vy->at(j) << " " << solid_ec_vz->at(j) << " " << solid_ec_mvx->at(j) << " " << solid_ec_mvy->at(j) << " " << solid_ec_mvz->at(j) << " " << solid_ec_avg_t->at(j) << endl;  

      int detector_ID=solid_ec_id->at(j)/1000000;
      int subdetector_ID=(solid_ec_id->at(j)%1000000)/100000;
      int subsubdetector_ID=((solid_ec_id->at(j)%1000000)%100000)/10000;
      int component_ID=solid_ec_id->at(j)%10000;
      
//     cout << detector_ID << " " << subdetector_ID << " "  << subsubdetector_ID  << " " << component_ID << ", " << solid_ec_totEdep->at(j) << endl; 
           
      if (detector_ID==3 && subdetector_ID == 1 && subsubdetector_ID == 0) totEdep +=solid_ec_totEdep->at(j);     
      
//       if (detector_ID==3 && subdetector_ID == 1 && subsubdetector_ID == 1) totEdep +=solid_ec_trackE->at(j);           
    }
    

return totEdep;

}

