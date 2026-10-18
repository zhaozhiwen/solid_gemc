#include <TCanvas.h>
#include <TFile.h>
#include <TH1.h>
#include <TPad.h>
#include <TLegend.h>
#include <TLine.h>
#include <TMarker.h>
#include <TLatex.h>
#include <TString.h>
#include <cmath>
#include <iostream>

// option: 1 = SIDIS He3, 2 = JPsi, 3 = PVDIS LD2. outputfile is an optional output basename.
void plot_gem_r(int option=1,const char *outputfile=nullptr)
{
    const char *inputfile;
    const char *title;
    if (option==1) {
        inputfile="/w/halla-scshelf2102/solid/sim/solid_gemc/SIDIS_He3_JLAB_VERSION_2.5/pass3/solid_SIDIS_He3_moved_full_BeamOnTarget_5e10_filter_output.root";
        title="SoLID SIDIS He3 at lumi=10^{37}/cm^{2}/s";
        if (!outputfile) outputfile="solid_sidis_he3_hit_gem_r";
    } else if (option==2) {
        inputfile="/w/halla-scshelf2102/solid/sim/solid_gemc/JPsi_JLAB_VERSION_2.5/pass3/solid_JPsi_LH2_moved_full_BeamOnTarget_5e9_filter_output.root";
        title="SoLID JPsi at lumi=1.2x10^{37}/cm^{2}/s";
        if (!outputfile) outputfile="solid_jpsi_hit_gem_r";
    } else if (option==3) {
        inputfile="/w/halla-scshelf2102/solid/sim/solid_gemc/PVDIS_JLAB_VERSION_2.5/pass3/solid_PVDIS_LD2_moved_full_BeamOnTarget_1e10_filter_output.root";
        title="SoLID PVDIS LD2 at lumi=1.3x10^{39}/cm^{2}/s";
        if (!outputfile) outputfile="solid_pvdis_ld2_hit_gem_r";
    } else {
        std::cerr << "Choose option 1 (SIDIS He3) or 2 (JPsi) or 3 (PVDIS LD2)." << std::endl;
        return;
    }
    TFile file(inputfile,"READ");
    if (file.IsZombie()) return;

    double norm=10; //event normalization factor

    const bool split_FA_LA=option!=3;
    const int ngem=option==3 ? 5 : 6;
    const double radius_max=option==3 ? 250. : 150.;
    TH1 *hist[6]={0};
    const int colors[7]={kBlack,kRed+1,kBlue+1,kGreen+2,kMagenta+1,kOrange+7,kCyan+2};
    // Plane i+1 corresponds to hhit_gem_r_i. Radii in cm from:
    // https://github.com/JeffersonLab/solid_gemc/blob/master/geometry/gem_moved/solid_SIDIS_gem__parameters_Original.txt
    const double rin_sidis[6]={39.,21.,25.,32.,42.,53.};
    const double rout_sidis[6]={87.,98.,112.,135.,99.,122.};
    // ../geometry/gem_moved/solid_PVDIS_gem__parameters_Original.txt
    const double rin_pvdis[5]={51.,61.,63.,104.,107.};
    const double rout_pvdis[5]={115.,135.,138.,237.,244.};
    const double *rin=option==3 ? rin_pvdis : rin_sidis;
    const double *rout=option==3 ? rout_pvdis : rout_sidis;
    int count=0;
    for (int i=0;i<ngem;i++) {
        file.GetObject(Form("hhit_gem_r_%d",i),hist[i]);
        if (!hist[i]) {
            std::cerr << "Missing hhit_gem_r_" << i << "; skipping." << std::endl;
            continue;
        }
        hist[i]->SetDirectory(nullptr); // Keep histograms available after closing the file.
        hist[i]->Scale(norm);
        hist[i]->Scale(1e-2); //change from cm2 to mm2
        hist[i]->SetStats(false);
        hist[i]->SetLineColor(colors[i]);
        hist[i]->SetLineWidth(2);
        count++;
    }
    if (!count) return;

    const double radius_cut[3]={54.,62.,76.};
    const double strip_width_cm=0.1;
    double rate[6]={0},rate_FA[6]={0},rate_LA[6]={0};
    for (int i=0;i<ngem;i++) {
        if (!hist[i]) continue;
        int first_bin=hist[i]->GetXaxis()->FindFixBin(0.);
        int last_bin=hist[i]->GetXaxis()->FindFixBin(std::nextafter(radius_max,0.));
        for (int bin=first_bin;bin<=last_bin;bin++) {
            double low=hist[i]->GetXaxis()->GetBinLowEdge(bin);
            double high=hist[i]->GetXaxis()->GetBinUpEdge(bin);
            // Radial strip area = width * radial bin length; convert cm2 to mm2.
            double bin_rate=hist[i]->GetBinContent(bin)*100.*strip_width_cm*(high-low);
            rate[i]+=bin_rate;
            if (split_FA_LA && i>=1 && i<=3) {
                if (low<radius_cut[i-1]) rate_FA[i]+=bin_rate;
                else rate_LA[i]+=bin_rate;
            }
        }
        std::cout << hist[i]->GetName() << ": 0.1 cm-wide strip, total=" << rate[i] << " kHz";
        if (split_FA_LA && i>=1 && i<=3) std::cout << ", FA=" << rate_FA[i] << ", LA=" << rate_LA[i] << " kHz";
        std::cout << std::endl;
    }

    TCanvas *canvas=new TCanvas("c_gem_r","GEM radial hit rates",1400,700);
    canvas->Divide(2,1);
    canvas->GetPad(1)->SetPad(0.,0.,0.5,0.93);
    canvas->GetPad(2)->SetPad(0.5,0.,1.,0.93);
    canvas->cd(1);
    gPad->SetLeftMargin(0.14);
    gPad->SetRightMargin(0.03);
    gPad->SetGrid();
    gPad->SetLogy();
    TLegend *legend=new TLegend(0.65,0.43,0.94,0.70);
    legend->SetTextSize(0.035);
    legend->SetBorderSize(0);
    bool first=true;
    for (int i=0;i<ngem;i++) {
        if (!hist[i]) continue;
        if (first) {
            hist[i]->SetTitle("GEM hit rates (Edep>26eV in drift gas);radius (cm);hit rate (kHz/mm^{2})");
            hist[i]->GetXaxis()->SetRangeUser(0.,option==3 ? 300. : radius_max);
            hist[i]->SetMinimum(1e-2);
            hist[i]->SetMaximum(1e2);

        }
        hist[i]->Draw(first ? "HIST" : "HIST SAME");
        legend->AddEntry(hist[i],Form("GEM %d",i+1),"l");
        first=false;
    }
    for (int i=0;i<ngem;i++) {
        if (!hist[i]) continue;
        double y=65./std::pow(1.35,i);
        TLine *range=new TLine(rin[i],y,rout[i],y);
        range->SetLineColor(colors[i]);
        range->SetLineWidth(2);
        range->Draw();
        if (split_FA_LA && i>=1 && i<=3) {
            TMarker *cut=new TMarker(radius_cut[i-1],y,20);
            cut->SetMarkerColor(colors[i]);
            cut->SetMarkerSize(1.2);
            cut->Draw();
            TLatex *label=new TLatex(radius_cut[i-1],y*1.1,Form("%.0f",radius_cut[i-1]));
            label->SetTextColor(colors[i]);
            label->SetTextSize(0.022);
            label->SetTextAlign(21);
            label->Draw();
        }
        for (double r : {rin[i],rout[i]}) {
            TLine *tick=new TLine(r,y/1.08,r,y*1.08);
            tick->SetLineColor(colors[i]);
            tick->SetLineWidth(2);
            tick->Draw();
        }
    }
    legend->Draw();

    canvas->cd(2);
    gPad->SetLeftMargin(0.14);
    gPad->SetRightMargin(0.03);
    gPad->SetGridy();
    const char *rate_names[3]={"Strip total","FA strip","LA strip"};
    const int rate_colors[3]={kGray+2,kBlue-7,kOrange-3};
    TH1D *rate_hist[3];
    double max_rate=0;
    for (int i=0;i<ngem;i++) if (rate[i]>max_rate) max_rate=rate[i];
    TLegend *rate_legend=new TLegend(0.59,0.72,0.94,0.89);
    rate_legend->SetBorderSize(0);
    for (int group=0;group<(split_FA_LA ? 3 : 1);group++) {
        rate_hist[group]=new TH1D(Form("gem_rate_%d",group),
            "0.1 cm-wide radial strip;GEM;strip rate (kHz)",ngem,0.5,ngem+0.5);
        rate_hist[group]->SetDirectory(nullptr);
        rate_hist[group]->SetStats(false);
        rate_hist[group]->SetFillColor(rate_colors[group]);
        rate_hist[group]->SetBarWidth(split_FA_LA ? 0.26 : 0.7);
        rate_hist[group]->SetBarOffset(split_FA_LA ? 0.07+group*0.30 : 0.15);
        rate_hist[group]->SetMinimum(0);
        // rate_hist[group]->SetMaximum(max_rate>0 ? 1.3*max_rate : 1.);
        rate_hist[group]->SetMaximum(option==3 ? (max_rate>0 ? 1.3*max_rate : 1.) : 3000);
        for (int i=0;i<ngem;i++) {
            double value=group==0 ? rate[i] : (group==1 ? rate_FA[i] : rate_LA[i]);
            rate_hist[group]->SetBinContent(i+1,value);
            rate_hist[group]->GetXaxis()->SetBinLabel(i+1,Form("%d",i+1));
        }
        rate_hist[group]->Draw(group==0 ? "BAR" : "BAR SAME");
        rate_legend->AddEntry(rate_hist[group],rate_names[group],"f");
    }
    rate_legend->Draw();
    if (split_FA_LA) {
        TLatex *rate_note=new TLatex(0.17,0.84,"FA/LA: GEMs 2-4 only");
        rate_note->SetNDC();
        rate_note->SetTextSize(0.03);
        rate_note->Draw();
    }
    canvas->cd();
    TLatex *lumi_label=new TLatex(0.5,0.965,title);
    lumi_label->SetNDC();
    lumi_label->SetTextAlign(22);
    lumi_label->SetTextSize(0.035);
    lumi_label->Draw();
    canvas->SaveAs(Form("%s.png",outputfile));
    canvas->SaveAs(Form("%s.pdf",outputfile));
}
