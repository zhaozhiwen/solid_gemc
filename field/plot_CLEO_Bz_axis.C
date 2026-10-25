// Usage: root -l -b -q plot_CLEO_Bz_axis.C
// Inputs: solenoid_CLEOv9.root through solenoid_CLEOv12.root, from plot_solenoid.C.
// Outputs: plot/CLEO_Bz_axis_compare.png and CLEO_Bz_axis_compare.pdf.
#include <algorithm>
#include <iostream>
#include <vector>
#include <TCanvas.h>
#include <TFile.h>
#include <TH1.h>
#include <TLegend.h>
#include <TStyle.h>

void plot_CLEO_Bz_axis()
{
  std::vector<TH1*> curves;
  const int colors[]={kBlue+1,kRed+1,kGreen+2,kMagenta+1};
  const char* labels[]={"full","lite_jpsi","lite_sidis","lite_jpsi+ddvcs"};
  double zmin=0,zmax=0,bmin=0,bmax=0;
  for (int version=9;version<=12;version++) {
    TFile input(Form("solenoid_CLEOv%d.root",version));
    auto axis=input.Get<TH1>("Bz_axis");
    if (input.IsZombie() || !axis) {
      std::cerr << "Missing Bz_axis in solenoid_CLEOv" << version << ".root" << std::endl;
      return;
    }
    auto curve=static_cast<TH1*>(axis->Clone(Form("CLEOv%d_Bz_axis",version)));
    curve->SetDirectory(nullptr);
    curve->SetLineColor(colors[version-9]);
    curve->SetLineStyle(version-8);
    curve->SetLineWidth(2);
    curves.push_back(curve);
    double low=curve->GetXaxis()->GetXmin(),high=curve->GetXaxis()->GetXmax();
    zmin=version==9 ? low : std::min(zmin,low);
    zmax=version==9 ? high : std::max(zmax,high);
    for (int bin=1;bin<=curve->GetNbinsX();bin++) {
      bmin=std::min(bmin,curve->GetBinContent(bin));
      bmax=std::max(bmax,curve->GetBinContent(bin));
    }
  }

  gStyle->SetOptStat(0);
  auto canvas=new TCanvas("CLEO_Bz_axis_compare","CLEO Bz axis comparison",1100,700);
  canvas->SetLeftMargin(0.13);
  canvas->SetBottomMargin(0.12);
  canvas->SetGrid();
  double padding=0.08*(bmax-bmin);
  if (padding==0) padding=1;
  canvas->DrawFrame(zmin,bmin<0 ? bmin-padding : 0,zmax,bmax+padding,
                    "CLEO Bz on axis (R=0);Z (cm);Bz (G)");
  auto legend=new TLegend(0.73,0.65,0.89,0.88);
  legend->SetBorderSize(0);
  legend->SetFillStyle(0);
  for (int i=0;i<4;i++) {
    curves[i]->Draw("hist same");
    legend->AddEntry(curves[i],labels[i],"l");
  }
  legend->Draw();
  gSystem->mkdir("plot",kTRUE);
  canvas->SaveAs("plot/CLEO_Bz_axis_compare.png");
  canvas->SaveAs("CLEO_Bz_axis_compare.pdf");
}
