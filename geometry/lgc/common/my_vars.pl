print "Loading Variables\n";

our $Nsec = 30;  #The number of sectors to make...  note that there is always "space" for 30, but a value of 10 would only make 10 of the 30 sectors.  This option is nice for drawing graphics (like a cross section of the tank, or if you want to display only one pmt array).

our $use_pvdis = 1;  #if 1, use pvdis.  else uses sidis configuration
our $use_CLEO = 1;  #if 1, use cleo field map, if 0 use BaBar.

our $buildTank = 1; #build the tank...  If set to 0, other det components may not work.
our $buildPMTs = 1;  #these are boolians to build the different components of the cherenkov.
our $buildCones = 1;
our $buildM1 = 1;
our $buildM2 = 1;
our $buildM3 = 0;
our $buildSupport = 0;
our $buildBaffle = 0;
our $buildBlinders = 0;

our $D2R = 3.14159265/180.0;

our $detMom = "root";  #This is the mother volume that the geometries are placed in.
# our $detMom = "hall";
our $namePre = "cher_lg_"; #naming convention for light gas cherenkov (so as not to conflict with other subdetector geometry names when we put everything together).

#some variable tank window settings:
our $cleo_bw_hthk = 0.005; #cm
our $cleo_fw_hthk = 0.0025; #cm

#initializing Mirror settings:
our $R;  #For mirror Radius, see buildSPMirror subroutine
our $PosV = vector(0.,0.,0.);  #generic position vector


#initialize PMT settings:
our $ang_xrot = 55.0; #deg  for pmt orientation about x-dir, default is PVDIS for CLEO map
our $ang_yrot = 0.0; #deg  for pmt orientation about y-dir, default is PVDIS for CLEO map
our $ang_zrot = 2.3; #deg  for pmt orientation about z-dir, default is PVDIS for CLEO map
our $pmtN = 3;  #pmt array size
our $pmt232 = 0;  #special option to use the 2x3x2 pmt array.
our $image_x = 0.; #cm  pmt central location
our $image_y = 240.0;
our $image_z = 240.0;
our $PMT_hflngth = 2.54; #cm  for depth of pmt enclosure
our $PMTwindow_hfthk = 0.075; #cm;  for wall thickness of pmt enclosure
our $PMTbox_HL = 0.15; #cm  also for wall thickness of enclosure
our $pmt_x = 2.6; #cm  The actual length/width of the PMT
our $pmt_shell = 0.0001; #cm  This is how thick the PMT is (thin to minimize secondary reactions in PMT material);
our $z_w_half = 15.0;

#Vectors for PMT and Winston cone placement:
our $Pos_im_Obs_V = vector($image_x, $image_y, $image_z);  #position of PMT center
#our $Pos_obs_V = vector(0.0, sin($ang_xrot*$D2R)*$pmt_x +$image_y, $image_z - cos($ang_xrot*$D2R)*$pmt_x);  #position of PMT center offset by box thickness;
our $Pos_obsWin_V = vector(0.0, 0.0, -$PMTwindow_hfthk);  #position of PMT face from pmt window geo center
our $temp_off_V = vector(0.0,0.0,0.0);  #temporary offset vector (for internal manipulations);


#initialize Winston Cone settings:
our $rmin_w_end = 21.0; #cm   Winston cone inner "opening"
our $rmax_w_end = 21.5; #cm   Winston cone outer "opening"

#PMT shielding
our $pmt_shield_hlength = 10.0; #cm  total length of the PMT sheilding

#Extended mirror settings

#We are assuming a two mirror system for now (all default numbers are for pvdis):

#Mirror 1
our $Z_M1 = 275.0; #cm  Mirror z-cord w.r.t origin
our $T_M1 = 3.175; #mm  Mirror thickness
our $cr_ang1 = 25.1;  #deg  Mirror central angle;
our $ztarg_cent1 = 10.0; #Nominal target center for mirror 1
our $Angle_in1 = 19.0; #deg  Defines inner radius of mirror array
our $Angle_out1 = 27.5;  #deg  Defines outer radius of mirror array
our $mirrAng1 = 0.0;  #deg  For rotation of mirror
our $zMirrRotPoint1 = $Z_M1 - 40.0; #point at which you wish to rotate mirror about in Z;

#Mirror 2
our $Z_M2 = 292.0; #cm  Mirror z-cord w.r.t origin
our $T_M2 = 3.175; #mm  Mirror thickness
our $cr_ang2 = 32.6;  #deg  Mirror central angle;
our $ztarg_cent2 = 10.0; #Nominal target center for mirror 1
our $Angle_in2 = 27.5; #deg  Defines inner radius of mirror array
our $Angle_out2 = 38.0;  #deg  Defines outer radius of mirror array
our $mirrAng2 = 0.0;  #deg  For rotation of mirror
our $zMirrRotPoint2 = $Z_M2 - 30.0; #point at which you wish to rotate mirror about in Z;

#Mirror 3
our $Z_M3 = 240.0; #cm  Mirror z-cord w.r.t origin
our $T_M3 = 3.175; #mm  Mirror thickness
our $cr_ang3 = 8.0;  #deg  Mirror central angle;
our $ztarg_cent3 = -350.0; #Nominal target center for mirror 1
our $Angle_in3 = 7.0; #deg  Defines inner radius of mirror array
our $Angle_out3 = 11.0;  #deg  Defines outer radius of mirror array
our $mirrAng3 = 0.0;  #deg  For rotation of mirror
our $zMirrRotPoint2 = $Z_M3 - 30.0; #point at which you wish to rotate mirror about in Z;

