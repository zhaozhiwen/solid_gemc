use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_target_He3_coil';

my $DetectorMother="root";

sub solid_SIDIS_target_He3_coil
{
make_coil_large();
make_coil_small();
}

# refer to He3 target coil at https://hallaweb.jlab.org/wiki/index.php/Holding_Field_Control

sub make_coil_large
{
 my $R=75.8; #cm
 my $width=6.6; #cm 
 my $NUM  = 2;
 my @z    = (-350-$R/2.,-350+$R/2.);
 my @Rin  = ($R-$width/2.,$R-$width/2.);
 my @Rout = ($R+$width/2.,$R+$width/2.);
 my @Dz   = ($width/2.,$width/2.);
 my @name = ("coil_large_upstream","coil_large_downstream");
 my @mother = ("$DetectorMother","$DetectorMother");
 my @mat  = ("G4_Cu","G4_Cu"); 
 
 for(my $n=1; $n<=$NUM; $n++)
 {
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "ff8000";
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

sub make_coil_small
{
 my $R=66.7; #cm
 my $width=6.6; #cm 
 my $NUM  = 2;
 my @x    = (-$R/2.,$R/2.); 
 my @Rin  = ($R-$width/2.,$R-$width/2.);
 my @Rout = ($R+$width/2.,$R+$width/2.);
 my @Dz   = ($width/2.,$width/2.);
 my @name = ("coil_small_left","coil_small_right");
 my @mother = ("$DetectorMother","$DetectorMother");
 my @mat  = ("G4_Cu","G4_Cu"); 
 
 for(my $n=1; $n<=$NUM; $n++)
 {
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "$x[$n-1]*cm 0*cm -350*cm";
    $detector{"rotation"}   = "0*deg 90*deg 0*deg";
    $detector{"color"}      = "ff8000";
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