use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_spd_largeangle';

my $DetectorMother="root";

my $z		= $parameters{"z"};
my $Rmin	= $parameters{"Rmin"};
my $Rmax	= $parameters{"Rmax"};
my $Dz   	= $parameters{"Dz"}; # half thickness

my $sen="solid_spd";

sub solid_SIDIS_spd_largeangle
{
spd();
}

sub spd
{ 
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName";
 $detector{"mother"}      = "$DetectorMother" ;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm $z*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Rmin*cm $Rmax*cm $Dz*cm 0*deg 360*deg";
 $detector{"material"}    = "SL_spd_ScintillatorB";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "$sen";
 $detector{"hit_type"}    = "$sen";
 $detector{"identifiers"} = "id manual 5200000";
 print_det(\%configuration, \%detector);
}
