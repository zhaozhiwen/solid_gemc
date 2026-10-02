// Unit test of ../../source/2.9/hitprocess/solid_spacal_model.h against ROOT and the fiber oracle.
// Run (in the container): root -l -b -q test_spacal_model.C
// Needs sphenix_ref/Prototype2Module.xml (see readme) and ref_fibers_Original.txt (python3 fiber_layout_ref.py ...).
//   1. fiber_transmission vs TH1::Interpolate, light_guide_efficiency vs TH2::Interpolate
//      (random points, bin centres, bin edges, the full fiber range +-8.3 cm, the sub-tower fraction range)
//   2. sub_tower_x/y vs ref_fibers_Original.txt (Python port of sPHENIX)
//   3. birks against the closed form
#include "../../source/2.9/hitprocess/solid_spacal_model.h"

void test_spacal_model()
{
	using namespace solid_spacal_model;
	TFile* f = TFile::Open("sphenix_ref/Prototype2Module.xml");
	TH2* h2 = (TH2*) f->Get("data_grid_light_guide_efficiency");
	TH1* h1 = (TH1*) f->Get("data_grid_fiber_trans");
	TRandom3 r(1);
	double d1 = 0, d2 = 0;
	std::vector<double> zs, xs;
	for (int i = 0; i < 200000; i++) zs.push_back(r.Uniform(-8.3, 8.3));
	for (int i = 1; i <= h1->GetNbinsX(); i++) { zs.push_back(h1->GetBinCenter(i)); zs.push_back(h1->GetBinLowEdge(i)); }
	for (double z : zs) d1 = std::max(d1, std::fabs(fiber_transmission(z) - h1->Interpolate(z)));
	for (int i = 0; i < 200000; i++) {
		const double x = r.Uniform(0, 1), y = r.Uniform(0, 1);
		d2 = std::max(d2, std::fabs(light_guide_efficiency(x, y) - h2->Interpolate(x, y)));
	}
	// fractions actually used: (k + 0.5) / 47 and (k + 0.5) / 26
	for (int kx = 0; kx < 47; kx++) for (int ky = 0; ky < 26; ky++) {
		const double x = (kx + 0.5) / 47., y = (ky + 0.5) / 26.;
		d2 = std::max(d2, std::fabs(light_guide_efficiency(x, y) - h2->Interpolate(x, y)));
	}
	for (int i = 1; i <= h2->GetNbinsX(); i++) for (int j = 1; j <= h2->GetNbinsY(); j++) {
		const double x = h2->GetXaxis()->GetBinCenter(i), y = h2->GetYaxis()->GetBinCenter(j);
		d2 = std::max(d2, std::fabs(light_guide_efficiency(x, y) - h2->Interpolate(x, y)));
	}
	printf("fiber_transmission    max |model - TH1::Interpolate| = %.3e over %zu points\n", d1, zs.size());
	printf("light_guide_efficiency max |model - TH2::Interpolate| = %.3e\n", d2);

	// sub-tower ids vs oracle (columns: tower fid ix iy subx suby ...)
	std::ifstream in("ref_fibers_Original.txt");
	int j, fid, ix, iy, sx, sy, nbad = 0, n = 0;
	double rest[7];
	while (in >> j >> fid >> ix >> iy >> sx >> sy >> rest[0] >> rest[1] >> rest[2] >> rest[3] >> rest[4] >> rest[5] >> rest[6]) {
		n++;
		if (sub_tower_x(fid, 94, 52, 2) != sx || sub_tower_y(fid, 52, 2) != sy) nbad++;
		const double fx = position_fraction_x(fid, 94, 52, 2), fy = position_fraction_y(fid, 52, 2);
		if (fx <= 0 || fx >= 1 || fy <= 0 || fy >= 1) nbad++;
	}
	printf("sub-tower ids vs oracle: %d fibers, %d mismatches\n", n, nbad);

	const double b = birks(1.0, 0.5, -1, 0.07943), bexp = 1.0 / (1 + 0.07943 * 1.0 / 0.5);
	printf("birks(1 MeV, 0.5 mm, kB 0.07943) = %.9f (expected %.9f); neutral: %.3f; kB=0: %.3f\n",
	       b, bexp, birks(1.0, 0.5, 0, 0.07943), birks(1.0, 0.5, 1, 0));
	const bool ok = d1 < 1e-6 && d2 < 1e-6 && nbad == 0 && n == 9776 && std::fabs(b - bexp) < 1e-12;
	printf("%s\n", ok ? "ALL OK" : "FAILURES");
}
