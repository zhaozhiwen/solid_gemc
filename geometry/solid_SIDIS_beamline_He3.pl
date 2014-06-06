use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_beamline_He3';

my $DetectorMother="root";

sub solid_SIDIS_beamline_He3
{
make_beam_entrance();
make_beam_exit();
make_beam_coolgas();
}

#C --     Beam pipe: entrance
#C
#GPARVOL02  'BMP1'  235  'HALL'    0.    0. -175.    0  'TUBE'  3   0.    1.25    150.   
#GPARVOL03  'BMV1'  203  'BMP1'    0.    0.    0.    0  'TUBE'  3   0.    1.22    150.   
#GPARVOL04  'BMD1'   99  'BMV1'    0.    0. -149.9   0  'TUBE'  3   0.    1.22      0.1  
#GPARVOL05  'BMW1'  265  'BMV1'    0.    0.  149.9   0  'TUBE'  3   0.    1.22      0.0125 

sub make_beam_entrance
{
#  my $NUM  = 4;
#  my @z    = (-375,0.,-149.9,149.9875);
#  my @Rin  = (0.,0.,0.,0.);
#  my @Rout = (5,4.95,4.95,4.95);
#  my @Dz   = (150,150,0.1,0.0125);
#  my @name = ("BMP1","BMV1","BMD1","BMW1"); 
#  my @mother = ("$DetectorMother","$DetectorName\_BMP1","$DetectorName\_BMV1","$DetectorName\_BMV1"); 
#  my @mat  = ("Aluminum","Vacuum","Vacuum","G4_Be");
 
 my $NUM  = 4;
 my @name = ("BMP1","BMV1","BMD1","BMW1"); 
 my @mother = ("$DetectorMother","$DetectorName\_BMP1","$DetectorName\_BMV1","$DetectorName\_BMV1"); 
 my @mat  = ("Aluminum","Vacuum","Vacuum","G4_Be");
 my @color = ("0000ff","808080","808080","00FFFF");

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
#     $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color[$n-1];
#     $detector{"type"}       = "Tube";
#     $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"type"}       = "Polycone";
    if ($n==1) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 2*cm 2*cm -675*cm -375*cm";}
    if ($n==2) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 1.95*cm 1.95*cm -675*cm -375*cm";}
    if ($n==3) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 1.95*cm 1.95*cm -675*cm -674.9*cm";}
    if ($n==4) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 1.95*cm 1.95*cm -375.01*cm -375*cm";}
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
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


#C --     Beam pipe: exit
#C
#GPARVOL10  'B3PP'  235  'HALL'    0.    0.  335.    0  'CONE'  5  310.  0.   1.80   0.  40.00  
#GPARVOL11  'B3PV'  203  'B3PP'    0.    0.    0.    0  'CONE'  5  310.  0.   1.70   0.  39.00  
#GPARVOL12  'B3DM'   99  'B3PV'    0.    0.  309.    0  'TUBE'  3   0.   38.0   1.0
#GPARVOL13  'B3W1'  265  'B3PV'    0.    0. -309.9   0  'TUBE'  3   0.    1.7  0.0125

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
#  my @z    = (-325+412.5,0.,412.4,-412.4875);
#  my @Rmin1  = (0.,0.,0.,0.);
#  my @Rmax1 = (1.80,1.70,28.9,1.7);
#  my @Rmin2  = (0.,0.,0.,0.);
#  my @Rmax2 = (29.,28.9,28.9,1.7);
#  my @Dz   = (412.5,412.5,0.1,0.0125);
 my @name = ("B3PP","B3PV","B3DM","B3W1"); 
 my @mother=("$DetectorMother","$DetectorName\_B3PP","$DetectorName\_B3PV","$DetectorName\_B3PV");
 my @mat  = ("Aluminum","Vacuum","Vacuum","G4_Be");
 my @color = ("0000ff","808080","808080","00FFFF");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = $detector{"name"};
#     $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color[$n-1];
#     $detector{"type"}       = "Cons";
#     $detector{"dimensions"} = "$Rmin1[$n-1]*cm $Rmax1[$n-1]*cm $Rmin2[$n-1]*cm $Rmax2[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"type"}       = "Polycone";
    if ($n==1) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 1.05*cm 19*cm 19*cm -325*cm 190*cm 550*cm";}
    if ($n==2) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 1.*cm 18.95*cm 18.95*cm -325*cm 190*cm 550*cm";}
    if ($n==3) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 18.95*cm 18.95*cm 549.9*cm 550*cm";}
    if ($n==4) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 1.*cm 1.*cm -325*cm -324.99*cm";}
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
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


sub make_beam_coolgas
{
 my $NUM  = 2;
 my @z    = (-372.5,-327.5);
 my @Rin  = (0.,0.);
 my @Rout = (1,1);
 my @Dz   = (2.48,2.48);
 my @name = ("coolgas_upstream","coolgas_downstream"); 
 my @mother = ("$DetectorMother","$DetectorMother");
 my @mat  = ("He4_1atm","He4_1atm");
 my @color = ("808000","808000");

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
    $detector{"color"}      = $color[$n-1];
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
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

