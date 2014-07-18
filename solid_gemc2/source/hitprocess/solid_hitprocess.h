#ifndef SOLID_HITPROCESS_HH
#define SOLID_HITPROCESS_HH

#include "HitProcess.h"
#include "HitProcess_MapRegister.h"

#include "solidec_hitprocess.h"
#include "solidgem_hitprocess.h"
#include "solidcc_hitprocess.h"
#include "solidmrpc_hitprocess.h"

//   This function allows us to add in our own hit processor for SoLID

void solid_hitprocess( map<string, HitProcess_Factory> &hitMap ){
    hitMap["solidec"]  = &solidec_HitProcess::createHitClass;    
    hitMap["solidgem"] = &solidgem_HitProcess::createHitClass;
    hitMap["solidcc"]  = &solidcc_HitProcess::createHitClass;    
    hitMap["solidmrpc"]= &solidmrpc_HitProcess::createHitClass;        
//     hitMap["solid_gem_trace"]  = &solid_gem_trace_HitProcess::createHitClass;    
    return;
}

#endif//SOLID_HITPROCESS_HH
