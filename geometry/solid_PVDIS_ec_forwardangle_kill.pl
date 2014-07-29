#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_PVDIS_ec_forwardangle_kill';

my $DetectorMother="root";

sub solid_PVDIS_ec_forwardangle_kill
{
make_ec_forwardangle();
make_ec_forwardangle_shield();
}

# C  -------------- Hodoscope 7 Full Absorber - preshower
# HOD9SLATS       1
# HOD9MEDIUM   638
# HOD9MOTHER  'SOLE' 
# HOD9IDTYPE     42
# HOD9GATE       50.
# HOD9THRES       0
# C 
# HOD9SHAP    'CONE'
# HOD9SIZE1   4.    110. 237.  114. 242.  
# HOD9TYPE        1
# HOD9POSX        0.
# HOD9POSY        0.
# HOD9POSZ       320.0
# C  
# C  ---  Shower
# HOD10SLATS       1
# HOD10MEDIUM   638
# HOD10MOTHER  'SOLE' 
# HOD10IDTYPE     42
# HOD10GATE       50.
# HOD10THRES       0
# C 
# HOD10SHAP    'CONE'
# HOD10SIZE1   11.    114. 242.  122. 258.
# HOD10TYPE        1
# HOD10POSX        0.
# HOD10POSY        0.
# HOD10POSZ       335.0

 my $color="0000ff";
 my $material="SL_Kryptonite";
 my $material_shield="SL_Kryptonite";

sub make_ec_forwardangle
{
#  my $z=350;
  my $z=350;
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}       = "Cons";
    my $Rmin1 = 110;
    my $Rmax1 = 265;
    my $Rmin2 = 110;
    my $Rmax2 = 265;
    my $Dz    = 25;
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

sub make_ec_forwardangle_shield
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_shield";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 323.8*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $color;
 $detector{"type"}        = "Cons";
  my $Rmin1 = 110;
  my $Rmax1 = 265;
  my $Rmin2 = 110;
  my $Rmax2 = 265;
  my $Dz    = 0.56;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = $material_shield;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}
