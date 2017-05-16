#include <vector>
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
#include <TEllipse.h>
#include <TBox.h>
#include <TLorentzVector.h>
#include <TVector3.h>
#include <TROOT.h>
#include <TStyle.h>
#include <TMinuit.h>
#include <TPaveText.h>
#include <TText.h>
#include <TSystem.h>
#include <TArc.h>
#include <TColor.h>

using namespace std;

void SoLIDFileReduce(string setup, string input_filename)
{
	bool Is_morebanks;
	if(setup=="PVDIS")  Is_morebanks=false;
	else if(setup=="SIDIS" || setup=="JPsi") Is_morebanks=true;
	else {cout << "can't recognize setup " << setup << endl; return;}
  
	TFile *f1 = new TFile(input_filename.c_str());
	TFile *f2 = new TFile(Form("%s_skim",input_filename.c_str()), "RECREATE");
	
	TTree *header;
	TTree *generated;
	TTree *allraws;  
	TTree *flux;	
	TTree *solid_gem;
	TTree *solid_ec;
	TTree *solid_lgc;
	TTree *solid_mrpc=0;
	TTree *solid_spd=0;
	TTree *solid_hgc=0;
	
	header = (TTree*)f1->Get("header");	
	generated = (TTree*)f1->Get("generated");
	allraws = (TTree*)f1->Get("allraws");
	flux = (TTree*)f1->Get("flux");
	solid_gem = (TTree*)f1->Get("solid_gem");
	solid_ec = (TTree*)f1->Get("solid_ec");
	solid_lgc = (TTree*)f1->Get("solid_lgc");	
	if(Is_morebanks){
	solid_mrpc = (TTree*)f1->Get("solid_mrpc");
	solid_spd = (TTree*)f1->Get("solid_spd");
	solid_hgc = (TTree*)f1->Get("solid_hgc");
	}
	
// 	cout <<   flux->GetBranch("hitn")->GetLeaf("hitn")->GetTypeName() << endl;
// 	cout <<   flux->FindLeaf("hitn")->GetValue(1) << endl;
	
	TTree *output_header;
	TTree *output_generated;
	TTree *output_allraws;  
	TTree *output_flux;	
	TTree *output_solid_gem;
	TTree *output_solid_ec;
	TTree *output_solid_lgc;
	TTree *output_solid_mrpc=0;
	TTree *output_solid_spd=0;
	TTree *output_solid_hgc=0;
	
	output_header = header->CloneTree(0);
	output_generated = generated->CloneTree(0);
	output_allraws = allraws->CloneTree(0);
	output_flux = flux->CloneTree(0);	
	output_solid_gem = solid_gem->CloneTree(0);
	output_solid_ec = solid_ec->CloneTree(0);
	output_solid_lgc = solid_lgc->CloneTree(0);
	if(Is_morebanks){	
	output_solid_mrpc = solid_mrpc->CloneTree(0);
	output_solid_spd = solid_spd->CloneTree(0);
	output_solid_hgc = solid_hgc->CloneTree(0);
	}	
	
// //////////////header vectors//////////////////
// vector<string> *header_time=0;
// vector<int> *header_evn=0,*header_evn_type=0;
// vector<double>*header_beamPol=0,*header_var1=0,*header_var2=0,*header_var3=0,*header_var4=0,*header_var5=0,*header_var6=0,*header_var7=0,*header_var8=0;
// header->SetBranchAddress("time", &header_time);
// header->SetBranchAddress("evn", &header_evn);
// header->SetBranchAddress("evn_type", &header_evn_type);
// header->SetBranchAddress("beamPol", &header_beamPol);
// header->SetBranchAddress("var1", &header_var1);
// header->SetBranchAddress("var2", &header_var2);
// header->SetBranchAddress("var3", &header_var3);
// header->SetBranchAddress("var4", &header_var4);
// header->SetBranchAddress("var5", &header_var5);
// header->SetBranchAddress("var6", &header_var6);
// header->SetBranchAddress("var7", &header_var7);
// header->SetBranchAddress("var8", &header_var8);
// 
// //////////////generated vectors///////////////
// vector<int> *generated_pid=0;
// vector<double> *generated_px=0,*generated_py=0,*generated_pz=0,*generated_vx=0,*generated_vy=0,*generated_vz=0;
// generated->SetBranchAddress("pid", &generated_pid);
// generated->SetBranchAddress("px", &generated_px);
// generated->SetBranchAddress("py", &generated_py);
// generated->SetBranchAddress("pz", &generated_pz);
// generated->SetBranchAddress("vx", &generated_vx);
// generated->SetBranchAddress("vy", &generated_vy);
// generated->SetBranchAddress("vz", &generated_vz);
// 
// ///////////////allraws vectirs/////////////
// vector<int> *allraws_pid=0,*allraws_mpid=0,*allraws_tid=0,*allraws_mtid=0,*allraws_otid=0,*allraws_stepn=0,*allraws_hitn=0;
// vector<double> *allraws_trackE=0,*allraws_edep=0,*allraws_x=0,*allraws_y=0,*allraws_z=0,*allraws_lx=0,*allraws_ly=0,*allraws_lz=0,*allraws_px=0,*allraws_py=0,*allraws_pz=0,*allraws_vx=0,*allraws_vy=0,*allraws_vz=0,*allraws_mvx=0,*allraws_mvy=0,*allraws_mvz=0,*allraws_t=0;
// allraws->SetBranchAddress("pid", &allraws_pid);
// allraws->SetBranchAddress("mpid", &allraws_mpid);
// allraws->SetBranchAddress("tid", &allraws_tid);
// allraws->SetBranchAddress("mtid", &allraws_mtid);
// allraws->SetBranchAddress("otid", &allraws_otid);
// allraws->SetBranchAddress("trackE", &allraws_trackE);
// allraws->SetBranchAddress("edep", &allraws_edep);
// allraws->SetBranchAddress("x", &allraws_x);
// allraws->SetBranchAddress("y", &allraws_y);
// allraws->SetBranchAddress("z", &allraws_z);
// allraws->SetBranchAddress("lx", &allraws_lx);
// allraws->SetBranchAddress("ly", &allraws_ly);
// allraws->SetBranchAddress("lz", &allraws_lz);
// allraws->SetBranchAddress("px", &allraws_px);
// allraws->SetBranchAddress("py", &allraws_py);
// allraws->SetBranchAddress("pz", &allraws_pz);
// allraws->SetBranchAddress("vx", &allraws_vx);
// allraws->SetBranchAddress("vy", &allraws_vy);
// allraws->SetBranchAddress("vz", &allraws_vz);
// allraws->SetBranchAddress("mvx", &allraws_mvx);
// allraws->SetBranchAddress("mvy", &allraws_mvy);
// allraws->SetBranchAddress("mvz", &allraws_mvz);
// allraws->SetBranchAddress("t", &allraws_t);
// allraws->SetBranchAddress("stepn", &allraws_stepn);
// allraws->SetBranchAddress("hitn", &allraws_hitn);
// 
// ////////flux vectors/////////////
// vector<int> *flux_hitn=0,*flux_id=0,*flux_pid=0,*flux_mpid=0,*flux_tid=0,*flux_mtid=0,*flux_otid=0;
// vector<double> *flux_trackE=0,*flux_totEdep=0,*flux_avg_x=0,*flux_avg_y=0,*flux_avg_z=0,*flux_avg_lx=0,*flux_avg_ly=0,*flux_avg_lz=0,*flux_px=0,*flux_py=0,*flux_pz=0,*flux_vx=0,*flux_vy=0,*flux_vz=0,*flux_mvx=0,*flux_mvy=0,*flux_mvz=0,*flux_avg_t=0;
// flux->SetBranchAddress("hitn", &flux_hitn);
// flux->SetBranchAddress("id", &flux_id);
// flux->SetBranchAddress("pid", &flux_pid);
// flux->SetBranchAddress("mpid", &flux_mpid);
// flux->SetBranchAddress("tid", &flux_tid);
// flux->SetBranchAddress("mtid", &flux_mtid);
// flux->SetBranchAddress("otid", &flux_otid);
// flux->SetBranchAddress("trackE", &flux_trackE);
// flux->SetBranchAddress("totEdep", &flux_totEdep);
// flux->SetBranchAddress("avg_x", &flux_avg_x);
// flux->SetBranchAddress("avg_y", &flux_avg_y);
// flux->SetBranchAddress("avg_z", &flux_avg_z);
// flux->SetBranchAddress("avg_lx", &flux_avg_lx);
// flux->SetBranchAddress("avg_ly", &flux_avg_ly);
// flux->SetBranchAddress("avg_lz", &flux_avg_lz);
// flux->SetBranchAddress("px", &flux_px);
// flux->SetBranchAddress("py", &flux_py);
// flux->SetBranchAddress("pz", &flux_pz);
// flux->SetBranchAddress("vx", &flux_vx);
// flux->SetBranchAddress("vy", &flux_vy);
// flux->SetBranchAddress("vz", &flux_vz);
// flux->SetBranchAddress("mvx", &flux_mvx);
// flux->SetBranchAddress("mvy", &flux_mvy);
// flux->SetBranchAddress("mvz", &flux_mvz);
// flux->SetBranchAddress("avg_t", &flux_avg_t);
// 
// ////////solid gem vectors////////
// vector<int> *solid_gem_hitn=0,*solid_gem_pid=0,*solid_gem_trid=0,*solid_gem_id=0;
// vector<double> *solid_gem_ETot=0,*solid_gem_x=0,*solid_gem_y=0,*solid_gem_z=0,*solid_gem_lxin=0,*solid_gem_lyin=0,*solid_gem_lzin=0,*solid_gem_tin=0,*solid_gem_lxout=0,*solid_gem_lyout=0,*solid_gem_lzout=0,*solid_gem_tout=0,*solid_gem_vx=0,*solid_gem_vy=0,*solid_gem_vz=0,*solid_gem_trE=0,*solid_gem_weight=0,*solid_gem_px=0,*solid_gem_py=0,*solid_gem_pz=0;
// solid_gem->SetBranchAddress("hitn", &solid_gem_hitn);
// solid_gem->SetBranchAddress("ETot", &solid_gem_ETot);
// solid_gem->SetBranchAddress("x", &solid_gem_x);
// solid_gem->SetBranchAddress("y", &solid_gem_y);
// solid_gem->SetBranchAddress("z", &solid_gem_z);
// solid_gem->SetBranchAddress("lxin", &solid_gem_lxin);
// solid_gem->SetBranchAddress("lyin", &solid_gem_lyin);
// solid_gem->SetBranchAddress("lzin", &solid_gem_lzin);
// solid_gem->SetBranchAddress("tin", &solid_gem_tin);
// solid_gem->SetBranchAddress("lxout", &solid_gem_lxout);
// solid_gem->SetBranchAddress("lyout", &solid_gem_lyout);
// solid_gem->SetBranchAddress("lzout", &solid_gem_lzout);
// solid_gem->SetBranchAddress("tout", &solid_gem_tout);
// solid_gem->SetBranchAddress("pid", &solid_gem_pid);
// solid_gem->SetBranchAddress("vx", &solid_gem_vx);
// solid_gem->SetBranchAddress("vy", &solid_gem_vy);
// solid_gem->SetBranchAddress("vz", &solid_gem_vz);
// solid_gem->SetBranchAddress("trE", &solid_gem_trE);
// solid_gem->SetBranchAddress("trid", &solid_gem_trid);
// solid_gem->SetBranchAddress("weight", &solid_gem_weight);
// solid_gem->SetBranchAddress("px", &solid_gem_px);
// solid_gem->SetBranchAddress("py", &solid_gem_py);
// solid_gem->SetBranchAddress("pz", &solid_gem_pz);
// solid_gem->SetBranchAddress("id", &solid_gem_id);
// 
// ////////////solid ec vectors////////////
// vector<double> *solid_ec_pid=0,*solid_ec_mpid=0,*solid_ec_tid=0,*solid_ec_mtid=0,*solid_ec_otid=0,*solid_ec_id=0,*solid_ec_hitn=0;
// vector<double> *solid_ec_trackE=0,*solid_ec_totEdep=0,*solid_ec_avg_x=0,*solid_ec_avg_y=0,*solid_ec_avg_z=0,*solid_ec_avg_lx=0,*solid_ec_avg_ly=0,*solid_ec_avg_lz=0,*solid_ec_px=0,*solid_ec_py=0,*solid_ec_pz=0,*solid_ec_vx=0,*solid_ec_vy=0,*solid_ec_vz=0,*solid_ec_mvx=0,*solid_ec_mvy=0,*solid_ec_mvz=0,*solid_ec_avg_t=0;
// solid_ec->SetBranchAddress("pid", &solid_ec_pid);
// solid_ec->SetBranchAddress("mpid", &solid_ec_mpid);
// solid_ec->SetBranchAddress("tid", &solid_ec_tid);
// solid_ec->SetBranchAddress("mtid", &solid_ec_mtid);
// solid_ec->SetBranchAddress("otid", &solid_ec_otid);
// solid_ec->SetBranchAddress("trackE", &solid_ec_trackE);
// solid_ec->SetBranchAddress("totEdep", &solid_ec_totEdep);
// solid_ec->SetBranchAddress("avg_x", &solid_ec_avg_x);
// solid_ec->SetBranchAddress("avg_y", &solid_ec_avg_y);
// solid_ec->SetBranchAddress("avg_z", &solid_ec_avg_z);
// solid_ec->SetBranchAddress("avg_lx", &solid_ec_avg_lx);
// solid_ec->SetBranchAddress("avg_ly", &solid_ec_avg_ly);
// solid_ec->SetBranchAddress("avg_lz", &solid_ec_avg_lz);
// solid_ec->SetBranchAddress("px", &solid_ec_px);
// solid_ec->SetBranchAddress("py", &solid_ec_py);
// solid_ec->SetBranchAddress("pz", &solid_ec_pz);
// solid_ec->SetBranchAddress("vx", &solid_ec_vx);
// solid_ec->SetBranchAddress("vy", &solid_ec_vy);
// solid_ec->SetBranchAddress("vz", &solid_ec_vz);
// solid_ec->SetBranchAddress("mvx", &solid_ec_mvx);
// solid_ec->SetBranchAddress("mvy", &solid_ec_mvy);
// solid_ec->SetBranchAddress("mvz", &solid_ec_mvz);
// solid_ec->SetBranchAddress("avg_t", &solid_ec_avg_t);
// solid_ec->SetBranchAddress("id", &solid_ec_id);
// solid_ec->SetBranchAddress("hitn", &solid_ec_hitn);
// 
// ///////////////solid lgc vectors/////////
// vector<int> *solid_lgc_hitn=0,*solid_lgc_sector=0,*solid_lgc_pmt=0,*solid_lgc_pixel=0,*solid_lgc_nphe=0;
// vector<double> *solid_lgc_avg_t=0;  
// solid_lgc->SetBranchAddress("hitn", &solid_lgc_hitn);
// solid_lgc->SetBranchAddress("sector", &solid_lgc_sector);
// solid_lgc->SetBranchAddress("pmt", &solid_lgc_pmt);
// solid_lgc->SetBranchAddress("pixel", &solid_lgc_pixel);
// solid_lgc->SetBranchAddress("nphe", &solid_lgc_nphe);
// solid_lgc->SetBranchAddress("avg_t", &solid_lgc_avg_t); 
// 
// //////////solid mrpc vectors/////////
// vector<double> *solid_mrpc_pid=0,*solid_mrpc_mpid=0,*solid_mrpc_tid=0,*solid_mrpc_mtid=0,*solid_mrpc_otid=0,*solid_mrpc_id=0,*solid_mrpc_hitn=0;
// vector<double> *solid_mrpc_trackE=0,*solid_mrpc_totEdep=0,*solid_mrpc_avg_x=0,*solid_mrpc_avg_y=0,*solid_mrpc_avg_z=0,*solid_mrpc_avg_lx=0,*solid_mrpc_avg_ly=0,*solid_mrpc_avg_lz=0,*solid_mrpc_px=0,*solid_mrpc_py=0,*solid_mrpc_pz=0,*solid_mrpc_vx=0,*solid_mrpc_vy=0,*solid_mrpc_vz=0,*solid_mrpc_mvx=0,*solid_mrpc_mvy=0,*solid_mrpc_mvz=0,*solid_mrpc_avg_t=0;
// 	if(Is_morebanks){
//   solid_mrpc->SetBranchAddress("pid", &solid_mrpc_pid);
//   solid_mrpc->SetBranchAddress("mpid", &solid_mrpc_mpid);
//   solid_mrpc->SetBranchAddress("tid", &solid_mrpc_tid);
//   solid_mrpc->SetBranchAddress("mtid", &solid_mrpc_mtid);
//   solid_mrpc->SetBranchAddress("otid", &solid_mrpc_otid);
//   solid_mrpc->SetBranchAddress("trackE", &solid_mrpc_trackE);
//   solid_mrpc->SetBranchAddress("totEdep", &solid_mrpc_totEdep);
//   solid_mrpc->SetBranchAddress("avg_x", &solid_mrpc_avg_x);
//   solid_mrpc->SetBranchAddress("avg_y", &solid_mrpc_avg_y);
//   solid_mrpc->SetBranchAddress("avg_z", &solid_mrpc_avg_z);
//   solid_mrpc->SetBranchAddress("avg_lx", &solid_mrpc_avg_lx);
//   solid_mrpc->SetBranchAddress("avg_ly", &solid_mrpc_avg_ly);
//   solid_mrpc->SetBranchAddress("avg_lz", &solid_mrpc_avg_lz);
//   solid_mrpc->SetBranchAddress("px", &solid_mrpc_px);
//   solid_mrpc->SetBranchAddress("py", &solid_mrpc_py);
//   solid_mrpc->SetBranchAddress("pz", &solid_mrpc_pz);
//   solid_mrpc->SetBranchAddress("vx", &solid_mrpc_vx);
//   solid_mrpc->SetBranchAddress("vy", &solid_mrpc_vy);
//   solid_mrpc->SetBranchAddress("vz", &solid_mrpc_vz);
//   solid_mrpc->SetBranchAddress("mvx", &solid_mrpc_mvx);
//   solid_mrpc->SetBranchAddress("mvy", &solid_mrpc_mvy);
//   solid_mrpc->SetBranchAddress("mvz", &solid_mrpc_mvz);
//   solid_mrpc->SetBranchAddress("avg_t", &solid_mrpc_avg_t);
//   solid_mrpc->SetBranchAddress("id", &solid_mrpc_id);
//   solid_mrpc->SetBranchAddress("hitn", &solid_mrpc_hitn);
// 	}
// 	
// ///////////solid spd vectors//////////
// vector<int> *solid_spd_pid=0,*solid_spd_mpid=0,*solid_spd_tid=0,*solid_spd_mtid=0,*solid_spd_otid=0,*solid_spd_id=0,*solid_spd_hitn=0;
// vector<double> *solid_spd_trackE=0,*solid_spd_totEdep=0,*solid_spd_avg_x=0,*solid_spd_avg_y=0,*solid_spd_avg_z=0,*solid_spd_avg_lx=0,*solid_spd_avg_ly=0,*solid_spd_avg_lz=0,*solid_spd_px=0,*solid_spd_py=0,*solid_spd_pz=0,*solid_spd_vx=0,*solid_spd_vy=0,*solid_spd_vz=0,*solid_spd_mvx=0,*solid_spd_mvy=0,*solid_spd_mvz=0,*solid_spd_avg_t=0;
// 	if(Is_morebanks){
//   solid_spd->SetBranchAddress("pid", &solid_spd_pid);
//   solid_spd->SetBranchAddress("mpid", &solid_spd_mpid);
//   solid_spd->SetBranchAddress("tid", &solid_spd_tid);
//   solid_spd->SetBranchAddress("mtid", &solid_spd_mtid);
//   solid_spd->SetBranchAddress("otid", &solid_spd_otid);
//   solid_spd->SetBranchAddress("trackE", &solid_spd_trackE);
//   solid_spd->SetBranchAddress("totEdep", &solid_spd_totEdep);
//   solid_spd->SetBranchAddress("avg_x", &solid_spd_avg_x);
//   solid_spd->SetBranchAddress("avg_y", &solid_spd_avg_y);
//   solid_spd->SetBranchAddress("avg_z", &solid_spd_avg_z);
//   solid_spd->SetBranchAddress("avg_lx", &solid_spd_avg_lx);
//   solid_spd->SetBranchAddress("avg_ly", &solid_spd_avg_ly);
//   solid_spd->SetBranchAddress("avg_lz", &solid_spd_avg_lz);
//   solid_spd->SetBranchAddress("px", &solid_spd_px);
//   solid_spd->SetBranchAddress("py", &solid_spd_py);
//   solid_spd->SetBranchAddress("pz", &solid_spd_pz);
//   solid_spd->SetBranchAddress("vx", &solid_spd_vx);
//   solid_spd->SetBranchAddress("vy", &solid_spd_vy);
//   solid_spd->SetBranchAddress("vz", &solid_spd_vz);
//   solid_spd->SetBranchAddress("mvx", &solid_spd_mvx);
//   solid_spd->SetBranchAddress("mvy", &solid_spd_mvy);
//   solid_spd->SetBranchAddress("mvz", &solid_spd_mvz);
//   solid_spd->SetBranchAddress("avg_t", &solid_spd_avg_t);
//   solid_spd->SetBranchAddress("id", &solid_spd_id);
//   solid_spd->SetBranchAddress("hitn", &solid_spd_hitn);
// 	}
// 
// /////////////solid hgc vectors///////////
// vector<int> *solid_hgc_hitn=0,*solid_hgc_pid=0,*solid_hgc_mpid=0,*solid_hgc_tid=0,*solid_hgc_mtid=0,*solid_hgc_otid=0,*solid_hgc_id=0;
// vector<double> *solid_hgc_trackE=0,*solid_hgc_totEdep=0,*solid_hgc_avg_x=0,*solid_hgc_avg_y=0,*solid_hgc_avg_z=0,*solid_hgc_avg_lx=0,*solid_hgc_avg_ly=0,*solid_hgc_avg_lz=0,*solid_hgc_px=0,*solid_hgc_py=0,*solid_hgc_pz=0,*solid_hgc_vx=0,*solid_hgc_vy=0,*solid_hgc_vz=0,*solid_hgc_mvx=0,*solid_hgc_mvy=0,*solid_hgc_mvz=0,*solid_hgc_avg_t=0;
// 	if(Is_morebanks){
//   solid_hgc->SetBranchAddress("hitn", &solid_hgc_hitn);
//   solid_hgc->SetBranchAddress("pid", &solid_hgc_pid);
//   solid_hgc->SetBranchAddress("mpid", &solid_hgc_mpid);
//   solid_hgc->SetBranchAddress("tid", &solid_hgc_tid);
//   solid_hgc->SetBranchAddress("mtid", &solid_hgc_mtid);
//   solid_hgc->SetBranchAddress("otid", &solid_hgc_otid);
//   solid_hgc->SetBranchAddress("trackE", &solid_hgc_trackE);
//   solid_hgc->SetBranchAddress("totEdep", &solid_hgc_totEdep);
//   solid_hgc->SetBranchAddress("avg_x", &solid_hgc_avg_x);
//   solid_hgc->SetBranchAddress("avg_y", &solid_hgc_avg_y);
//   solid_hgc->SetBranchAddress("avg_z", &solid_hgc_avg_z);
//   solid_hgc->SetBranchAddress("avg_lx", &solid_hgc_avg_lx);
//   solid_hgc->SetBranchAddress("avg_ly", &solid_hgc_avg_ly);
//   solid_hgc->SetBranchAddress("avg_lz", &solid_hgc_avg_lz);
//   solid_hgc->SetBranchAddress("px", &solid_hgc_px);
//   solid_hgc->SetBranchAddress("py", &solid_hgc_py);
//   solid_hgc->SetBranchAddress("pz", &solid_hgc_pz);
//   solid_hgc->SetBranchAddress("vx", &solid_hgc_vx);
//   solid_hgc->SetBranchAddress("vy", &solid_hgc_vy);
//   solid_hgc->SetBranchAddress("vz", &solid_hgc_vz);
//   solid_hgc->SetBranchAddress("mvx", &solid_hgc_mvx);
//   solid_hgc->SetBranchAddress("mvy", &solid_hgc_mvy);
//   solid_hgc->SetBranchAddress("mvz", &solid_hgc_mvz);
//   solid_hgc->SetBranchAddress("avg_t", &solid_hgc_avg_t);
//   solid_hgc->SetBranchAddress("id", &solid_hgc_id);
// 	}
vector<double> *flux_hitn=0;
vector<double> *allraws_hitn=0,*solid_gem_hitn=0,*solid_ec_hitn=0,*solid_lgc_hitn=0,*solid_mrpc_hitn=0,*solid_spd_hitn=0,*solid_hgc_hitn=0;
allraws->SetBranchAddress("hitn", &allraws_hitn);
flux->SetBranchAddress("hitn", &flux_hitn);
solid_gem->SetBranchAddress("hitn", &solid_gem_hitn);
solid_ec->SetBranchAddress("hitn", &solid_ec_hitn);
solid_lgc->SetBranchAddress("hitn", &solid_lgc_hitn);
if(Is_morebanks){
solid_mrpc->SetBranchAddress("hitn", &solid_mrpc_hitn);
solid_spd->SetBranchAddress("hitn", &solid_spd_hitn);
solid_hgc->SetBranchAddress("hitn", &solid_hgc_hitn);
}

	long long int fNentries = generated->GetEntries();
	
	cout << "total number of events " << fNentries << endl;
	
	int counter=0;
	for (int i=0; i<fNentries; i++){
// 		if (i % 1000000 == 0) std::cout<<i<<endl;
			header->GetEntry(i);
			generated->GetEntry(i);
			allraws->GetEntry(i);
			flux->GetEntry(i);		
			solid_gem->GetEntry(i);
			solid_ec->GetEntry(i);
			solid_lgc->GetEntry(i);	
			if(Is_morebanks){		
			  solid_mrpc->GetEntry(i);
			  solid_spd->GetEntry(i);
			  solid_hgc->GetEntry(i);
			}
			
			if(Is_morebanks){			
			  if (solid_gem_hitn->size() > 0 ||
			      flux_hitn->size() > 0 ||
			      solid_ec_hitn->size() > 0 ||
			      solid_lgc_hitn->size() > 0 ||		  
			      solid_mrpc_hitn->size() > 0 ||
		              solid_spd_hitn->size() > 0 ||			      
		              solid_hgc_hitn->size() > 0){			   

			      counter++;
			      
			      output_header->Fill();
			      output_generated->Fill();
			      output_allraws->Fill();
			      output_flux->Fill();		
			      output_solid_gem->Fill();
			      output_solid_ec->Fill();
			      output_solid_lgc->Fill();		
			      output_solid_mrpc->Fill();
			      output_solid_spd->Fill();
			      output_solid_hgc->Fill();
			    }	
			}
			else{
			  if (solid_gem_hitn->size() > 0 ||
			      flux_hitn->size() > 0 ||
			      solid_ec_hitn->size() > 0 ||
			      solid_lgc_hitn->size() > 0){

// 			    cout<<" first " << flux_hitn->size()<< endl;
// // cout<<" secd " << flux_hitn->size()<< endl;
// 				for (int j=0; j<flux_hitn->size();j++){
// // 		  cout<< "middle " << flux_hitn->size()<< endl;
// 		  cout<<flux_hitn->at(j)<< "  " ;		  
// 				}			    
// cout<<" third " << flux_hitn->size()<< endl;				

			      counter++;
			      
			      output_header->Fill();
			      output_generated->Fill();
			      output_allraws->Fill();
			      output_flux->Fill();		
			      output_solid_gem->Fill();
			      output_solid_ec->Fill();
			      output_solid_lgc->Fill();	
			    }				  
			}

//   ///////////////header vectors////////////////////////////
//   header_time->clear();  header_evn->clear();  header_evn_type->clear();  header_beamPol->clear();  header_var1->clear();  header_var2->clear();  header_var3->clear();  header_var4->clear();  header_var5->clear();  header_var6->clear();  header_var7->clear();  header_var8->clear();  
// 
//   ////////////////generated vectors////////////////////////
//   generated_pid->clear();  generated_px->clear();  generated_py->clear();  generated_pz->clear();  generated_vx->clear();  generated_vy->clear();  generated_vz->clear();  
//   
// 	///////////////allraws vectors//////////////////////
// 	allraws_pid->clear();  allraws_mpid->clear();  allraws_tid->clear();  allraws_mtid->clear();  allraws_otid->clear();  allraws_trackE->clear();  allraws_edep->clear();  allraws_x->clear();  allraws_y->clear();  allraws_z->clear();  allraws_lx->clear();  allraws_ly->clear();  allraws_lz->clear();  allraws_px->clear();  allraws_py->clear();  allraws_pz->clear();  allraws_vx->clear();  allraws_vy->clear();  allraws_vz->clear();  allraws_mvx->clear();  allraws_mvy->clear();  allraws_mvz->clear();  allraws_t->clear();  allraws_stepn->clear();  allraws_hitn->clear();
// 	
// 	/////////flux vectors//////////////
// 	flux_hitn->clear();  flux_id->clear();  flux_pid->clear();  flux_mpid->clear();  flux_tid->clear();  flux_mtid->clear();  flux_otid->clear();  flux_trackE->clear();  flux_totEdep->clear();  flux_avg_x->clear();  flux_avg_y->clear();  flux_avg_z->clear();  flux_avg_lx->clear();  flux_avg_ly->clear();  flux_avg_lz->clear();  flux_px->clear();  flux_py->clear();  flux_pz->clear();  flux_vx->clear();  flux_vy->clear();  flux_vz->clear();  flux_mvx->clear();  flux_mvy->clear();  flux_mvz->clear();  flux_avg_t->clear();  
// 	
// ///////solid gem vectors/////////			    
// 	solid_gem_hitn->clear();  solid_gem_ETot->clear();  solid_gem_x->clear();  solid_gem_y->clear();  solid_gem_z->clear();  solid_gem_lxin->clear();  solid_gem_lyin->clear();  solid_gem_lzin->clear();  solid_gem_tin->clear();  solid_gem_lxout->clear();  solid_gem_lyout->clear();  solid_gem_lzout->clear();  solid_gem_tout->clear();  solid_gem_pid->clear();  solid_gem_vx->clear();  solid_gem_vy->clear();  solid_gem_vz->clear();  solid_gem_trE->clear();  solid_gem_trid->clear();  solid_gem_weight->clear();  solid_gem_px->clear();  solid_gem_py->clear();  solid_gem_pz->clear();  solid_gem_id->clear();
// 
//   ///////////solid ec vectors///////////////
//   solid_ec_pid->clear();  solid_ec_mpid->clear();  solid_ec_tid->clear();  solid_ec_mtid->clear();  solid_ec_otid->clear();  solid_ec_trackE->clear();  solid_ec_totEdep->clear();  solid_ec_avg_x->clear();  solid_ec_avg_y->clear();  solid_ec_avg_z->clear();  solid_ec_avg_lx->clear();  solid_ec_avg_ly->clear();  solid_ec_avg_lz->clear();  solid_ec_px->clear();  solid_ec_py->clear();  solid_ec_pz->clear();  solid_ec_vx->clear();  solid_ec_vy->clear();  solid_ec_vz->clear();  solid_ec_mvx->clear();  solid_ec_mvy->clear();  solid_ec_mvz->clear();  solid_ec_avg_t->clear();  solid_ec_id->clear();  solid_ec_hitn->clear();
//   
//  ////////////////solid lgc vectors///////////////////
//   solid_lgc_hitn->clear();  solid_lgc_sector->clear();  solid_lgc_pmt->clear();  solid_lgc_pixel->clear();  solid_lgc_nphe->clear();  solid_lgc_avg_t->clear();   
//   
// if(Is_morebanks){  
//   ///////////solid mrpc vectors////////////
//   solid_mrpc_pid->clear();   solid_mrpc_mpid->clear();   solid_mrpc_tid->clear();   solid_mrpc_mtid->clear();   solid_mrpc_otid->clear();   solid_mrpc_trackE->clear();   solid_mrpc_totEdep->clear();   solid_mrpc_avg_x->clear();   solid_mrpc_avg_y->clear();   solid_mrpc_avg_z->clear();   solid_mrpc_avg_lx->clear();   solid_mrpc_avg_ly->clear();   solid_mrpc_avg_lz->clear();   solid_mrpc_px->clear();   solid_mrpc_py->clear();   solid_mrpc_pz->clear();   solid_mrpc_vx->clear();   solid_mrpc_vy->clear();   solid_mrpc_vz->clear();   solid_mrpc_mvx->clear();   solid_mrpc_mvy->clear();   solid_mrpc_mvz->clear();   solid_mrpc_avg_t->clear();   solid_mrpc_id->clear();   solid_mrpc_hitn->clear();  
//   ////////solid spd vectors//////////////
// 	solid_spd_pid->clear();   solid_spd_mpid->clear();   solid_spd_tid->clear();   solid_spd_mtid->clear();   solid_spd_otid->clear();   solid_spd_trackE->clear();   solid_spd_totEdep->clear();   solid_spd_avg_x->clear();   solid_spd_avg_y->clear();   solid_spd_avg_z->clear();   solid_spd_avg_lx->clear();   solid_spd_avg_ly->clear();   solid_spd_avg_lz->clear();   solid_spd_px->clear();   solid_spd_py->clear();   solid_spd_pz->clear();   solid_spd_vx->clear();   solid_spd_vy->clear();   solid_spd_vz->clear();   solid_spd_mvx->clear();   solid_spd_mvy->clear();   solid_spd_mvz->clear();   solid_spd_avg_t->clear();   solid_spd_id->clear();   solid_spd_hitn->clear();  
//   //////////solid hgc vectors////////////////
//   solid_hgc_hitn->clear();   solid_hgc_pid->clear();   solid_hgc_mpid->clear();   solid_hgc_tid->clear();   solid_hgc_mtid->clear();   solid_hgc_otid->clear();   solid_hgc_trackE->clear();   solid_hgc_totEde	p->clear();   solid_hgc_avg_x->clear();   solid_hgc_avg_y->clear();   solid_hgc_avg_z->clear();   solid_hgc_avg_lx->clear();   solid_hgc_avg_ly->clear();   solid_hgc_avg_lz->clear();   solid_hgc_px->clear();   solid_hgc_py->clear();   solid_hgc_pz->clear();   solid_hgc_vx->clear();   solid_hgc_vy->clear();   solid_hgc_vz->clear();   solid_hgc_mvx->clear();   solid_hgc_mvy->clear();   solid_hgc_mvz->clear();   solid_hgc_avg_t->clear();   solid_hgc_id->clear();
// }

	}
	cout << "skim counter " <<  counter << endl;
	
	f2->cd();
	
	output_header->Write();
	output_generated->Write();
	output_allraws->Write();
	output_flux->Write();		
	output_solid_gem->Write();
	output_solid_ec->Write();
	output_solid_lgc->Write();		
	if(Is_morebanks){	
	output_solid_mrpc->Write();
	output_solid_spd->Write();
	output_solid_hgc->Write();
	}
	
	f2->Close();
	f1->Close();
	
};
