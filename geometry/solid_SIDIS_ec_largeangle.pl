use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_ec_largeangle';

my $DetectorMother="root";

sub solid_SIDIS_ec_largeangle
{
make_ec_largeangle();
make_ec_largeangle_shield();
}

# HOD3SLATS       1
# HOD3MEDIUM    654
# HOD3MOTHER   'HALL' 
# HOD3IDTYPE       42
# HOD3GATE       80.
# HOD3THRES       0
# HOD3SHAP      'CONE'
# HOD3SIZE1      11.  82.00  134. 89. 141.  
# HOD3TYPE        1
# HOD3POSX        0.
# HOD3POSY        0.
# HOD3POSZ        295.5

 my $color="0000ff";
 my $material="LgTF1";
 my $material_shield="Lead";

sub make_ec_largeangle
{
#  my $z=295.5-350;
#  my $z=-40.5;
#  my $z=-40;
   my $z=0;
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}        = "Polycone";
#     my $Rmin1 = 82;
#     my $Rmax1 = 134;
#     my $Rmin2 = 89;
#     my $Rmax2 = 141;
#     my $Dz    = 11;
#     my $Rmin1 = 82;
#     my $Rmax1 = 141;
#     my $Rmin2 = 82;
#     my $Rmax2 = 141;
#     my $Dz    = 15;
#     my $Rmin1 = 76;
#     my $Rmax1 = 140;
#     my $Rmin2 = 89;
#     my $Rmax2 = 140;
#     my $Dz    = 25;
#     my $Sphi  = 0;
#     my $Dphi  = 360;
#     $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
    $detector{"dimensions"}  = "0*deg 360*deg 3*counts 83*cm 83*cm 89*cm 140*cm 140*cm 140*cm -65*cm -40*cm -15*cm";
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

sub make_ec_largeangle_shield
{
    my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_shield";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -66.2*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $color;
 $detector{"type"}        = "Cons";
  my $Rmin1 = 83;
  my $Rmax1 = 140;
  my $Rmin2 = 83;
  my $Rmax2 = 140;
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
