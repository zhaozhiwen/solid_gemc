#!/bin/csh
uname -a | cat > out.log
more /etc/redhat-release | cat >> out.log
lscpu | cat >> out.log
more /proc/meminfo | cat >> out.log

#use official installation on farm and ifarm
source /home/zwzhao/set_solid_1.3_mine

#run simulation
solid_gemc solid.gcard -BEAM_P="e-,11*GeV,0*deg,0*deg" -SPREAD_P="0*GeV,0*deg,0*deg" -BEAM_V="(0,0,-400)cm" -SPREAD_V="(0.21,0)cm" -N=5e6 | cat >> out.log

#convert evio to root
#need more option for banks other than flux
evio2root -INPUTF=out.evio -B="/home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/ec/solid_SIDIS_ec_forwardangle /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/ec/solid_SIDIS_ec_largeangle /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/hgc/solid_SIDIS_hgc /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/lgc/lg_cherenkov /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/hgc/solid_SIDIS_hgc /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/gem/solid_SIDIS_gem /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/mrpc/solid_SIDIS_mrpc_forwardangle /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/spd/solid_SIDIS_spd_forwardangle /home/zwzhao/solid/solid_svn/solid/solid_gemc2/geometry/spd/solid_SIDIS_spd_largeangle" | cat >> out.log

#root -b -q 'SoLIDFileReduce.C+("SIDIS","out.root")'

#mv -f out.root_skim out.root


