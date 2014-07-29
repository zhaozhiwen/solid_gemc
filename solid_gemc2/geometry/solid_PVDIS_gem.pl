#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_PVDIS_gem';

my $DetectorMother="root";

sub solid_PVDIS_gem
{
make_gem();
}

# C  ================ Collimator wheel 5  =================================
# RMATR48  90.0    -0.90  90.    89.10  0.  0.
# C      ----  absorber wheel ----
# PARVOL114 'WL05' 215 'SOLE'  0.  0.    152.0  48  'TUBE' 3     28.9   140.0  4.5
# C      ----  detector wheel ----
# PARVOL115 'WD05' 215 'SOLE'  0.  0.    157.5   0  'TUBE' 3     28.9   140.0  0.5
# C      ---- Internal ring ----
# PARVOL116 'WA05' 200 'WL05'  0.  0.     0.     0  'TUBE' 3     28.9    49.2  4.5
# C      ---- External ring ----
# PARVOL117 'WB05' 200 'WL05'  0.  0.     0.     0  'TUBE' 3    112.8   140.0  4.5
# PARVOL115 'WD05' 215 'SOLE'  0.  0.    157.5   0  'TUBE' 3     28.9   140.0  0.5
# C  -------------- Hodoscope 5 --------
# PARVOL139 'WC05' 209 'WD05'  0.  0.     -0.4999   0  'TUBE' 3   48.70 113.30  0.0001
# VOLPOS160 'WC05'     'WD05'  0.  0.      0.4999   0  
# HOD5SLATS       1
# HOD5MEDIUM   636
# HOD5MOTHER  'WD05' 
# HOD5IDTYPE     41
# HOD5GATE       50.
# HOD5THRES       0
# C 
# HOD5SHAP    'TUBE'
# HOD5SIZE1     48.70 113.30   0.48000
# HOD5TYPE        1
# HOD5POSX        0.
# HOD5POSY        0.
# HOD5POSZ        0.
# C  ================ Collimator wheel 6  =================================
# RMATR49  90.0     0.10  90.    90.10  0.  0.
# C      ----  absorber wheel ----
# PARVOL140 'WL06' 215 'SOLE'  0.  0.    180.0  49  'TUBE' 3     33.8   140.0  4.5
# C      ----  detector wheel ----
# PARVOL141 'WD06' 215 'SOLE'  0.  0.    185.5   0  'TUBE' 3     33.8   140.0  0.5
# C      ---- Internal ring ----
# PARVOL142 'WA06' 200 'WL06'  0.  0.     0.     0  'TUBE' 3     33.8    60.4  4.5
# C      ---- External ring ----
# PARVOL143 'WB06' 200 'WL06'  0.  0.     0.     0  'TUBE' 3    132.1   140.0  4.5
# C  -------------- Hodoscope 6 --------
# PARVOL141 'WD06' 215 'SOLE'  0.  0.    185.5   0  'TUBE' 3     33.8   140.0  0.5
# PARVOL165 'WC06' 209 'WD06'  0.  0.     -0.4999   0  'TUBE' 3   59.90 132.60  0.0001
# VOLPOS190 'WC06'     'WD06'  0.  0.      0.4999   0  
# HOD6SLATS       1
# HOD6MEDIUM   636
# HOD6MOTHER  'WD06' 
# HOD6IDTYPE     41
# HOD6GATE       50.
# HOD6THRES       0
# C 
# HOD6SHAP    'TUBE'
# HOD6SIZE1     59.90 132.60   0.48000
# HOD6TYPE        1
# HOD6POSX        0.
# HOD6POSY        0.
# HOD6POSZ        0.
# C  -------------- Hodoscope 7 --------
# HOD7SLATS       1
# HOD7MEDIUM   636
# HOD7MOTHER  'SOLE' 
# HOD7IDTYPE     41
# HOD7GATE       50.
# HOD7THRES       0
# C 
# HOD7SHAP    'TUBE'
# HOD7SIZE1     102. 223.   0.48000
# HOD7TYPE        1
# HOD7POSX        0.
# HOD7POSY        0.
# HOD7POSZ      297.
# C  -------------- Hodoscope 8 --------
# HOD8SLATS       1
# HOD8MEDIUM   636
# HOD8MOTHER  'SOLE' 
# HOD8IDTYPE     41
# HOD8GATE       50.
# HOD8THRES       0
# C 
# HOD8SHAP    'TUBE'
# HOD8SIZE1     103. 226.   0.48000
# HOD8TYPE        1
# HOD8POSX        0.
# HOD8POSY        0.
# HOD8POSZ      306.

# on p56 of pac34 proposal, the z location are 155,185,295,310cm, but it seems Eugene later tweaked a bit togther with baffle. refer to http://hallaweb.jlab.org/12GeV/SoLID/download/sim/geant3/solid_comgeant_pvdis/pvdis_02_01_p_14_01/fort.22

# simple GEM with only gas
# sub make_gem
# {
#  my $Nplate  = 4;
# # my @PlateZ  = (155,185,295,310);  # as on p56 of pac34 proposal
# # my @PlateZ  = (157.5,185.5,297,306); # as in Eugen's code
# #  my @PlateZ  = (157.5,185.5,306,321);  # change for last two planes further back as Cherenkov needs 10cm more
# #  my @Rin  = (55,65,105,115);
# #  my @Rout = (115,140,200,215);
#  my @PlateZ = (157.5,185.5,306,315);
# #cover target center at 10cm from 21 to 36 degree
# #  my @Rin = (56,67,113,117);
# #  my @Rout = (108,129,215,222);
# #  my $Dz   = 0.5;
# #cover 40cm long full target with center at 10cm from 21 to 36 degree
#  my @Rin = (48,59,105,109);
#  my @Rout = (122,143,230,237);
#  my $Dz   = 0.4;
#  my $material="GEMgas"; 
#  my $color="44ee11";
# 
#  for(my $n=1; $n<=$Nplate; $n++)
#  {
#     my $n_c     = cnumber($n-1, 1);
#     $detector{"name"}        = "$DetectorName\_$n_c";
#     $detector{"mother"}      = "$DetectorMother" ;
#     $detector{"description"} = $detector{"name"};
#     $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
#     $detector{"rotation"}   = "0*deg 0*deg 0*deg";
#     $detector{"color"}      = "$color";
#     $detector{"type"}       = "Tube";
#     $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
#     $detector{"material"}   = "$material";
#     $detector{"mfield"}     = "no";
#     $detector{"ncopy"}      = 1;
#     $detector{"pMany"}       = 1;
#     $detector{"exist"}       = 1;
#     $detector{"visible"}     = 1;
#     $detector{"style"}       = 1;
#     $detector{"sensitivity"} = "flux";
#     $detector{"hit_type"}    = "flux";
#     my $id=1000000+$n*100000;
#     $detector{"identifiers"} = "id manual $id";
#     print_det(\%detector, $file);
#  }
# }
# make_gem();

#  * Describe the single GEM Chamber module (similar to COMPASS)
#  * see: "Construction Of GEM Detectors for the COMPASS experiment", CERN Tech Note TA1/00-03
#  *
#  * Consist of 15 layers of different size, material and position
#  *
#  *
#  * HoneyComb
#  *  0   NEMA G10 120 um
#  *  1   NOMEX    3 mm  #should be 3um?
#  *  2   NEMA G10 120 um
#  * Drift Cathode
#  *  3   Copper 5 um    #should exchange with 4?
#  *  4   Kapton 50 um   #should exchange with 3?
#  *  5   Air 3 mm
#  * GEM0
#  *  6   Copper 5 um
#  *  7   Kapton 50 um
#  *  8   Copper 5 um
#  *  9   Air 2 mm
#  * GEM1
#  * 10   Copper 5 um
#  * 11   Kapton 50 um
#  * 12   Copper 5 um
#  * 13   Air 2 mm
#  * GEM2
#  * 14   Copper 5 um
#  * 15   Kapton 50 um
#  * 16   Copper 5 um
#  * 17   Air 2 mm 
#  * Readout Board
#  * 18   Copper 10 um
#  * 19   Kapton 50 um
#  * 20   G10 120 um + 60 um (assume 60 um glue as G10)    # not implmented yet
#  * Honeycomb
#  * 21   NEMA G10 120 um
#  * 22   NOMEX    3 mm       #should be 3um?
#  * 23   NEMA G10 120 um

sub make_gem
{
 my $Nplate  = 5;
# my @PlateZ  = (155,185,295,310);  # as on p56 of pac34 proposal
# my @PlateZ  = (157.5,185.5,297,306); # as in Eugen's code
#  my @PlateZ  = (157.5,185.5,306,321);  # change for last two planes further back as Cherenkov needs 10cm more
#  my @Rin  = (55,65,105,115);
#  my @Rout = (115,140,200,215);
#  my @PlateZ = (157.5,185.5,306,315);
 my @PlateZ = (157.5,185.5,190,306,315);
#cover target center at 10cm from 21 to 36 degree
#  my @Rin = (56,67,113,117);
#  my @Rout = (108,129,215,222);
#  my $Dz   = 0.5;
#cover 40cm long full target with center at 10cm from 21 to 36 degree
#  my @Rin = (48,59,105,109);
#  my @Rout = (122,143,230,237);
 my @Rin = (48,59,65,105,109);
 my @Rout = (122,143,143,230,237);
 my $Dz   = 0.9781/2; 
 my $color="44ee11";

 my $Nlayer = 23;
 my @layer_thickness = (0.012,0.0003,0.012,0.005,0.0005,0.3,0.0005,0.005,0.0005,0.2,0.0005,0.005,0.0005,0.2,0.0005,0.005,0.0005,0.2,0.001,0.005,0.012,0.0003,0.012);
#  my @material = ("SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum","SL_Vacuum");
 my @material = ("SL_NEMAG10","SL_NOMEX","SL_NEMAG10","SL_Kapton","G4_Cu","SL_GEMgas","G4_Cu","SL_Kapton","G4_Cu","SL_GEMgas","G4_Cu","SL_Kapton","G4_Cu","SL_GEMgas","G4_Cu","SL_Kapton","G4_Cu","SL_GEMgas","G4_Cu","SL_Kapton","SL_NEMAG10","SL_NOMEX","SL_NEMAG10");
#  my $color_NEMAG10 = "00ff00";
#  my $color_NOMEX = "ffse14";
#  my $color_Copper = "ffe731";
#  my $color_Kapton = "1a4fff";
#  my $color_Air = "ff33fc";
#  my @color = ($color_NEMAG10,$color_NOMEX,$color_NEMAG10,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_NEMAG10,$color_NOMEX,$color_NEMAG10);
#  my @color =  ("44ee11","44ee23","45ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11","44ee11");

 for(my $n=1; $n<=$Nplate; $n++)
 {
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$n";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "111111";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "SL_Vacuum";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 0;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "no";
    $detector{"identifiers"} = "no";
    print_det(\%configuration, \%detector);

    for(my $i=1; $i<=$Nlayer; $i++)
    {
	my $layerZ = -$Dz;
	for(my $k=1; $k<=$i-1; $k++)
	{	
	   $layerZ = $layerZ+$layer_thickness[$k-1];
	}
	$layerZ = $layerZ+$layer_thickness[$i-1]/2;
	
	my $DlayerZ=$layer_thickness[$i-1]/2;

	my %detector=init_det();
	$detector{"name"}        = "$DetectorName\_$n\_$i";
	$detector{"mother"}      = "$DetectorName\_$n";
	$detector{"description"} = $detector{"name"};
	$detector{"pos"}        = "0*cm 0*cm $layerZ*cm";
	$detector{"rotation"}   = "0*deg 0*deg 0*deg";
	$detector{"color"}      = "$color";
	$detector{"type"}       = "Tube";
	$detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $DlayerZ*cm 0*deg 360*deg";
	$detector{"material"}   = "$material[$i-1]";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	if ($i==6 || $i==10){
	  $detector{"sensitivity"} = "flux";
	  $detector{"hit_type"}    = "flux";
	  my $id=1000000+$n*100000;
	  $detector{"identifiers"} = "id manual $id";
	}
	else{
	  $detector{"sensitivity"} = "no";
	  $detector{"hit_type"}    = "no";
	  $detector{"identifiers"} = "no";
	}
	print_det(\%configuration, \%detector);
    }
 }
}
