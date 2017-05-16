#!/bin/csh
uname -a | cat > out.log
more /etc/redhat-release | cat >> out.log
lscpu | cat >> out.log
more /proc/meminfo | cat >> out.log

#use official installation on farm and ifarm
setenv LD_LIBRARY_PATH /group/solid/solid_svn/evgen/cteq-pdf-1.0.4/lib
setenv LIBRARY_PATH /group/solid/solid_svn/evgen/cteq-pdf-1.0.4/lib
source /group/solid/solid_svn/set_solid 1.3

#run generator
/group/solid/solid_svn/evgen/eicRate_20101102/eicRate -i input.dat -o gen.root -n 1e4 -m 20 | cat >> out.log

#run simulation
solid_gemc solid.gcard -INPUT_GEN_FILE="LUND,gen.lund" -N=1e4 | cat >> out.log

#convert evio to root
#need more option for banks other than flux
/home/zwzhao/banks/1.2/bin/evio2root -INPUTF=out.evio -B="/group/solid/solid_svn/solid_gemc2/geometry/ec_segmented/solid_PVDIS_ec_forwardangle   /group/solid/solid_svn/solid_gemc2/geometry/lgc/lg_cherenkov  /group/solid/solid_svn/solid_gemc2/geometry/gem/solid_PVDIS_gem" | cat >> out.log



