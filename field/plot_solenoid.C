#include <iomanip>
#include <iostream>
#include <fstream>
#include <regex>
#include <sstream>
#include <TExec.h>
#include <TPaletteAxis.h>
using namespace std;

void plot_solenoid_signed_palette(bool negative)
{
  static int positive_colors[255],negative_colors[255];
  static bool initialized=false;
  if (!initialized) {
    double stops[]={0,1};
    double red_positive[]={1,0.65},green_positive[]={0.90,0.02},blue_positive[]={0.85,0.02};
    double red_negative[]={0.85,0.05},green_negative[]={0.92,0.20},blue_negative[]={1,0.65};
    int positive_first=TColor::CreateGradientColorTable(2,stops,red_positive,green_positive,blue_positive,255);
    int negative_first=TColor::CreateGradientColorTable(2,stops,red_negative,green_negative,blue_negative,255);
    for (int i=0;i<255;i++) {
      positive_colors[i]=positive_first+i;
      negative_colors[i]=negative_first+i;
    }
    initialized=true;
  }
  gStyle->SetPalette(255,negative ? negative_colors : positive_colors);
}

void plot_solenoid_linear_palette()
{
  static int colors[256];
  static bool initialized=false;
  if (!initialized) {
    double stops[]={0,1};
    double red_negative[]={0.05,0.55},green_negative[]={0.20,0.65},blue_negative[]={0.65,1};
    double red_positive[]={1,0.65},green_positive[]={0.55,0.02},blue_positive[]={0.55,0.02};
    int negative_first=TColor::CreateGradientColorTable(2,stops,red_negative,green_negative,blue_negative,128);
    int positive_first=TColor::CreateGradientColorTable(2,stops,red_positive,green_positive,blue_positive,128);
    for (int i=0;i<128;i++) colors[i]=negative_first+i;
    for (int i=0;i<128;i++) colors[128+i]=positive_first+i;
    initialized=true;
  }
  gStyle->SetPalette(256,colors);
}

void plot_solenoid_signed_linear(TH2F *field)
{
  gPad->SetRightMargin(0.16);
  field->Draw("axis");
  (new TExec(Form("%s_linear_palette",field->GetName()),"plot_solenoid_linear_palette();"))->Draw();
  field->Draw("colz same");
  field->Draw("axis same");
  (new TExec(Form("%s_linear_restore",field->GetName()),"gStyle->SetPalette(1);"))->Draw();
}

void plot_solenoid_signed_log(TH2F *field)
{
gPad->SetLogz(1);
gPad->SetRightMargin(0.30);
TH2F *positive = static_cast<TH2F*>(field->Clone(Form("%s_positive_log",field->GetName())));
TH2F *negative = static_cast<TH2F*>(field->Clone(Form("%s_negative_log",field->GetName())));
for (TH2F *hist : {positive,negative}) {
  hist->SetDirectory(nullptr);
  hist->Reset();
  hist->SetMinimum(1);
  hist->SetMaximum(field->GetMaximum());
  hist->SetContour(255);
}
for (int bin=0; bin<field->GetNcells(); bin++) {
  double value=field->GetBinContent(bin);
  if (value>0) positive->SetBinContent(bin,value);
  if (value<0) negative->SetBinContent(bin,-value);
}
positive->SetTitle(Form("%s: red positive, blue negative",field->GetName()));
if (string(field->GetName())=="Bperp")
  positive->SetTitle("Bperp: path from (Z,R)=(0,0); red +, blue -");
if (string(field->GetName())=="Bperp_sidis")
  positive->SetTitle("Bperp: path from (Z,R)=(-350,0); red +, blue -");
positive->GetZaxis()->SetTitle(Form("+%s (G)",field->GetName()));
negative->GetZaxis()->SetTitle(Form("-%s (G)",field->GetName()));
positive->Draw("axis");
(new TExec(Form("%s_positive_palette",field->GetName()),"plot_solenoid_signed_palette(false);"))->Draw();
positive->Draw("colz same");
(new TExec(Form("%s_negative_palette",field->GetName()),"plot_solenoid_signed_palette(true);"))->Draw();
negative->Draw("colz same");
(new TExec(Form("%s_restore_palette",field->GetName()),"gStyle->SetPalette(1);"))->Draw();
gPad->Update();
for (TH2F *hist : {positive,negative}) {
  auto palette=static_cast<TPaletteAxis*>(hist->GetListOfFunctions()->FindObject("palette"));
  double left=hist==positive ? 0.72 : 0.86;
  palette->SetX1NDC(left);
  palette->SetX2NDC(left+0.025);
  palette->SetLabelSize(0.025);
  palette->SetTitleSize(0.025);
}
}

void plot_solenoid(string input_filename)
{

ifstream input(input_filename.c_str());
if (input.good()) cout << "open file " << input_filename << " OK" <<endl;
else {cout << "can't open the file" << endl; return;}

// Read grid bounds and point counts from the GEMC coordinate header.
double Rmin=0,Rmax=0,Zmin=0,Zmax=0;
int Num_R=0,Num_Z=0;
bool have_R=false,have_Z=false,header_end=false;
string line;
auto read_coordinate = [](const string &line, double &minimum, double &maximum, int &increments) {
  smatch points,low,high;
  if (!regex_search(line,points,regex("npoints\\s*=\\s*\"([^\"]+)\"")) ||
      !regex_search(line,low,regex("min\\s*=\\s*\"([^\"]+)\"")) ||
      !regex_search(line,high,regex("max\\s*=\\s*\"([^\"]+)\""))) return false;
  int count;
  if (!(istringstream(points[1].str()) >> count) ||
      !(istringstream(low[1].str()) >> minimum) ||
      !(istringstream(high[1].str()) >> maximum)) return false;
  increments=count-1;
  return count>1 && maximum>minimum;
};
while (getline(input,line)) {
  if (regex_search(line,regex("name\\s*=\\s*\"transverse\"")))
    have_R=read_coordinate(line,Rmin,Rmax,Num_R);
  if (regex_search(line,regex("name\\s*=\\s*\"longitudinal\"")))
    have_Z=read_coordinate(line,Zmin,Zmax,Num_Z);
  if (line.find("</mfield>") != string::npos) {header_end=true; break;}
}
if (!have_R || !have_Z || !header_end) {
  cout << "invalid or missing coordinate header" << endl;
  return;
}
cout << "Rmin " << Rmin << " Rmax " << Rmax << " Zmin " << Zmin << " Zmax " << Zmax << endl;
cout << "Num_R " << Num_R << " Num_Z " << Num_Z << " (increments)" << endl;

// char textline[200];
// for (int k = 0; k<13; k++) {
//   input.getline(textline,200);
//   string sline=textline;
//   if (sline.find("transverse") !=  string::npos){
//     cout << sline.substr(sline.find("npoints=\"")+9,sline.find("\"",sline.find("npoints=\""))) << endl;
// //       cout << sline << endl;
//   }
// //     npoints="200"   min="0"  max="199"
//     
// //     sprintf(the_filename, "%s",input_filename.substr(0,input_filename.rfind(".")).c_str());
// }

//==================================
// <mfield>
//        <description name="meic_det1_solenoid_dual_v2" factory="ASCII" comment="meic_det1_solenoid_dual_v2"/>
//        <symmetry type="cylindrical-z" format="map" integration="RungeKutta" minStep="1*mm"/>
//        <map>
//                <coordinate> 
//                        <first  name="transverse" npoints="301"   min="0"  max="300"  units="cm"/>
//                        <second name="longitudinal"   npoints="1601"  min="-800" max="800"  units="cm"/>
//                </coordinate>
//                <field unit="gauss"/>
//                <interpolation type="none"/>
//                <shift z="0" units="cm"/>
//        </map>
// </mfield>
// 0.00000000000      -800.000000000     -0.174481412155E-13  284.949770458    
// 0.00000000000      -799.000000000     -0.175181225970E-13  286.092653150    
// 0.00000000000      -798.000000000     -0.175884881363E-13  287.241809614    
// 0.00000000000      -797.000000000     -0.176592405707E-13  288.397284555    
//================================== 

// double Rmin,Rmax,Zmin,Zmax;
// int Num_R,Num_Z;
// char textline[200];
// string pl;

  // reads and discard the first 13 lines of text
// for (int k = 0; k<13; k++) input.getline(textline,200);

//================================== 
//(Rmin,Zmin) = (0.0,-300)
// (Rmax,Zmax) = (300,475)
// R and Z increments:   300   775
//================================== 

//readin R and Z info
// input.getline(textline,200);
// input >> textline >> textline >> textline;
// pl=textline;
// int pl_first= pl.find(",");pl_last= pl.rfind(",");pl_init=1;pl_end=pl.size()-1;
// Rmin=atof(pl.substr(pl_init,pl_first).c_str());
// Zmin=atof(pl.substr(pl_last+1,pl_end).c_str());
// cout << "Rmin " << Rmin << " Zmin " << Zmin << endl; 
// // input.getline(textline,200);
// input >> textline >> textline >> textline;
// pl=textline;
// pl_first= pl.find(",");pl_last= pl.rfind(",");pl_init=1;pl_end=pl.size()-1;
// Rmax=atof(pl.substr(pl_init,pl_first).c_str());
// Zmax=atof(pl.substr(pl_last+1,pl_end).c_str());
// cout << "Rmax " << Rmax << " Zmax " << Zmax << endl; 
// input >> textline >> textline >> textline >> textline >> Num_R >> Num_Z; //reads the line like "R and Z increments:   300   775"
// cout << "R and Z increments:\t" << Num_R << "\t" << Num_Z << endl;
// const int constNum_R=Num_R+1,constNum_Z=Num_Z+1;
// cout << "please put " << constNum_R << " " << constNum_Z << " instead into database" << endl;
// cout << "the units are in cm and G" << endl;

char filename[100];
sprintf(filename, "%s",input_filename.substr(0,input_filename.rfind(".")).c_str());

char output_filename[100];
sprintf(output_filename, "%s.root",filename);
TFile *rootfile=new TFile(output_filename, "recreate");

// for solidnoid map
// double Rmin=0,Rmax=500,Zmin=-600,Zmax=600;
// int Num_R=500,Num_Z=1200;

const int constNum_R=Num_R+1,constNum_Z=Num_Z+1;
const double step_R=(Rmax-Rmin)/Num_R,step_Z=(Zmax-Zmin)/Num_Z;

TH1F *hBz_axis = new TH1F("Bz_axis","Bz_axis",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2);
hBz_axis->GetXaxis()->SetTitle("Z (cm)");
hBz_axis->GetYaxis()->SetTitle("Bz (G)");

TH2F *hBr = new TH2F("Br","Br",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
TH2F *hBz = new TH2F("Bz","Bz",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
TH2F *hB = new TH2F("B","B",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
TH2F *hdBzdr = new TH2F("dBzdr","dBz/dz",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
TH2F *hdBrdz = new TH2F("dBrdz","dBr/dz",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
TH2F *hFI = new TH2F("Field Index","Field Index",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
TH2F *hBperp = new TH2F("Bperp","Bperp: path from (Z,R)=(0,0)",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
TH2F *hBperp_sidis = new TH2F("Bperp_sidis","Bperp: path from (Z,R)=(-350,0)",constNum_Z,Zmin-step_Z/2,Zmax+step_Z/2,constNum_R,Rmin-step_R/2,Rmax+step_R/2);
hBperp_sidis->GetXaxis()->SetTitle("Z (cm)");
hBperp_sidis->GetYaxis()->SetTitle("R (cm)");

// Read field rows directly; their ordering does not affect the plots.
double R,Z,Br,Bz;
double B,Bperp;
long long rows=0;
while (input >> R >> Z >> Br >> Bz) {
        rows++;

	B=sqrt(Br*Br+Bz*Bz);
	Bperp=B*sin(atan2(Br,Bz)-atan2(R,Z));
	
// 	cout << R << "\t" << Z << "\t" << Br << "\t" << Bz << endl; 

	if (int(R)==0) hBz_axis->Fill(Z,Bz);
	hBr->Fill(Z,R,Br);
	hBz->Fill(Z,R,Bz);
	hB->Fill(Z,R,B);
// 	hdBzdr->Fill(Z,R,dBzdr);
// 	hdBrdz->Fill(Z,R,dBrdz);
// 	hFI->Fill(Z,R,FI);
	hBperp->Fill(Z,R,Bperp);
	// The path direction is undefined at the SIDIS target itself.
	if (R!=0 || Z!=-350)
	  hBperp_sidis->Fill(Z,R,B*sin(atan2(Br,Bz)-atan2(R,Z+350)));
	
// 	input.getline(textline,200); //get the rest of line
//       cout.width(10);
//       cout.setf(0,ios::floatfield);
//       cout.setf(ios::fixed,ios::floatfield);
//     cout.precision(6);
//     cout << scientific << 
//     cout << R[i][j] << "\t" <<  Z[i][j] <<  "\t" <<  Br[i][j] <<  "\t" <<  Bz[i][j] << endl; 
// 	cout << j << "\t" << i << "\r";
}
if (!input.eof() || rows != static_cast<long long>(constNum_R)*constNum_Z) {
  cout << "invalid field data: read " << rows << " rows, expected "
       << static_cast<long long>(constNum_R)*constNum_Z << endl;
  return;
}
cout << "read " << rows << " field rows" << endl;
//     cout << R << "\t" <<  Z <<  "\t" <<  Br <<  "\t" <<  Bz << endl;  
input.close();
cout << "finish reading in" << endl;

// Shared linear limits cover CLEOv8-CLEOv12, excluding Oxford maps.
bool oxford_map=input_filename.substr(input_filename.find_last_of("/\\")+1)=="oxford_ptarget.dat";
for (TH2F *hist : {hBr,hBz,hBperp,hBperp_sidis}) {
  double limit=hist==hBperp_sidis ? 6e4 : 4e4;
  if (oxford_map) limit=ceil(max(abs(hist->GetMinimum()),abs(hist->GetMaximum()))/1e4)*1e4;
  hist->SetMinimum(-limit);
  hist->SetMaximum(limit);
  double levels[256];
  for (int i=0;i<256;i++) levels[i]=(i-128)*limit/128;
  hist->SetContour(256,levels);
}
hB->SetMinimum(0);
hB->SetMaximum(oxford_map ? ceil(hB->GetMaximum()/1e4)*1e4 : 6e4);

rootfile->Write();
rootfile->Flush();
cout << "output rootfile " << output_filename << endl;

gStyle->SetPalette(1);
gStyle->SetOptStat(0);

gSystem->mkdir("plot",kTRUE); // PNGs go to plot/, run from field/ with the map name only
TCanvas *c_fieldBz = new TCanvas("fieldBz","fieldBz",800,600);
c_fieldBz->SetLeftMargin(0.15);
hBz_axis->Draw("hist");
c_fieldBz->SaveAs(Form("plot/%s_fieldBz.png",filename));

TCanvas *c_fieldmap = new TCanvas("fieldmap","Br, Bz, B: linear and log",2400,1000);
c_fieldmap->Divide(3,2);
c_fieldmap->cd(1);
plot_solenoid_signed_linear(hBr);
c_fieldmap->cd(2);
plot_solenoid_signed_linear(hBz);
c_fieldmap->cd(3);
gPad->SetRightMargin(0.16);
hB->Draw("axis");
(new TExec("B_linear_palette","gStyle->SetPalette(kRainBow);"))->Draw();
hB->Draw("colz same");
(new TExec("B_linear_restore","gStyle->SetPalette(1);"))->Draw();
c_fieldmap->cd(4);
plot_solenoid_signed_log(hBr);
c_fieldmap->cd(5);
plot_solenoid_signed_log(hBz);
c_fieldmap->cd(6);
gPad->SetLogz(1);
gPad->SetRightMargin(0.16);
TH1 *hB_log=hB->DrawCopy("colz");
hB_log->SetMinimum(1);
hB_log->SetMaximum(hB->GetMaximum());
c_fieldmap->SaveAs(Form("plot/%s_fieldmap.png",filename));

TCanvas *c_Bperp = new TCanvas("Bperp_map","Bperp: linear and log",1600,1000);
c_Bperp->Divide(2,2);
c_Bperp->cd(1);
gPad->SetLeftMargin(0.14);
gPad->SetBottomMargin(0.12);
plot_solenoid_signed_linear(hBperp);
c_Bperp->cd(2);
gPad->SetLeftMargin(0.14);
gPad->SetBottomMargin(0.12);
plot_solenoid_signed_linear(hBperp_sidis);
c_Bperp->cd(3);
gPad->SetLeftMargin(0.14);
gPad->SetBottomMargin(0.12);
plot_solenoid_signed_log(hBperp);
c_Bperp->cd(4);
gPad->SetLeftMargin(0.14);
gPad->SetBottomMargin(0.12);
plot_solenoid_signed_log(hBperp_sidis);
c_Bperp->SaveAs(Form("plot/%s_Bperp.png",filename));

}
