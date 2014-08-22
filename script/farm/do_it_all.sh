#!/bin/csh
uname -a | cat > out.log
more /etc/redhat-release | cat >> out.log
more /proc/cpuinfo | cat >> out.log
more /proc/meminfo | cat >> out.log

#use official installation on farm and ifarm
source /home/zwzhao/set_solid 

#run simulation
solid_gemc solid.gcard | cat >> out.log

#convert evio to root
#need more option for banks other than flux
evio2root -INPUTF=out.evio | cat >> out.log



