#include "HitProcess.h"
#include "HitProcess_MapRegister.h"

#include "solid_ec_hitprocess.h"
// #include "trace_HitProcess.h"
// #include "sbsgem_HitProcess.h"

//   This function allows us to add in our own hit processor for SoLID


void solid_hitprocess( map<string, HitProcess_Factory> &hitMap ){
    hitMap["solid_ec"]  = &solid_ec_HitProcess::createHitClass;    
//     hitMap["TRACE"]  = &trace_HitProcess::createHitClass;
//     hitMap["SBSGEM"]  = &sbsgem_HitProcess::createHitClass;    
    return;
}
