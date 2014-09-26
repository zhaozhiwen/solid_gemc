#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_gem';

my $DetectorMother="root";

sub solid_SIDIS_gem
{
make_gem();
}



# C GEM chamber
# HOD1SLATS       6
# HOD1MEDIUM    658
# HOD1MOTHER  'HALL' 
# HOD1IDTYPE     41
# HOD1GATE       50.
# HOD1THRES       0
# HOD1SHAP    'TUBE' 'TUBE' 'TUBE' 'TUBE' 'TUBE' 'TUBE'
# HOD1ROT       0      0      0     0       0     0
# HOD1SIZE1     50.00  80.    0.40
# HOD1SIZE2     28.0   93.    0.40
# HOD1SIZE3     31.5   107.5  0.40
# HOD1SIZE4     39.00  135.   0.40
# HOD1SIZE5     50.00  98.   0.40
# HOD1SIZE6     64.00  122.   0.40
# HOD1TYPE        1  2  3   4   5  6  
# HOD1POSX        6*0.
# HOD1POSY        6*0.
# HOD1POSZ        175. 200.  231.  282.  355.   442.

# simple GEM with only gas
#  my $material="GEMgas";
# sub make_gem
# {
#  my $Nplate  = 6;
#  # BaBar config
# #  my @PlateZ  = (175.-350, 200.-350,  231.-350,  282.-350,  355.-350,   442.-350,);
# #  my @Rin  = (50,28,31.5,39,50,64);
# #  my @Rout = (80,93,107.5,135,98,122);
# # CLEO config
#  my @PlateZ  = (-175, -150,  -119,  -68,  5, 92);
#  my @Rin  = (45,26,30,37,46,58);
#  my @Rout = (80,93,107.5,135,98,122);
# 
#  my $Dz   = 0.4;
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
#     $detector{"ncopy"}      = $n;
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
 my $Nplate  = 6;
#  my @PlateZ  = (175.-350, 200.-350,  231.-350,  282.-350,  355.-350,   442.-350,);
 my @PlateZ  = (-175,-150,-119,-68,5,92);

#  my @Rin  = (50,28,31.5,39,50,64);
#  my @Rout = (80,93,107.5,135,98,122);
# total thickness
#  my $Dz   = 15.955/2;
# my $Dz   = 9.781/2; 
#  my $material="DCgas";
#  my $color="44ee11";

#cover 40cm long full target with center at 350cm from 21 to 36 degree
# SIDIS 40cm long target with center at -350cm
# SIDIS angle 7.5-14.85-24 degree
# JPsi 15cm long target with center at -300cm tentatively
# JPsi angle 8- 16.28-28 degree
 my @Rin = (36,21,25,32,42,55);
 my @Rout = (87,98,112,135,100,123);
 my $Dz   = 0.9781/2; 
 my $color="44ee11";

 my $Nlayer = 23;
 my @layer_thickness = (0.012,0.0003,0.012,0.005,0.0005,0.3,0.0005,0.005,0.0005,0.2,0.0005,0.005,0.0005,0.2,0.0005,0.005,0.0005,0.2,0.001,0.005,0.012,0.0003,0.012); # unit in mm
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
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "no";	
	if ($i==6){
	  $detector{"sensitivity"} = "flux";
	  $detector{"hit_type"}    = "flux";
	  my $id=1000000+$n*100000+20000;
	  $detector{"identifiers"} = "id manual $id";
	}
	if ($i==10){
	  $detector{"sensitivity"} = "flux";
	  $detector{"hit_type"}    = "flux";
	  my $id=1000000+$n*100000+30000;
	  $detector{"identifiers"} = "id manual $id";
	}
	print_det(\%configuration, \%detector);
    }
 }
}

#sub solid_SIDIS_gem
#{
#make_gem();
#}


