#ifndef SOLID_SPACAL_MODEL_H
#define SOLID_SPACAL_MODEL_H 1

// Light model of the sPHENIX SPACAL prototype, ported for the solid_spacal hit process.
// Header-only and free of gemc/Geant4 dependencies so it can be unit-tested against ROOT
// (spacal_proto3/test_spacal_model.C).
//
// sPHENIX references (copies in spacal_proto3/sphenix_ref/):
//   Birks:          PHG4SteppingAction::GetVisibleEnergyDeposition -> G4EmSaturation; Geant4 10.7 sets
//                   kB(G4_POLYSTYRENE) = 0.07943 mm/MeV once EmSaturation() is called (PHG4Reco does).
//   maps:           LightCollectionModel::get_fiber_transmission / get_light_guide_efficiency,
//                   i.e. TH1::Interpolate / TH2::Interpolate on Prototype2Module.xml (solid_spacal_lightmaps.h).
//   fiber geometry: PHG4CylinderGeom_Spacalv3::geom_tower::get_sub_tower_ID_x/y,
//                   get_position_fraction_x/y_in_sub_tower.

#include <cmath>
#include "solid_spacal_lightmaps.h"

namespace solid_spacal_model {

// Birks law for one step (charged particles). edep in MeV, dx in mm, kB in mm/MeV.
// G4EmSaturation quenches neutral-particle deposits too (via the electron range); GEMC steps carry no
// such information, so neutral deposits are left unquenched here.
inline double birks(double edep, double dx, int charge, double kB)
{
	if (edep <= 0) return 0;
	if (charge == 0 || dx <= 0 || kB <= 0) return edep;
	return edep / (1. + kB * edep / dx);
}

// ROOT TAxis::FindFixBin for a fixed-width axis: 0 = underflow, n+1 = overflow.
inline int find_bin(double x, int n, double xmin, double xmax)
{
	if (x < xmin) return 0;
	if (!(x < xmax)) return n + 1;
	return 1 + int(n * (x - xmin) / (xmax - xmin));
}

inline double bin_center(int bin, int n, double xmin, double xmax)
{
	const double w = (xmax - xmin) / n;
	return xmin + (bin - 0.5) * w;
}

// ROOT 6 TH1::Interpolate: linear between bin centres, constant (edge bin content) outside them.
inline double fiber_transmission(double z_cm)
{
	using namespace solid_spacal_maps;
	const int n = tr_n;
	if (z_cm <= bin_center(1, n, tr_min, tr_max)) return tr_val[0];
	if (z_cm >= bin_center(n, n, tr_min, tr_max)) return tr_val[n - 1];
	const int b = find_bin(z_cm, n, tr_min, tr_max);
	int b0 = b, b1 = b + 1;
	if (z_cm <= bin_center(b, n, tr_min, tr_max)) { b0 = b - 1; b1 = b; }
	const double x0 = bin_center(b0, n, tr_min, tr_max), x1 = bin_center(b1, n, tr_min, tr_max);
	const double y0 = tr_val[b0 - 1], y1 = tr_val[b1 - 1];
	return y0 + (z_cm - x0) * ((y1 - y0) / (x1 - x0));
}

// ROOT 6 TH2::Interpolate: bilinear between the four nearest bin centres, edge bins clamped.
inline double light_guide_efficiency(double x, double y)
{
	using namespace solid_spacal_maps;
	const int nx = lg_nx, ny = lg_ny;
	const int bx = find_bin(x, nx, lg_xmin, lg_xmax), by = find_bin(y, ny, lg_ymin, lg_ymax);
	if (bx < 1 || bx > nx || by < 1 || by > ny) return 0;   // ROOT: "Cannot interpolate outside histogram domain"
	const double wx = (lg_xmax - lg_xmin) / nx, wy = (lg_ymax - lg_ymin) / ny;
	const double dx = (lg_xmin + bx * wx) - x;   // distance to bin upper edge
	const double dy = (lg_ymin + by * wy) - y;
	const bool right = dx <= wx / 2, upper = dy <= wy / 2;
	const int ix1 = right ? bx : bx - 1, ix2 = right ? bx + 1 : bx;
	const int iy1 = upper ? by : by - 1, iy2 = upper ? by + 1 : by;
	const double x1 = bin_center(ix1, nx, lg_xmin, lg_xmax), x2 = bin_center(ix2, nx, lg_xmin, lg_xmax);
	const double y1 = bin_center(iy1, ny, lg_ymin, lg_ymax), y2 = bin_center(iy2, ny, lg_ymin, lg_ymax);
	int bx1 = find_bin(x1, nx, lg_xmin, lg_xmax); if (bx1 < 1) bx1 = 1;
	int bx2 = find_bin(x2, nx, lg_xmin, lg_xmax); if (bx2 > nx) bx2 = nx;
	int by1 = find_bin(y1, ny, lg_ymin, lg_ymax); if (by1 < 1) by1 = 1;
	int by2 = find_bin(y2, ny, lg_ymin, lg_ymax); if (by2 > ny) by2 = ny;
	const double q11 = lg_eff[(by1 - 1) * nx + (bx1 - 1)], q21 = lg_eff[(by1 - 1) * nx + (bx2 - 1)];
	const double q12 = lg_eff[(by2 - 1) * nx + (bx1 - 1)], q22 = lg_eff[(by2 - 1) * nx + (bx2 - 1)];
	const double d = (x2 - x1) * (y2 - y1);
	return q11 / d * (x2 - x) * (y2 - y) + q21 / d * (x - x1) * (y2 - y)
	     + q12 / d * (x2 - x) * (y - y1) + q22 / d * (x - x1) * (y - y1);
}

// sPHENIX fiber id = NFiberY * ix + iy. Sub-tower ids are inverted ("x is negative azimuthal direction").
inline int sub_tower_x(int fid, int nfx, int nfy, int nsx) { return (nsx - 1) - int(std::floor((fid / nfy) / ((double) nfx / nsx))); }
inline int sub_tower_y(int fid, int nfy, int nsy)          { return (nsy - 1) - int(std::floor((fid % nfy) / ((double) nfy / nsy))); }
inline double position_fraction_x(int fid, int nfx, int nfy, int nsx)
{
	const double w = (double) nfx / nsx;
	return (std::fmod((double) (fid / nfy), w) + 0.5) / w;
}
inline double position_fraction_y(int fid, int nfy, int nsy)
{
	const double w = (double) nfy / nsy;
	return (std::fmod((double) (fid % nfy), w) + 0.5) / w;
}

} // namespace solid_spacal_model

#endif
