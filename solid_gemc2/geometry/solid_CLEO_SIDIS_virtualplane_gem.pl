use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_CLEO_SIDIS_virtualplane_gem';

my $DetectorMother="root";

sub solid_CLEO_SIDIS_virtualplane_gem
{
make_virtualplane_gem();
}

sub make_virtualplane_gem
{
 my $Nplate  = 6;
#  my @PlateZ  = (175.-350, 200.-350,  231.-350,  282.-350,  355.-350,   442.-350,);
#  my @PlateZ  = (-175,-150,-119,-68,5,92);
 my @PlateZ  = (-175-0.5,-150-0.5,-119-0.5,-68-0.5,5-0.5,92-0.5);

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
#  my $Dz   = 0.9781/2;
my $Dz   = 0.001/2;  
#  my $color="44ee11";


 for(my $n=1; $n<=$Nplate; $n++)
 {
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$n";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "CC6633";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "Vacuum";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 0;
    $detector{"sensitivity"} = "flux";
    $detector{"hit_type"}    = "flux";
    my $id=1000000+$n*100000+10000;
    $detector{"identifiers"} = "id manual $id";
    print_det(\%configuration, \%detector);
 }
}
