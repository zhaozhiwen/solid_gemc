#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_DDVCS_muon_forwardangle';

my $DetectorMother="root";

sub solid_DDVCS_muon_forwardangle
{
make_solid_DDVCS_muon_forwardangle_1();
make_solid_DDVCS_muon_forwardangle_2();
make_solid_DDVCS_muon_forwardangle_3();
}

 my $color="00ffff";
 my $material="G4_STAINLESS-STEEL";

sub make_solid_DDVCS_muon_forwardangle_1
{
    my $z=543;
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_1";
    $detector{"mother"}      = "$DetectorMother";
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}       = "Cons";
    my $Rmin1 = 100;
    my $Rmax1 = 285;
    my $Rmin2 = 100;
    my $Rmax2 = 285;
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

sub make_solid_DDVCS_muon_forwardangle_2
{
    my $z=585;
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_2";
    $detector{"mother"}      = "$DetectorMother";
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}       = "Cons";
    my $Rmin1 = 100;
    my $Rmax1 = 285;
    my $Rmin2 = 100;
    my $Rmax2 = 285;
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

sub make_solid_DDVCS_muon_forwardangle_3
{
    my $z=627;
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_3";
    $detector{"mother"}      = "$DetectorMother";
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}       = "Cons";
    my $Rmin1 = 100;
    my $Rmax1 = 285;
    my $Rmin2 = 100;
    my $Rmax2 = 285;
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
