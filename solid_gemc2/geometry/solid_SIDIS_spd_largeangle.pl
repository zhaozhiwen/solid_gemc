#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_spd_largeangle';

my $DetectorMother="root";

sub solid_SIDIS_spd_largeangle
{
make_spd_largeangle();
}

 my $z=-67;

sub make_spd_largeangle
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName";
 $detector{"mother"}      = "$DetectorMother" ;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm $z*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 80;
  my $Rmax1 = 135;
  my $Rmin2 = 80;
  my $Rmax2 = 135;
  my $Dz    = 0.3/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_ScintillatorB";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 5200000";
 print_det(\%configuration, \%detector);
}
