use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_gem';

my $DetectorMother="root";

sub solid_SIDIS_gem_geometry
{
make_gem();
}

my $Nplate	= $parameters{"Nplate"};
my $PlateZ1	= $parameters{"PlateZ1"};
my $PlateZ2	= $parameters{"PlateZ2"};
my $PlateZ3	= $parameters{"PlateZ3"};
my $PlateZ4	= $parameters{"PlateZ4"};
my $PlateZ5	= $parameters{"PlateZ5"};
my $PlateZ6	= $parameters{"PlateZ6"};
my $Rin1	= $parameters{"Rin1"};
my $Rin2	= $parameters{"Rin2"};
my $Rin3	= $parameters{"Rin3"};
my $Rin4	= $parameters{"Rin4"};
my $Rin5	= $parameters{"Rin5"};
my $Rin6	= $parameters{"Rin6"};
my $Rout1	= $parameters{"Rout1"};
my $Rout2	= $parameters{"Rout2"};
my $Rout3	= $parameters{"Rout3"};
my $Rout4	= $parameters{"Rout4"};
my $Rout5	= $parameters{"Rout5"};
my $Rout6	= $parameters{"Rout6"};

my @PlateZ = ($PlateZ1,$PlateZ2,$PlateZ3,$PlateZ4,$PlateZ5,$PlateZ6);
my @Rin    = ($Rin1,$Rin2,$Rin3,$Rin4,$Rin5,$Rin6);
my @Rout   = ($Rout1,$Rout2,$Rout3,$Rout4,$Rout5,$Rout6);
 
my @offrot = (0,0,0,0,0,0);  # angular offsets in degrees (w.r.t. center on 12*$n for $n-th sector) 
my $angle_start=-6;
my $angle_width=12;
 
my $hittype = "solid_gem";
# my $hittype = "flux";

sub make_gem
{
# == older version ====================================
#  my $Dz   = 0.48;
#  my $material="DCgas";
#  my $color="44ee11";
#  my $Dz   = 15.955/2;

# ==== old copy from SBS code ================================
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
# 
# my $Dz   = 9.781/2; # unit in mm 
#  my $Nlayer = 23;
#  my @layer_thickness = (0.12,0.003,0.12,0.05,0.005,3,0.005,0.05,0.005,2,0.005,0.05,0.005,2,0.005,0.05,0.005,2,0.01,0.05,0.12,0.003,0.12);   # unit in mm
#  my @material = ("SL_gem_NEMAG10","SL_gem_NOMEX","SL_gem_NEMAG10","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","SL_gem_NEMAG10","SL_gem_NOMEX","SL_gem_NEMAG10");
#  my @sens = ("no","no","no","no","$hittype","$hittype","$hittype","no","no","no","no","no","no","no","no","no","no","no","$hittype","no","no","no","no");
#  my @hitt = ("no","no","no","no","$hittype","$hittype","$hittype","no","no","no","no","no","no","no","no","no","no","no","$hittype","no","no","no","no");
#  my $color_NEMAG10 = "00ff00";
#  my $color_NOMEX = "ffse14";
#  my $color_Copper = "ffe731";
#  my $color_Kapton = "1a4fff";
#  my $color_Air = "ff33fc";
#  my @color = ($color_NEMAG10,$color_NOMEX,$color_NEMAG10,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_Copper,$color_Air,$color_Copper,$color_Kapton,$color_NEMAG10,$color_NOMEX,$color_NEMAG10);
# ======================================

# =====SoLID GEM =================================
# refer  to https://hallaweb.jlab.org/wiki/index.php/Solid_Tracking#GEM_module.27s_geometry_and_material

my $Dz   = 15.525/2;  #unit in mm
my $Nlayer = 24;
my @layer_thickness =
(0.005,0.02,3,0.05,0.005,3,0.005,0.05,0.005,2,0.005,0.05,0.005,2,0.005,0.05,0.005,2,0.01,0.05,0.18,3,0.02,0.005);  # unit in mm
my @material =
("G4_Al","SL_gem_mylar","SL_gem_GEMgas","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","G4_Cu","SL_gem_GEMgas","G4_Cu","SL_gem_Kapton","SL_gem_NEMAG10","SL_gem_GEMgas","SL_gem_mylar","G4_Al");
my $color_NEMAG10 = "00ffdd";
my $color_Al = "00ff00";
my $color_mylar = "ffse14";
my $color_Copper = "ffe731";
my $color_Kapton = "1a4fff";
my $color_gas = "ff33fc"; 
my @color = ($color_Al,$color_mylar,$color_gas,$color_Kapton,$color_Copper,$color_gas,$color_Copper,$color_Kapton,$color_Copper,$color_gas,$color_Copper,$color_Kapton,$color_Copper,$color_gas,$color_Copper,$color_Kapton,$color_Copper,$color_gas,$color_Copper,$color_Kapton,$color_NEMAG10,$color_gas,$color_mylar,$color_Al);

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
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*mm 0*deg 360*deg";
    $detector{"material"}   = "G4_AIR";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 0;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "no";
    $detector{"identifiers"} = "no";
    print_det(\%configuration, \%detector);

    for( my $sec = 1; $sec <= 30; $sec++ ){
      my $thisrot = -($sec-1)*12.0 + $offrot[$n-1];
    
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
	    $detector{"name"}        = "$DetectorName\_$n\_$sec\_$i";
	    $detector{"mother"}      = "$DetectorName\_$n";
	    $detector{"description"} = $detector{"name"};
	    $detector{"pos"}        = "0*cm 0*cm $layerZ*mm";
	    $detector{"rotation"}   = "0*deg 0*deg $thisrot*deg";
	    $detector{"color"}      = "$color[$i-1]";
	    $detector{"type"}       = "Tube";
	    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $DlayerZ*mm $angle_start*deg $angle_width*deg";
	    $detector{"material"}   = "$material[$i-1]";
	    $detector{"mfield"}     = "no";
	    $detector{"ncopy"}      = 1;
	    $detector{"pMany"}       = 1;
	    $detector{"exist"}       = 1;
	    $detector{"style"}       = 1;
	    $detector{"sensitivity"} = "$hittype";
	    $detector{"hit_type"}    = "$hittype";
	    my $id=1000000+$n*100000+$sec*1000+$i;
	    $detector{"identifiers"} = "id manual $id";
	    print_det(\%configuration, \%detector);
	}
    }
 }
}
