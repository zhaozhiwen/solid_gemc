#!/bin/csh
uname -a | cat > out.log
more /etc/redhat-release | cat >> out.log
lscpu | cat >> out.log
more /proc/meminfo | cat >> out.log

#use official installation on farm and ifarm
source /group/solid/solid_svn/set_solid 1.3 

#run simulation
solid_gemc solid.gcard -BEAM_P="e-,11*GeV,0*deg,0*deg" -SPREAD_P="0*GeV,0*deg,0*deg" -BEAM_V="(0,0,-400)cm" -SPREAD_V="(0.21,0)cm" -N=5e6 | cat >> out.log

#convert evio to root
#need more option for banks other than flux
evio2root -INPUTF=out.evio -B="/group/solid/solid_svn/solid_gemc2/geometry/ec_segmented/solid_PVDIS_ec_forwardangle   /group/solid/solid_svn/solid_gemc2/geometry/lgc/lg_cherenkov  /group/solid/solid_svn/solid_gemc2/geometry/gem/solid_PVDIS_gem" | cat >> out.log

root -b -q 'SoLIDFileReduce.C+("PVDIS","out.root")'

mv -f out.root_skim out.root

