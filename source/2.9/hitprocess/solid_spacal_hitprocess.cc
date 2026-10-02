// G4 headers
#include "G4SystemOfUnits.hh"

// gemc headers
#include "solid_spacal_hitprocess.h"
#include "solid_spacal_model.h"

// Fiber code = clad copy number written by spacal_proto3/solid_spacal_geometry.pl:
//   code = 100000*(sector+1) + 10000*tower + fid,   fid = NFiberY*ix + iy (sPHENIX fiber id)
// Readout channel id = 10000 + 1000*sector + 100*tower + 10*subx + suby (sPHENIX sub-tower).
// Parameters read from solid_spacal_proto3__parameters_<variation>.txt:
//   tower<j>_NFiberX, tower<j>_NFiberY, tower<j>_NSubtowerX, tower<j>_NSubtowerY,
//   spacal_birks_kB (mm/MeV), spacal_time_min / spacal_time_max (ns, sPHENIX cell timing window).

double solid_spacal_HitProcess :: par(const string& name)
{
	map<string, double>::const_iterator it = gpars.find(name);
	if(it == gpars.end()) {
		cout << " !!! solid_spacal hit process: parameter " << name << " not found. Is the detector's __parameters file loaded? Exiting." << endl;
		exit(1);
	}
	return it->second;
}

map<string, double> solid_spacal_HitProcess :: integrateDgt(MHit* aHit, int hitn)
{
	using namespace solid_spacal_model;
	map<string, double> dgtz;
	vector<identifier> identity = aHit->GetId();

	const int code   = identity[0].id;
	const int sector = code/100000 - 1;
	const int tower  = (code/10000) % 10;
	const int fid    = code % 10000;

	const string tp  = "tower" + to_string(tower) + "_";
	const int nfx    = (int) lround(par(tp + "NFiberX"));
	const int nfy    = (int) lround(par(tp + "NFiberY"));
	const int nsx    = (int) lround(par(tp + "NSubtowerX"));
	const int nsy    = (int) lround(par(tp + "NSubtowerY"));
	const double kB   = par("spacal_birks_kB");    // mm/MeV (gemc internal units: mm = MeV = 1)
	const double tmin = par("spacal_time_min");    // ns (ns = 1)
	const double tmax = par("spacal_time_max");

	const int subx = sub_tower_x(fid, nfx, nfy, nsx);
	const int suby = sub_tower_y(fid, nfy, nsy);
	const double lg_eff = light_guide_efficiency(position_fraction_x(fid, nfx, nfy, nsx), position_fraction_y(fid, nfy, nsy));

	vector<G4ThreeVector> Lpos = aHit->GetLPos();   // local position in the fiber core, mm; z along the fiber
	vector<double> Edep        = aHit->GetEdep();   // MeV
	vector<double> dx          = aHit->GetDx();     // mm
	vector<int>    charge      = aHit->GetCharges();
	vector<double> times       = aHit->GetTime();   // ns

	double edep = 0, edepB = 0, light_z = 0, et = 0;
	for(unsigned s = 0; s < Edep.size(); s++) {
		if(times[s] < tmin || times[s] > tmax) continue;
		const double eB = birks(Edep[s], dx[s], charge[s], kB);
		edep    += Edep[s];
		edepB   += eB;
		light_z += eB * fiber_transmission(Lpos[s].z()/cm);
		et      += Edep[s] * times[s];
	}

	dgtz["hitn"]  = hitn;
	dgtz["id"]    = 10000 + 1000*sector + 100*tower + 10*subx + suby;
	dgtz["fiber"] = code;
	dgtz["edep"]  = edep;
	dgtz["edepB"] = edepB;
	dgtz["light"] = light_z * lg_eff;
	dgtz["t"]     = edep > 0 ? et/edep : 0;

	return dgtz;
}

vector<identifier>  solid_spacal_HitProcess :: processID(vector<identifier> id, G4Step* aStep, detector Detector)
{
	id[id.size()-1].id_sharing = 1;
	return id;
}

// - electronicNoise: returns a vector of hits generated / by electronics.
vector<MHit*> solid_spacal_HitProcess :: electronicNoise()
{
	vector<MHit*> noiseHits;
	return noiseHits;
}

map< string, vector <int> >  solid_spacal_HitProcess :: multiDgt(MHit* aHit, int hitn)
{
	map< string, vector <int> > MH;
	return MH;
}

// - charge: returns charge/time digitized information / step
map< int, vector <double> > solid_spacal_HitProcess :: chargeTime(MHit* aHit, int hitn)
{
	map< int, vector <double> >  CT;
	return CT;
}

// - voltage: returns a voltage value for a given time.
double solid_spacal_HitProcess :: voltage(double charge, double time, double forTime)
{
	return 0.0;
}
