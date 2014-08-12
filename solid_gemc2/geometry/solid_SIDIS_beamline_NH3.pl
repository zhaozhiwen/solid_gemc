use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_beamline_NH3';

my $DetectorMother="root";

sub solid_SIDIS_beamline_NH3
{
make_beam_entrance();
make_beam_exit();
}

#C --     Beam pipe: entrance
#C
#GPARVOL02  'BMP1'  235  'HALL'    0.    0. -175.    0  'TUBE'  3   0.    1.25    150.   
#GPARVOL03  'BMV1'  203  'BMP1'    0.    0.    0.    0  'TUBE'  3   0.    1.22    150.   
#GPARVOL04  'BMD1'   99  'BMV1'    0.    0. -149.9   0  'TUBE'  3   0.    1.22      0.1  
#GPARVOL05  'BMW1'  265  'BMV1'    0.    0.  149.9   0  'TUBE'  3   0.    1.22      0.0125 

sub make_beam_entrance
{
 my $NUM  = 4;
 my @z    = (-175.-350,0.,-149.9,149.9);
 my @Rin  = (0.,0.0,0.0,0.0);
 my @Rout = (1.25,1.22,1.22,1.22);
 my @Dz   = (150.0,150.0,0.1,0.0125);
 my @name = ("BMP1","BMV1","BMD1","BMW1"); 
 my @mother = ("$DetectorMother","$DetectorName\_BMP1","$DetectorName\_BMV1","$DetectorName\_BMV1"); 
 my @mat  = ("G4_Al","SL_Vacuum","Kryptonite","G4_Be");

# C           #       name              mat sen F Fmx Fan stmx  Elo epsi st(mu,lo)  user words
#             #       name               A    Z    g/cm3        RLcm   Int.len cm
# GPARMED19  235 'Alum,  mf$          '   9  0  1 30. -1. -1.   -1.   0.2    -1.
# GPARMED04  203 'Vacuum,    mf$      '  16  0  1 30. -1.  2.0  -1.   0.1    -1.
# GPARMED43   99 'Dead absorber$      '  10  0  0  0. -1. -1.   -1.   1.     -1.
# GPARMED63  265 'Be, mf             $'   5  0  1 30. -1. -1.   -1.   0.05   -1.

 for(my $n=1; $n<=$NUM; $n++)
 {
     my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "FF6633";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
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
}

sub make_beam_exit
{
 my $NUM  = 4;
#  my @z    = (335.-350,0.,309,-309.9);
#  my @Rmin1  = (0.,0.,0.,0.);
#  my @Rmax1 = (1.80,1.70,38.0,1.7);
#  my @Rmin2  = (0.,0.,0.,0.);
#  my @Rmax2 = (40.,39.,38.,1.7);
#  my @Dz   = (310.,310.,1.,0.0125);
# to avoid overlap with downsteam yoke
 my @z    = (315.-350,0.,290,-290);
 my @Rmin1  = (0.,0.,0.,0.);
 my @Rmax1 = (1.80,1.70,35.0,1.7);
 my @Rmin2  = (0.,0.,0.,0.);
 my @Rmax2 = (37.,36.,35.,1.7);
 my @Dz   = (290.,290.,1.,0.0125);
 my @name = ("B3PP","B3PV","B3DM","B3W1"); 
 my @mother=("$DetectorMother","$DetectorName\_B3PP","$DetectorName\_B3PV","$DetectorName\_B3PV");
 my @mat  = ("G4_Al","SL_Vacuum","Kryptonite","G4_Be");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "ff6633";
    $detector{"type"}       = "Cons";
    $detector{"dimensions"} = "$Rmin1[$n-1]*cm $Rmax1[$n-1]*cm $Rmin2[$n-1]*cm $Rmax2[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
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
}
