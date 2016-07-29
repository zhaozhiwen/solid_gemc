#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_spd_largeangle_virtualplane';

my $DetectorMother="root";

my $z		= $parameters{"z"};
my $Rmin	= $parameters{"Rmin"};
my $Rmax	= $parameters{"Rmax"};
my $Dz   	= $parameters{"Dz"}; # half thickness

my $z_vp = $z-$Dz-0.1;

sub solid_SIDIS_spd_largeangle_virtualplane
{
make_solid_SIDIS_spd_largeangle_virtualplane_front();
}

sub make_solid_SIDIS_spd_largeangle_virtualplane_front
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_front";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm $z_vp*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Rmin*cm $Rmax*cm 0.001*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_Galactic";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 5210000";
 print_det(\%configuration, \%detector);
}
