use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_virtualplane_ec';

my $DetectorMother="root";

sub solid_SIDIS_virtualplane_ec
{
make_solid_SIDIS_virtualplane_ec_forwardangle_front();
make_solid_SIDIS_virtualplane_ec_forwardangle_middle();
make_solid_SIDIS_virtualplane_ec_forwardangle_inner();
make_solid_SIDIS_virtualplane_ec_forwardangle_rear();
make_solid_SIDIS_virtualplane_ec_largeangle_front();
make_solid_SIDIS_virtualplane_ec_largeangle_middle();
make_solid_SIDIS_virtualplane_ec_largeangle_inner();
make_solid_SIDIS_virtualplane_ec_largeangle_rear();
}

sub make_solid_SIDIS_virtualplane_ec_forwardangle_front
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_forwardangle_front";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 413*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 90;
  my $Rmax1 = 265;
  my $Rmin2 = 90;
  my $Rmax2 = 265;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3110000";
 print_det(\%configuration, \%detector);
}

sub make_solid_SIDIS_virtualplane_ec_forwardangle_middle
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_forwardangle_middle";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 414.6*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 90;
  my $Rmax1 = 265;
  my $Rmin2 = 90;
  my $Rmax2 = 265;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3120000";
 print_det(\%configuration, \%detector);
}

sub make_solid_SIDIS_virtualplane_ec_forwardangle_inner
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_forwardangle_inner";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 440*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 96;
  my $Rmax1 = 96.1;
  my $Rmin2 = 96;
  my $Rmax2 = 96.1;
  my $Dz    = 25;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3130000";
 print_det(\%configuration, \%detector);
}

sub make_solid_SIDIS_virtualplane_ec_forwardangle_rear
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_forwardangle_rear";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 466*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 90;
  my $Rmax1 = 265;
  my $Rmin2 = 90;
  my $Rmax2 = 265;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3140000";
 print_det(\%configuration, \%detector);
}

sub make_solid_SIDIS_virtualplane_ec_largeangle_front
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_largeangle_front";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -67*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 75;
  my $Rmax1 = 144;
  my $Rmin2 = 75;
  my $Rmax2 = 144;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3210000";
 print_det(\%configuration, \%detector);
}

sub make_solid_SIDIS_virtualplane_ec_largeangle_middle
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_largeangle_middle";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -65.4*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 75;
  my $Rmax1 = 144;
  my $Rmin2 = 75;
  my $Rmax2 = 144;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3220000";
 print_det(\%configuration, \%detector);
}

sub make_solid_SIDIS_virtualplane_ec_largeangle_inner
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_largeangle_inner";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -40*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 75;
  my $Rmax1 = 75.1;
  my $Rmin2 = 88;
  my $Rmax2 = 88.1;
  my $Dz    = 25;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3230000";
 print_det(\%configuration, \%detector);
}

sub make_solid_SIDIS_virtualplane_ec_largeangle_rear
{
 my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_largeangle_rear";
 $detector{"mother"}      = $DetectorMother;
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -14*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
  my $Rmin1 = 89;
  my $Rmax1 = 144;
  my $Rmin2 = 89;
  my $Rmax2 = 144;
  my $Dz    = 0.001/2;
  my $Sphi  = 0;
  my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 3240000";
 print_det(\%configuration, \%detector);
}
