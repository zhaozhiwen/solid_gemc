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



vector<int> *solid_lgc_hitn=0;
vector<int> *solid_lgc_sector=0,*solid_lgc_pmt=0,*solid_lgc_pixel=0,*solid_lgc_nphe=0;
vector<double> *solid_lgc_avg_t=0;

void setup_tree_solid_lgc(TTree *tree_solid_lgc)
{  
tree_solid_lgc->SetBranchAddress("hitn",&solid_lgc_hitn);
tree_solid_lgc->SetBranchAddress("sector",&solid_lgc_sector);
tree_solid_lgc->SetBranchAddress("pmt",&solid_lgc_pmt);
tree_solid_lgc->SetBranchAddress("pixel",&solid_lgc_pixel);
tree_solid_lgc->SetBranchAddress("nphe",&solid_lgc_nphe);
tree_solid_lgc->SetBranchAddress("avg_t",&solid_lgc_avg_t);

return;
}

//Simple trigger, no timing information is used.  If at least 1 sector meets the criteria for trigger, then the trigger fires.
//Must imput the lgc_tree, the event number, and the PMT and PEperPMT thresholds (default is a 2x2 trigger).


// Bool_t lgc_trigger(TTree *tree_solid_lgc, Int_t eventn, Int_t PMTthresh = 2, Int_t PEthresh = 2){
//   tree_solid_lgc->GetEntry(eventn);
Bool_t process_tree_solid_lgc_trigger(TTree *tree_solid_lgc,Int_t *trigger_lgc, Int_t &ntrigsecs, Int_t PMTthresh = 2, Int_t PEthresh = 2){
  if(!solid_lgc_hitn->size()) return 0;
   //if using root6, uncomment line below, and comment out following line
  //std::vector<std::vector<int>> sectorhits (30, std::vector<int>(9,0));  //initialize a 30x9 vector array
  Int_t sectorhits[30][9] = {0};  //need to intialize to zero or bad stuff
  
  Int_t ntrigpmts =0;
 
  for(Int_t i = 0; i < solid_lgc_hitn->size(); i++){
    if(solid_lgc_nphe->at(i)){
      sectorhits[solid_lgc_sector->at(i)-1][solid_lgc_pmt->at(i)-1] += solid_lgc_nphe->at(i);
    }
  }
  for(Int_t i = 0; i < 30; i++){
    ntrigpmts = 0;
    for(Int_t j = 0; j < 9; j++){
      if(sectorhits[i][j] >= PEthresh) ntrigpmts++;
    }
    if(ntrigpmts >= PMTthresh) {
      ntrigsecs++;
      trigger_lgc[i]=1;
    }
  }
  if(ntrigsecs){
    return 1;
  }else{
    return 0;
  }
}

double process_tree_solid_lgc(TTree *tree_solid_lgc, Int_t *nphe_lgc)
{
  if(!solid_lgc_hitn->size()) return 0;
   //if using root6, uncomment line below, and comment out following line
  //std::vector<std::vector<int>> sectorhits (30, std::vector<int>(9,0));  //initialize a 30x9 vector array
  Int_t pmt[30][9] = {0};  //need to intialize to zero or bad stuff
 
  for(Int_t i = 0; i < solid_lgc_hitn->size(); i++){
    if(solid_lgc_nphe->at(i)>0){
      pmt[solid_lgc_sector->at(i)-1][solid_lgc_pmt->at(i)-1] += solid_lgc_nphe->at(i);
    }
  }
  for(Int_t i = 0; i < 30; i++){
    for(Int_t j = 0; j < 9; j++){
      if(pmt[i][j] > 0) nphe_lgc[i] += pmt[i][j];
    }
  }
  
  return 1;
}


