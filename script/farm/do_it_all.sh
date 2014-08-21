#!/bin/csh
uname -a | cat > out.log
more /proc/cpuinfo | cat >> out.log
more /proc/meminfo | cat >> out.log

#use official installation on farm and ifarm
source /home/zwzhao/set_solid 

solid_gemc solid.gcard | cat >> out.log

#need more option for banks more than flux
evio2root -INPUTF=out.evio | cat >> out.log



