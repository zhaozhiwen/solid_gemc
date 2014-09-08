#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_PVDIS_cherenkov';

my $DetectorMother="root";

sub solid_PVDIS_cherenkov
{
make_backchamber();
make_backchamber_window_front();
make_backchamber_window_back();
# make_detector_lightout();
}

# C  ==== Gas Cherenkov definitions
# PARVOL170 'CERV' 840 'SOLE'  0.  0.  200.0   50  'PCON' 15      .0   360.0  4.
#          -0.04 61.0 142.0    24.0  70.3 162.0    24.0  70.3 260.0    90.1  96.0 260.0  
# C  ============== Windows ================== 
# PARVOL171 'CEW1' 209 'CERV'  0.  0. -0.02     0  'TUBE' 3  61.1 141.9 0.02  
# PARVOL172 'CEW2' 209 'CERV'  0.  0. 90.05     0  'TUBE' 3  96.1 260.0 0.05 
# C  ============== Volume to be divided =====
# PARVOL173 'CERD' 840 'CERV'  0.  0. 57.0      0  'CONE' 5  33.0  70.3 260.0  96.0 260.0
# C
# C  ============== Divide the barrel ========
# PARVOL174 'CERS'  840 'CERD'  15  0.  0.  2

# comgeant use C4F10

my $material_gas="SL_CCGas"; # currently CF gas used for clas12

sub make_backchamber
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_backchamber";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Polycone";
 $detector{"dimensions"}  = "0*deg 360*deg 4*counts 65*cm 67*cm 67*cm 85*cm 144*cm 155*cm 265*cm 265*cm 194*cm 209.01*cm 209.01*cm 301*cm";
 $detector{"material"}    = $material_gas;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}

sub make_backchamber_window_front
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_backchamber_window_front";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 194.0025*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "65.1*cm 143.9*cm 0.0025*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_POLYVINYL_CHLORIDE"; #should be POLYVINYL fluride 1.45g/cm3
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}


sub make_backchamber_window_back
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_backchamber_window_back";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 300.995*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "85.1*cm 264.9*cm 0.005*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_POLYVINYL_CHLORIDE"; #should be POLYVINYL fluride 1.45g/cm3
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}


# For PVDIS, the location of the center of the PMT array is
# z = 240 cm, r = 240 cm;
# The tilting angle compared to the z axis is 52 degrees.
# For reminder, the size of the PMT is 3 x 3 PMTs, i.e. 15.6 x 15.6 cm.

sub make_detector_lightout
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_lightout";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 240*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 240-15.6/2.*sin(38./180.*3.1415926);
 my $Rmax1 = $Rmin1+0.1;
 my $Rmin2 = 240+15.6/2.*sin(38./180.*3.1415926);
 my $Rmax2 = $Rmin2+0.1;
 my $Dz    = 15.6/2.*cos(38./180.*3.1415926);
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 2100000";
 print_det(\%configuration, \%detector);
}


# C  ============== Mirrors definitions ========
# C    f=164.7
# RMATR51    142.6    0.   90.  90.     52.6       0.
# PARVOL175 'CHM1'  860 'CERS'    115.0   0.0 -159.0  -1051  'ELLI'  8  221.5  222.0   33. 70.  155. 205.  0.757 0.757
# PARVOL176 'CHM2'  860 'CERS'      0.0   0.0  -32.7      0  'TUBS'  5  167.0  237.0  0.3  -12.0  12.0 
