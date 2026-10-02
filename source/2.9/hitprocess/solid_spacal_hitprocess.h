#ifndef SOLID_SPACAL_HITPROCESS_H
#define SOLID_SPACAL_HITPROCESS_H 1

// gemc headers
#include "HitProcess.h"

// sPHENIX SPACAL prototype fiber-core hit process (project spacal_proto3).
// One hit = one fiber within the hit time window. Output per hit: readout channel id, fiber code,
// edep, Birks-quenched edep, and light = sum_steps(Birks * fiber transmission) * light-guide efficiency,
// following PHG4SpacalPrototypeSteppingAction + PHG4FullProjSpacalCellReco + LightCollectionModel.
class solid_spacal_HitProcess : public HitProcess
{
public:

	~solid_spacal_HitProcess(){;}

	// - integrateDgt: returns digitized information integrated over the hit
	map<string, double> integrateDgt(MHit*, int);

	// - multiDgt: returns multiple digitized information / hit
	map< string, vector <int> > multiDgt(MHit*, int);

	// - charge: returns charge/time digitized information / step
	virtual map< int, vector <double> > chargeTime(MHit*, int);

	// - voltage: returns a voltage value for a given time. The input are charge value, time
	virtual double voltage(double, double, double);

	// The pure virtual method processID returns a (new) identifier
	// containing hit sharing information
	vector<identifier> processID(vector<identifier>, G4Step*, detector);

	// creates the HitProcess
	static HitProcess *createHitClass() {return new solid_spacal_HitProcess;}

	// - electronicNoise: returns a vector of hits generated / by electronics.
	vector<MHit*> electronicNoise();

private:
	double par(const string& name);   // gemc parameter (__parameters file); exits if missing
};

#endif
