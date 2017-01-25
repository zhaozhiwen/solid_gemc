#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_JPsi_virtualplane_muon';

my $DetectorMother="root";

sub solid_JPsi_virtualplane_muon
{
make_solid_JPsi_virtualplane_muon_forwardangle_front();
make_solid_JPsi_virtualplane_muon_forwardangle_back();
make_solid_JPsi_virtualplane_muon_endcapdonut();
make_solid_JPsi_virtualplane_muon_barrel_1();
make_solid_JPsi_virtualplane_muon_barrel_2();
}

sub make_solid_JPsi_virtualplane_muon_forwardangle_front
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_forwardangle_front";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 520*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 50;
  my $Rmax1 = 290;
  my $Rmin2 = 50;
  my $Rmax2 = 290;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 6110000";
 print_det(\%configuration, \%detector);
}

sub make_solid_JPsi_virtualplane_muon_forwardangle_back
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_forwardangle_back";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 630*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 50;
  my $Rmax1 = 290;
  my $Rmin2 = 50;
  my $Rmax2 = 290;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 6120000";
 print_det(\%configuration, \%detector);
}

sub make_solid_JPsi_virtualplane_muon_endcapdonut
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_endcapdonut";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 355*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 286;
  my $Rmax1 = 286.1;
  my $Rmin2 = 286;
  my $Rmax2 = 286.1;
  my $Dz    = 160;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 6210000";
 print_det(\%configuration, \%detector);
}


sub make_solid_JPsi_virtualplane_muon_barrel_1
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_barrel_1";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -38*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 215;
  my $Rmax1 = 215.1;
  my $Rmin2 = 215;
  my $Rmax2 = 215.1;
  my $Dz    = 197;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 6310000";
 print_det(\%configuration, \%detector);
}


sub make_solid_JPsi_virtualplane_muon_barrel_2
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_barrel_2";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -38*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 260;
  my $Rmax1 = 260.1;
  my $Rmin2 = 260;
  my $Rmax2 = 260.1;
  my $Dz    = 227;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 6320000";
 print_det(\%configuration, \%detector);
}
