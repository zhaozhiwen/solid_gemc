use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_PVDIS_ec_forwardangle';

my $DetectorMother="root";

sub solid_PVDIS_ec_forwardangle
{
make_ec_forwardangle_shower();
make_ec_forwardangle_shield();
make_ec_forwardangle_prescint();
make_ec_forwardangle_support();
}

my $ec_sen="solid_ec";

my $color_abs="0000ff";
my $color_scint="f1ffe1";
my $color_gap="80ff77";
my $color_support="123456";
my $color_other="ff0000";

my $material_abs="G4_Pb";
my $material_scint="SL_ec_ScintillatorB";
my $material_gap="G4_MYLAR";
my $material_support="G4_Al";
my $material_other="G4_AIR";

# config mostly from CaloSim/include/Config.h
# Sampling ratio = 0.253017(EM) 0.285811(MIP) 0.34+-0.04(H)
# my $Nlayer=194;
# my $Thickness_lead = 0.05; #cm
# my $Thickness_scint = 0.15; #cm
# my $Thickness_gap = 0.024; #cm
# my $Thickness_shield = 0.5137*2; #cm, it should be 0.5612cm for X0
# my $Thickness_prescint = 2; #cm 
# my $Thickness_support = 2; #cm
# my $Thickness_preshower=$Thickness_shield+$Thickness_prescint; #3.0274mm
# my $z_shower=350;

#   my $Rmin = 110;
#   my $Rmax = 265;
#   my $Sphi  = 0;
#   my $Dphi  = 360;
  
my $Nlayer		= $parameters{"Nlayer"};
my $Thickness_lead	= $parameters{"Thickness_lead"};
my $Thickness_scint 	= $parameters{"Thickness_scint"};
my $Thickness_gap 	= $parameters{"Thickness_gap"};
my $Thickness_shield 	= $parameters{"Thickness_shield"};
my $Thickness_prescint 	= $parameters{"Thickness_prescint"};
my $Thickness_support 	= $parameters{"Thickness_support"};
my $z_shower 		= $parameters{"z_shower"};
my $Rmin 		= $parameters{"Rmin"};
my $Rmax 		= $parameters{"Rmax"};
my $Sphi 		= $parameters{"Sphi"};
my $Dphi 		= $parameters{"Dphi"};

my $Thickness_layer=$Thickness_lead+$Thickness_scint+$Thickness_gap; #0.224cm
my $Thickness_shower=$Thickness_layer*$Nlayer;  #43.456cm

my $z_support = $z_shower-$Thickness_shower/2-$Thickness_support/2;  #cm
my $z_prescint = $z_support-$Thickness_support/2-$Thickness_prescint/2; #cm 
my $z_shield = $z_prescint-$Thickness_prescint/2-$Thickness_shield/2;  #about 323.4cm

sub make_ec_forwardangle_shower
{   
    my $Dz = $Thickness_shower/2;

    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_shower";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z_shower*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color_other;
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rmin*cm $Rmax*cm $Dz*cm $Sphi*deg $Dphi*deg";
    $detector{"material"}   = "$material_other";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "no";
    $detector{"identifiers"} = "no";
    print_det(\%configuration, \%detector);

    my $Dzlayer = $Thickness_layer/2;      
    
   for(my $i=1; $i<=$Nlayer; $i++)
    {
        my $layerZ = -$Dz+$Thickness_layer*($i-0.5);      

        my %detector=init_det();
        $detector{"name"}        = "$DetectorName\_layer_$i";
        $detector{"mother"}      = "$DetectorName\_shower";
        $detector{"description"} = $detector{"name"};
        $detector{"pos"}        = "0*cm 0*cm $layerZ*cm";
        $detector{"rotation"}   = "0*deg 0*deg 0*deg";
        $detector{"color"}      = "$color_gap";
        $detector{"type"}       = "Tube";
        $detector{"dimensions"} = "$Rmin*cm $Rmax*cm $Dzlayer*cm $Sphi*deg $Dphi*deg";
        $detector{"material"}   = "$material_gap";
        $detector{"mfield"}     = "no";
        $detector{"ncopy"}      = 1;
        $detector{"pMany"}       = 1;
        $detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "no";
	print_det(\%configuration, \%detector);
    }

   for(my $i=1; $i<=$Nlayer; $i++)
    {
	my $leadZ = -$Dzlayer+$Thickness_lead/2;
	my $Dzlead = $Thickness_lead/2;

        my %detector=init_det();
        $detector{"name"}        = "$DetectorName\_lead_$i";
        $detector{"mother"}      = "$DetectorName\_layer_$i";
        $detector{"description"} = $detector{"name"};
        $detector{"pos"}        = "0*cm 0*cm $leadZ*cm";
        $detector{"rotation"}   = "0*deg 0*deg 0*deg";
        $detector{"color"}      = "$color_abs";
        $detector{"type"}       = "Tube";
        $detector{"dimensions"} = "$Rmin*cm $Rmax*cm $Dzlead*cm $Sphi*deg $Dphi*deg";
        $detector{"material"}   = $material_abs;
        $detector{"mfield"}     = "no";
        $detector{"ncopy"}      = 1;
        $detector{"pMany"}       = 1;
        $detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "no";
	print_det(\%configuration, \%detector);
    }

   for(my $i=1; $i<=$Nlayer; $i++)
    {
	my $scintZ = -$Dzlayer+$Thickness_lead+$Thickness_scint/2+$Thickness_gap/2;
	my $Dzscint = $Thickness_scint/2;	

        my %detector=init_det();
        $detector{"name"}        = "$DetectorName\_scint_$i";
        $detector{"mother"}      = "$DetectorName\_layer_$i";
        $detector{"description"} = $detector{"name"};
        $detector{"pos"}        = "0*cm 0*cm $scintZ*cm";
        $detector{"rotation"}   = "0*deg 0*deg 0*deg";
        $detector{"color"}      = "$color_scint";
        $detector{"type"}       = "Tube";
        $detector{"dimensions"} = "$Rmin*cm $Rmax*cm $Dzscint*cm $Sphi*deg $Dphi*deg";
        $detector{"material"}   = $material_scint;
        $detector{"mfield"}     = "no";
        $detector{"ncopy"}      = 1;
        $detector{"pMany"}       = 1;
        $detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = $ec_sen;
	$detector{"hit_type"}    = $ec_sen;
	my $ID = 3100000+$i;
# 	my $ID = 3100001;
	$detector{"identifiers"} = "id manual $ID";
	print_det(\%configuration, \%detector);
    }

}

sub make_ec_forwardangle_shield
{
 my $Dz    = $Thickness_shield/2;

 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_shield";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm $z_shield*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_abs";
 $detector{"type"}       = "Tube";
 $detector{"dimensions"} = "$Rmin*cm $Rmax*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = $material_abs;
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

sub make_ec_forwardangle_prescint
{
 my $Dz    = $Thickness_prescint/2;

 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_scint_0";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm $z_prescint*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_scint"; 
 $detector{"type"}       = "Tube";
 $detector{"dimensions"} = "$Rmin*cm $Rmax*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = $material_scint;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = $ec_sen;
 $detector{"hit_type"}    = $ec_sen;
 my $ID = 3100000;
 $detector{"identifiers"} = "id manual $ID";
 print_det(\%configuration, \%detector);
}

sub make_ec_forwardangle_support
{
 my $Dz    = $Thickness_support/2;

 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_support";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm $z_support*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_support"; 
 $detector{"type"}       = "Tube";
 $detector{"dimensions"} = "$Rmin*cm $Rmax*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = $material_support;
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
