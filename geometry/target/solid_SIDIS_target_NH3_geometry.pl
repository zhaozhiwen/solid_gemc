use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_target_NH3';

my $DetectorMother="root";

sub solid_SIDIS_target_NH3
{
make_target_field();
make_scattering_chamber();
make_scattering_windows();
make_target();
}

sub make_target_field
{
 my $NUM  = 1;
 my @z    = (-350);
#  my @Rin  = (0);
#  my @Rout = (65);
#  my @Dz   = (65);
#   my @Dx = (37);
#   my @Dy = (37);
#   my @Dz = (25);
 my @name = ("field"); 
 my @mother = ("$DetectorMother");
 my @mat  = ("G4_AIR");
 
 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
     my %detector=init_det(); 
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "ff0000";
#     $detector{"type"}       = "Box";
#     $detector{"dimensions"} = "$Dx[$n-1]*cm $Dy[$n-1]*cm $Dz[$n-1]*cm";    
#     $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"type"}       = "Polycone";
    $detector{"dimensions"} = "0*deg 360*deg 4*counts 0*cm 0*cm 1.1*cm 3*cm 65*cm 65*cm 65*cm 65*cm -65*cm 25*cm 25*cm 65*cm";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "solenoid_ptarget";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 0;  # style 0 shows only borders
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "no";
    $detector{"identifiers"} = "no";
    print_det(\%configuration, \%detector);
 }
}

#1. Scattering chamber : cylinder of  74cm(height) with inner diameter of 45cm and thickness of 2.5cm made of Aluminum.

sub make_scattering_chamber
{
 my $NUM  = 2;
 my @Rin  = (0,0);
 my @Rout = (25,22.5);
 my @Dz   = (37,37); 
 my @name = ("SC_out","SC_in");
 my @mother = ("$DetectorName\_field","$DetectorName\_SC_out"); 
 my @mat  = ("G4_Al","G4_Galactic");
 my @rot  = (90,0);
 my @color = ("FF6600","FFFFFF");
 
 for(my $n=1; $n<=$NUM; $n++)
 {
     my %detector=init_det(); 
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "$rot[$n-1]*deg 0*deg 0*deg";
    $detector{"color"}      = $color[$n-1];    
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
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
}

# sub make_scattering_chamber
# {
#  my $NUM  = 4;
#  my @y    = (26.0,-26.0,0.0,0.0);
# #  my @z    = (0.0-350,0.0-350,0.0-350,0.0-350);
#  my @z    = (0,0,0,0); 
#  my @Rin  = (22.5,22.5,22.5,22.5);
#  my @Rout = (25.,25.,25.,25.);
#  my @Dz   = (11.0,11.0,15.0,15.0);
#  my @SPhi = (0.0,0.0,95.0,300.0);
#  my @DPhi = (360.0,360.0,145.0,145.0);
#  my @name = ("SC1","SC2","SC3","SC4");
#  my @mother = ("$DetectorName\_field","$DetectorName\_field","$DetectorName\_field","$DetectorName\_field"); 
#  my @mat  = ("G4_Al","G4_Al","G4_Al","G4_Al");
# 
#  for(my $n=1; $n<=$NUM; $n++)
#  {
#      my %detector=init_det(); 
#     $detector{"name"}        = "$DetectorName\_$name[$n-1]";
#     $detector{"mother"}      = "$mother[$n-1]" ;
#     $detector{"description"} = "$DetectorName\_$name[$n-1]";
#     $detector{"pos"}        = "0*cm $y[$n-1]*cm $z[$n-1]*cm";
#     $detector{"rotation"}   = "0*deg 0*deg 0*deg";
#     $detector{"color"}      = "FF6600";
#     $detector{"type"}       = "Tube";
#     $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm $SPhi[$n-1]*deg $DPhi[$n-1]*deg";
#     $detector{"material"}   = $mat[$n-1];
#     $detector{"mfield"}     = "no";
#     $detector{"ncopy"}      = 1;
#     $detector{"pMany"}       = 1;
#     $detector{"exist"}       = 1;
#     $detector{"visible"}     = 1;
#     $detector{"style"}       = 1;
#     $detector{"sensitivity"} = "no";
#     $detector{"hit_type"}    = "no";
#     $detector{"identifiers"} = "no";
#     print_det(\%configuration, \%detector);
#  }
# }

#2. The scattering chamber has entrance and exit windows on them, made of thin Al ( 0.04cm)
#  a) beam entrance window dimensions can be small:  20cm wide  and 30cm  height
#  b) beam exit  window dimensions should be large enough to cover +/- 28deg in the scattering particles. You can keep the same height (30cm) but need at least 100cm width to cover angular range.

sub make_scattering_windows
{
 my $NUM  = 4;
#  my @z    = (0.0-350,0.0-350);
 my @z    = (0,0,0,0); 
 my @Rin  = (22.5,24.96,22.5,24.96);
 my @Rout = (24.96,25,24.96,25);
 my @Dz   = (5,5,10,10);
 my @SPhi = (85,85,245,245);
 my @DPhi = (10,10,50,50);
 my @name = ("entrance_cut","entrance_win","exit_cut","exit_win");
 my @mother = ("$DetectorName\_SC_out","$DetectorName\_SC_out","$DetectorName\_SC_out","$DetectorName\_SC_out");
 my @mat  = ("G4_Galactic","G4_Al","G4_Galactic","G4_Al");
 my @color = ("FFFFFF","000000","FFFFFF","000000");

 for(my $n=1; $n<=$NUM; $n++)
 {
     my %detector=init_det(); 
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color[$n-1];
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm $SPhi[$n-1]*deg $DPhi[$n-1]*deg";
    $detector{"material"}   = $mat[$n-1];
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
}

sub make_target
{
 my $NUM  = 1;
#  my @z    = (0.0-350);
 my @z    = (0);
 my @Rin  = (0.0);
 my @Rout = (1.413);
 my @Dz   = (1.423);
 my @name = ("target"); 
 my @mother = ("$DetectorName\_SC_in"); 
 my @mat  = ("SL_target_NH3_NH3He4");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
     my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "-90*deg 0*deg 0*deg";
    $detector{"color"}      = "ff0000";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
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
}
