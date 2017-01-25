#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_JPsi_muon_forwardangle';

my $DetectorMother="root";

sub solid_JPsi_muon_forwardangle
{
   # behind detector 
#make_muon_forwardangle(575);
#make_muon_forwardangle(655);
#make_muon_forwardangle(735);
##
make_muon_forwardangle(405);
make_muon_forwardangle(455);
make_muon_forwardangle(535);
}

 my $color="0000ff";
 my $material="G4_STAINLESS-STEEL";
 my $material_shield="G4_Pb";#"Lead";

sub make_muon_forwardangle
{
#  my $z=350;
#  my $z=575;
  my $z=$_[0];
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName".$z;
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}       = "Cons";
    my $Rmin1 = 50;
    my $Rmax1 = 265;
    my $Rmin2 = 50;
    my $Rmax2 = 265;
    my $Dz    = 18;
    my $Sphi  = 0;
    my $Dphi  = 360;
    $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
    $detector{"material"}   = "$material";
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
