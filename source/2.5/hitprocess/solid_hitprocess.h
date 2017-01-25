#ifndef SOLID_HITPROCESS_HH
#define SOLID_HITPROCESS_HH 1

#include "HitProcess.h"
#include "HitProcess_MapRegister.h"

#include "solid_ec_hitprocess.h"
// #include "solid_gem_hitprocess.h"
// #include "solid_hgc_hitprocess.h"
// #include "solid_lgc_hitprocess.h"
// #include "solid_spd_hitprocess.h"
// #include "solid_mrpc_hitprocess.h"

//   This function allows us to add in our own hit processor for SoLID

void solid_hitprocess( map<string, HitProcess_Factory> &hitMap ){	
    hitMap["solid_ec"]  = &solid_ec_HitProcess::createHitClass;    
//     hitMap["solid_gem"] = &solid_gem_HitProcess::createHitClass;
//     hitMap["solid_hgc"]  = &solid_hgc_HitProcess::createHitClass;    
//     hitMap["solid_lgc"]= &solid_lgc_HitProcess::createHitClass;        
//     hitMap["solid_spd"]= &solid_spd_HitProcess::createHitClass;            
//     hitMap["solid_mrpc"]= &solid_mrpc_HitProcess::createHitClass;        
    return;
}

#endif//SOLID_HITPROCESS_HH
