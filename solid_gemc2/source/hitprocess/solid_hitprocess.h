#include "HitProcess.h"
#include "HitProcess_MapRegister.h"

#include "solid_ec_hitprocess.h"
// #include "solid_gem_hitprocess.h"
// #include "solid_gem_trace_hitprocess.h"

//   This function allows us to add in our own hit processor for SoLID

void solid_hitprocess( map<string, HitProcess_Factory> &hitMap ){
    hitMap["solid_ec"]  = &solid_ec_HitProcess::createHitClass;    
//     hitMap["solid_gem"]  = &solid_gem_HitProcess::createHitClass;
//     hitMap["solid_gem_trace"]  = &solid_gem_trace_HitProcess::createHitClass;    
    return;
}
