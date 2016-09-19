#include <iostream> 
#include <fstream>
#include <cmath> 
#include <math.h> 
#include <TCanvas.h>
#include <TFile.h>
#include <TTree.h>
#include <TBranch.h>
#include <TLeaf.h>
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

#include "analysis_tree_solid_ec.C"
#include "analysis_tree_solid_lgc.C"

using namespace std;

void analysis_PVDIS(string input_filename,bool debug=false)
{
gROOT->Reset();
gStyle->SetPalette(1);
gStyle->SetOptFit(0);
// gStyle->SetOptStat(0);
gStyle->SetOptStat(1111111);

const double DEG=180./3.1415926;

char the_filename[200];
sprintf(the_filename, "%s",input_filename.substr(0,input_filename.rfind(".")).c_str());

// char output_filename[200];
// sprintf(output_filename, "%s_output.root",the_filename);
// TFile *outputfile=new TFile(output_filename, "recreate");

const int m=12;
char *detector_name[m]={"GEM 1","GEM 2","GEM 3","GEM 4","GEM 5","GEM 6","LGC","HGC","FASPD","LASPD","FAEC","LAEC"};
TH2F *hflux_hitxy[m];
for (Int_t i=0;i<m;i++) {
hflux_hitxy[i]=new TH2F(Form("hflux_hitxy_%i",i),Form("flux_hitxy %s;x(cm);y(cm)",detector_name[i]),600,-300,300,600,-300,300);
}

TH2F *hgen_ThetaP=new TH2F("gen_ThetaP","gen_ThetaP",40,10,50,110,0,11);     
TH2F *hacceptance_ThetaP[2];
hacceptance_ThetaP[0]=new TH2F("acceptance_ThetaP_FA","acceptance by FA;vertex Theta (deg);P (GeV)",40,10,50,110,0,11);     
hacceptance_ThetaP[1]=new TH2F("acceptance_ThetaP_LA","acceptance by LA;vertex Theta (deg);P (GeV)",40,10,50,110,0,11);

TH1F *hnphe_lgc=new TH1F("hnphe_lgc","hnphe_lgc",20,-0.5,19.5);
TH1F *hsectoring_ec_lgc=new TH1F("hsectoring_ec_lgc","hsectoring_ec_lgc",30,-14.5,15.5);

// TH1F *htotEdep_ec=new TH1F("htotEdep_ec","htotEdep_ec",100,0,2000);

// TH2F *htotEdep_ec_gen=new TH2F("htotEdep_ec_gen","htotEdep_ec_gen",100,0,2000,110,0,11000);

TFile *file=new TFile(input_filename.c_str());
if (file->IsZombie()) {
    cout << "Error opening file" << input_filename << endl;
    exit(-1);
}
else cout << "open file " << input_filename << endl;    

TTree *tree_header = (TTree*) file->Get("header");
vector <string> *header_time=0;
vector <int> *header_evn=0,*header_evn_type=0;
vector <double> *header_beamPol=0;
vector <int> *header_var1=0,*header_var2=0,*header_var3=0,*header_var4=0,*header_var5=0,*header_var6=0,*header_var7=0,*header_var8=0;
tree_header->SetBranchAddress("time",&header_time);
tree_header->SetBranchAddress("evn",&header_evn);
tree_header->SetBranchAddress("evn_type",&header_evn_type);
tree_header->SetBranchAddress("beamPol",&header_beamPol);
tree_header->SetBranchAddress("var1",&header_var1);
tree_header->SetBranchAddress("var2",&header_var2);
tree_header->SetBranchAddress("var3",&header_var3);
tree_header->SetBranchAddress("var4",&header_var4);
tree_header->SetBranchAddress("var5",&header_var5);
tree_header->SetBranchAddress("var6",&header_var6);
tree_header->SetBranchAddress("var7",&header_var7);
tree_header->SetBranchAddress("var8",&header_var8);
// if(debug){
// char *branchname_header[12]={"time","evn","evn_type","beamPol","var1","var2","var3","var4","var5","var6","var7","var8"};
// cout << endl << "tree_header" << endl;
// for (Int_t i=0;i<12;i++) { 
// cout << branchname_header[i] << " " <<  tree_header->GetBranch(branchname_header[i])->GetLeaf(branchname_header[i])->GetTypeName() << ",";
// }
// }

TTree *tree_generated = (TTree*) file->Get("generated");
vector <int> *gen_pid=0;
vector <double> *gen_px=0,*gen_py=0,*gen_pz=0,*gen_vx=0,*gen_vy=0,*gen_vz=0;
tree_generated->SetBranchAddress("pid",&gen_pid);
tree_generated->SetBranchAddress("px",&gen_px);
tree_generated->SetBranchAddress("py",&gen_py);
tree_generated->SetBranchAddress("pz",&gen_pz);
tree_generated->SetBranchAddress("vx",&gen_vx);
tree_generated->SetBranchAddress("vy",&gen_vy);
tree_generated->SetBranchAddress("vz",&gen_vz);
// if(debug){
// char *branchname_generated[7]={"pid","px","py","pz","vx","vy","vz"};
// cout << endl << "tree_generated" << endl;
// for (Int_t i=0;i<7;i++) { 
// cout << branchname_generated[i] << " " <<  tree_generated->GetBranch(branchname_generated[i])->GetLeaf(branchname_generated[i])->GetTypeName() << ",";
// }
// }

TTree *tree_flux = (TTree*) file->Get("flux");
vector<int> *flux_id=0,*flux_hitn=0;
vector<int> *flux_pid=0,*flux_mpid=0,*flux_tid=0,*flux_mtid=0,*flux_otid=0;
vector<double> *flux_trackE=0,*flux_totEdep=0,*flux_avg_x=0,*flux_avg_y=0,*flux_avg_z=0,*flux_avg_lx=0,*flux_avg_ly=0,*flux_avg_lz=0,*flux_px=0,*flux_py=0,*flux_pz=0,*flux_vx=0,*flux_vy=0,*flux_vz=0,*flux_mvx=0,*flux_mvy=0,*flux_mvz=0,*flux_avg_t=0;
tree_flux->SetBranchAddress("hitn",&flux_hitn);
tree_flux->SetBranchAddress("id",&flux_id);
tree_flux->SetBranchAddress("pid",&flux_pid);
tree_flux->SetBranchAddress("mpid",&flux_mpid);
tree_flux->SetBranchAddress("tid",&flux_tid);
tree_flux->SetBranchAddress("mtid",&flux_mtid);
tree_flux->SetBranchAddress("otid",&flux_otid);
tree_flux->SetBranchAddress("trackE",&flux_trackE);
tree_flux->SetBranchAddress("totEdep",&flux_totEdep);
tree_flux->SetBranchAddress("avg_x",&flux_avg_x);
tree_flux->SetBranchAddress("avg_y",&flux_avg_y);
tree_flux->SetBranchAddress("avg_z",&flux_avg_z);
tree_flux->SetBranchAddress("avg_lx",&flux_avg_lx);
tree_flux->SetBranchAddress("avg_ly",&flux_avg_ly);
tree_flux->SetBranchAddress("avg_lz",&flux_avg_lz);
tree_flux->SetBranchAddress("px",&flux_px);
tree_flux->SetBranchAddress("py",&flux_py);
tree_flux->SetBranchAddress("pz",&flux_pz);
tree_flux->SetBranchAddress("vx",&flux_vx);
tree_flux->SetBranchAddress("vy",&flux_vy);
tree_flux->SetBranchAddress("vz",&flux_vz);
tree_flux->SetBranchAddress("mvx",&flux_mvx);
tree_flux->SetBranchAddress("mvy",&flux_mvy);
tree_flux->SetBranchAddress("mvz",&flux_mvz);
tree_flux->SetBranchAddress("avg_t",&flux_avg_t);
// if(debug){
// char *branchname_flux[26]={"hitn","id","pid","mpid","tid","mtid","otid","trackE","totEdep","trackE","avg_x","avg_y","avg_z","avg_lx","avg_ly","avg_lz","px","py","pz","vx","vy","vz","mvx","mvy","mvz","avg_t"};
// cout << endl << "tree_flux" << endl;
// for (Int_t i=0;i<26;i++) { 
// cout << branchname_flux[i] << " " <<  tree_flux->GetBranch(branchname_flux[i])->GetLeaf(branchname_flux[i])->GetTypeName() << ",";
// }
// }

TTree *tree_solid_ec = (TTree*) file->Get("solid_ec");
setup_tree_solid_ec(tree_solid_ec);

TTree *tree_solid_lgc = (TTree*) file->Get("solid_lgc");
setup_tree_solid_lgc(tree_solid_lgc);

int nevent = (int)tree_generated->GetEntries();
int nselected = 0;
cout << "nevent " << nevent << endl;

// for (Int_t i=0;i<2;i++) { 
// for (Int_t i=0;i<nevent/10;i++) { 
for (Int_t i=0;i<nevent;i++) { 

  cout << i << "\r";
//   cout << i << "\n";

  tree_header->GetEntry(i);
  double rate=header_var8->at(0);
  
  tree_generated->GetEntry(i);  
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
      hgen_ThetaP->Fill(theta_gen*DEG,p_gen/1e3);            
  }
  
    bool Is_acc=false,Is_ec=false,Is_gem[5]={false,false,false,false,false},Is_lgc=false;
    
    tree_flux->GetEntry(i);  
    
    int sec_ec=0;
    for (Int_t j=0;j<flux_hitn->size();j++) {
//       cout << "flux " << " !!! " << flux_hitn->at(j) << " " << flux_id->at(j) << " " << flux_pid->at(j) << " " << flux_mpid->at(j) << " " << flux_tid->at(j) << " " << flux_mtid->at(j) << " " << flux_trackE->at(j) << " " << flux_totEdep->at(j) << " " << flux_avg_x->at(j) << " " << flux_avg_y->at(j) << " " << flux_avg_z->at(j) << " " << flux_avg_lx->at(j) << " " << flux_avg_ly->at(j) << " " << flux_avg_lz->at(j) << " " << flux_px->at(j) << " " << flux_py->at(j) << " " << flux_pz->at(j) << " " << flux_vx->at(j) << " " << flux_vy->at(j) << " " << flux_vz->at(j) << " " << flux_mvx->at(j) << " " << flux_mvy->at(j) << " " << flux_mvz->at(j) << " " << flux_avg_t->at(j) << endl;  

      int detector_ID=flux_id->at(j)/1000000;
      int subdetector_ID=(flux_id->at(j)%1000000)/100000;
      int subsubdetector_ID=((flux_id->at(j)%1000000)%100000)/10000;
      int component_ID=flux_id->at(j)%10000;      
     
//       if (detector_ID==5 && subdetector_ID == 1 && subsubdetector_ID == 1)   cout << "particle mom entering SPD " << flux_trackE->at(j) << endl;   

//       if (detector_ID==4 && subdetector_ID == 1 && subsubdetector_ID == 1)   cout << "particle mom entering MRPC " << flux_trackE->at(j) << endl;   
      
//       if (detector_ID==3 && subdetector_ID == 1 && subsubdetector_ID == 1)   cout << "particle mom entering EC " << flux_trackE->at(j) << endl;         
     double hit_r=sqrt(pow(flux_avg_x->at(j),2)+pow(flux_avg_y->at(j),2));
     double hit_y=flux_avg_y->at(j),hit_x=flux_avg_x->at(j),hit_z=flux_avg_z->at(j);          
     double hit_phi=atan2(hit_y,hit_x)*DEG;
      
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
      
      if (0<=hit_id && hit_id<=11) hflux_hitxy[hit_id]->Fill(flux_avg_x->at(j)/10.,flux_avg_y->at(j)/10.);
//       else cout << "flux_id->at(j) " << flux_id->at(j) << endl;
      
      //check hit on EC and find sec_ec
      if(hit_id==10 && flux_tid->at(j)==1){
	if (110<=hit_r/1e1 && hit_r/1e1<=250) { //cut on EC hit
	Is_ec=true;
	int sec_shift=1.7;  // shift to match electron turning in field
	if (hit_phi > 90+sec_shift) sec_ec=int((hit_phi-90-sec_shift)/12+1);
	else sec_ec=int((hit_phi+360-90-sec_shift)/12+1);
	// 	cout << " hit_phi " << hit_phi << " sec_ec " << sec_ec << endl;	
	}
      }
      
    //check hit on GEM
    if (detector_ID==1 && flux_tid->at(j)==1) {
      // some low mom tracks spiral and travel back in field and go through one plane twice or more,   flux bank average these steps to get hit position which is wrong and can be outside of the virtual plane.
//       for PVDIS
//  my @Rin = (48,59,65,105,109);
//  my @Rout = (122,143,143,230,237);	      
//       for SIDIS
//        my @Rin = (36,21,25,32,42,55);
//        my @Rout = (87,98,112,135,100,123);
      double Rin[6]={0,0,0,0,0,0},Rout[6]={0,0,0,0,0,0};
//       if (Is_PVDIS){
	Rin[0]=48;Rin[1]=59;Rin[2]=65;Rin[3]=105;Rin[4]=109;Rin[5]=0;     
        Rout[0]=122;Rout[1]=143;Rout[2]=143;Rout[3]=230;Rout[4]=237;Rout[5]=300;
//       }
//       else {
// 	Rin[0]=36;Rin[1]=21;Rin[2]=25;Rin[3]=32;Rin[4]=42;Rin[5]=55;     
//         Rout[0]=87;Rout[1]=98;Rout[2]=112;Rout[3]=135;Rout[4]=100;Rout[5]=123;
//       }

      if (Rin[subdetector_ID-1]<=hit_r/1e1 && hit_r/1e1<Rout[subdetector_ID-1]) {
	Is_gem[subdetector_ID-1]=true;
// 	cout << flux_id->at(j) << endl; 	
	continue;	
      }  
                      
    }
    
    }

//   tree_solid_ec->GetEntry(i);    
//   double totEdep_ec=process_tree_solid_ec(tree_solid_ec);
//   cout << "totEdep_ec " << totEdep_ec << endl;

  tree_solid_lgc->GetEntry(i);
  
  Int_t nphe_lgc[30]={0};
  process_tree_solid_lgc(tree_solid_lgc,nphe_lgc);

  //check how number of p.e. for all LGC sector and plot it with sec_ec at 0
  for (int j=0;j<30;j++){    
    int lgcsec = j+1;
    int index;
    if(-14<=lgcsec-sec_ec && lgcsec-sec_ec<16) index=lgcsec-sec_ec;
    else if (lgcsec-sec_ec>=16) index=lgcsec-sec_ec-30;
    else if (lgcsec-sec_ec<-14) index=lgcsec-sec_ec+30;    
//     if (nphe_lgc[index]<0) cout << sec_ec << " " << lgcsec << " " << index << " " << nphe_lgc[index] << endl;    
    hsectoring_ec_lgc->Fill(index,nphe_lgc[j]*rate);
  }

  //sum number of p.e. from LGC sector sec_ec-sec_width_sum to sec_ec+sec_width_sum
  int sec_width_sum=0; 
  int nphe_lgc_total=0;  
  for (int j=sec_ec-sec_width_sum;j<=sec_ec+sec_width_sum;j++){    
    int index;
    if (0<=j && j<30) index=j;
    else if (j>=30) index=j-30;
    else if (j<0) index=j+30;
    else cout << "something wrong with sec" << endl;      
    nphe_lgc_total += nphe_lgc[index];
  }  
  
  if (Is_ec){
    if(Is_gem[0] && Is_gem[1] && Is_gem[2] && Is_gem[3] && Is_gem[4]){
    hnphe_lgc->Fill(nphe_lgc_total,rate);  
    if (nphe_lgc_total>1){  // cut on lgc
      Is_acc=true;
    }
  }      
  }
  
  if (Is_acc) hacceptance_ThetaP[0]->Fill(theta_gen*DEG,p_gen/1e3);  
  
//   if (totEdep_spd !=0) htotEdep_spd->Fill(totEdep_spd);
//   if (totEdep_mrpc !=0) htotEdep_mrpc->Fill(totEdep_mrpc);
//   if (totEdep_ec !=0) htotEdep_ec->Fill(totEdep_ec);  
  
/*  htotEdep_ec_gen->Fill(totEdep_ec,p_gen);  
  htotEdep_ec_spd->Fill(totEdep_ec,totEdep_spd);
  htotEdep_ec_mrpc->Fill(totEdep_ec,totEdep_mrpc);    
  htotEdep_spd_mrpc->Fill(totEdep_spd,totEdep_mrpc);  */    
    
}
file->Close();

// outputfile->Write();
// outputfile->Flush();

TCanvas *c_flux_hitxy = new TCanvas("flux_hitxy","flux_hitxy",1800,900);
c_flux_hitxy->Divide(5,2);
for (Int_t i=0;i<m;i++) {
c_flux_hitxy->cd(i+1);
gPad->SetLogz();
hflux_hitxy[i]->Draw("colz");
}

TCanvas *c_npe_lgc = new TCanvas("npe_lgc","npe_lgc",1600,900);
c_npe_lgc->Divide(2,1);
c_npe_lgc->cd(1);
hnphe_lgc->Draw();
c_npe_lgc->cd(2);
hsectoring_ec_lgc->Draw();
gPad->SetLogy(1);

TCanvas *c_acc = new TCanvas("acc","acc",1600,900);
c_acc->Divide(2,1);
c_acc->cd(1);
hgen_ThetaP->Draw("colz");
c_acc->cd(2);
hacceptance_ThetaP[0]->Divide(hacceptance_ThetaP[0],hgen_ThetaP);  
hacceptance_ThetaP[0]->SetMinimum(0);  
hacceptance_ThetaP[0]->SetMaximum(1);    
hacceptance_ThetaP[0]->Draw("colz");

}
