#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_cherenkov_heavygas';

my $DetectorMother="root";

sub solid_SIDIS_cherenkov_heavygas
{
make_chamber();
make_chamber_window_front();
make_chamber_window_back();
make_hg_lightout();
}

my $material_gas="SL_CCGas"; # currently CF gas used for clas12

#BaBar
# Z(306,396)
# Rin(96,104)
# Rout(265,265)

# CLEOv8
# Z(306,396)
# Rin(86,98)
# Rout(265,265)

sub make_chamber
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_chamber";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CCCC33";
 $detector{"type"}        = "Polycone";
 $detector{"dimensions"}  = "0*deg 360*deg 2*counts 83*cm 96*cm 265*cm 265*cm 306*cm 406*cm";
 $detector{"material"}    = $material_gas;
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


sub make_chamber_window_front
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_chamber_window_front";
 $detector{"mother"}      = "$DetectorName\_chamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 306.025*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CCCC33";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "83.1*cm 264.9*cm 0.025*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_Al";
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


sub make_chamber_window_back
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_chamber_window_back";
 $detector{"mother"}      = "$DetectorName\_chamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 405.75*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CCCC33";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "96*cm 265*cm 0.25*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_Al";
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

# For the pion Cherenkov:
# z = 315 cm
# R = 230 cm
# angle = 44 deg
# photon detector size = 6" x 6"

sub make_hg_lightout
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_lightout";
 $detector{"mother"}      = "$DetectorName\_chamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 315*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 230-15.6/2.*sin(46./180.*3.1415926);
 my $Rmax1 = $Rmin1+0.1;
 my $Rmin2 = 230+15.6/2.*sin(46./180.*3.1415926);
 my $Rmax2 = $Rmin2+0.1;
 my $Dz    = 15.6/2.*cos(46./180.*3.1415926);
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 2200000";
 print_det(\%configuration, \%detector);
}
