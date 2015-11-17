// G4 headers
#include "G4UnitsTable.hh"
#include "G4Poisson.hh"
#include "Randomize.hh"

// gemc headers
#include "solid_lgc_hitprocess.h"

map<string, double> solid_lgc_HitProcess :: integrateDgt(MHit* aHit, int hitn)
{
	map<string, double> dgtz;	
	vector<identifier> identity = aHit->GetId();

	trueInfos tInfos(aHit);

	int id = identity[0].id;
	
	dgtz["hitn"] = hitn;
	dgtz["id"]  =  id;
	
	dgtz["pid"]     = (double) aHit->GetPID();
	dgtz["mpid"]    = (double) aHit->GetmPID();
	dgtz["tid"]     = (double) aHit->GetTId();
	dgtz["mtid"]    = (double) aHit->GetmTrackId();
	dgtz["otid"]    = (double) aHit->GetoTrackId();
	dgtz["trackE"]  = aHit->GetE();
	dgtz["totEdep"] = tInfos.eTot;
	dgtz["avg_x"]   = tInfos.x;
	dgtz["avg_y"]   = tInfos.y;
	dgtz["avg_z"]   = tInfos.z;
	dgtz["avg_lx"]  = tInfos.lx;
	dgtz["avg_ly"]  = tInfos.ly;
	dgtz["avg_lz"]  = tInfos.lz;
	dgtz["avg_t"]   = tInfos.time;
	dgtz["px"]      = aHit->GetMom().getX();
	dgtz["py"]      = aHit->GetMom().getY();
	dgtz["pz"]      = aHit->GetMom().getZ();
	dgtz["vx"]      = aHit->GetVert().getX();
	dgtz["vy"]      = aHit->GetVert().getY();
	dgtz["vz"]      = aHit->GetVert().getZ();
	dgtz["mvx"]     = aHit->GetmVert().getX();
	dgtz["mvy"]     = aHit->GetmVert().getY();
	dgtz["mvz"]     = aHit->GetmVert().getZ();		
		
	return dgtz;
}

vector<identifier>  solid_lgc_HitProcess :: processID(vector<identifier> id, G4Step* aStep, detector Detector)
{
	id[id.size()-1].id_sharing = 1;
	return id;
}


map< string, vector <int> >  solid_lgc_HitProcess :: multiDgt(MHit* aHit, int hitn)
{
	map< string, vector <int> > MH;
	
	return MH;
}
