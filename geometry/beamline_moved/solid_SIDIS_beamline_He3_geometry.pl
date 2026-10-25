use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_beamline_He3';

my $DetectorMother="root";

# my $z_target			= $parameters{"z_target"};

sub solid_SIDIS_beamline_He3
{
make_beam_entrance();
make_beam_exit();
}

my $z_target = -350;
my $z_win_upstream = -375; 
my $z_win_downstream = -325; 

sub make_beam_entrance
{
# used during hallc He3 run 2020, upstream Be window .01thk, 12.80 inch from target center at pivot,and 0.0002" thk Al cover, inner diameter 2.067" outer diameter 2.375", length 200cm
#  my @z    = ($z_win_upstream-100,0,-100+0.01*2.54/2,100-0.0002*2.54-0.01*2.54/2,100-0.0002*2.54/2);
#  my @Rin  = (0.,0.,0.,0.,0);
#  my @Rout = (2.375/2*2.54,2.067/2*2.54,2.067/2*2.54,2.067/2*2.54,2.067/2*2.54);
#  my @Dz   = (100,100,0.01*2.54/2,0.01*2.54/2,0.0002*2.54/2);
#  my $NUM  = 5;
#  my @name = ("BMP1","BMV1","BMD1","BMW1","BMC1"); 
#  my @mother = ("$DetectorMother","$DetectorName\_BMP1","$DetectorName\_BMV1","$DetectorName\_BMV1","$DetectorName\_BMV1"); 
#  my @mat  = ("G4_Al","G4_Galactic","G4_Galactic","G4_Be","G4_Al");
#  my @color = ("0000ff","808080","808080","00FFFF","FF00FF");

# Al created white powders on target cell we won't use them in future
 my @z    = ($z_win_upstream-100,0,100-0.01*2.54/2);
 my @Rin  = (0.,0.,0);
 my @Rout = (2.375/2*2.54,2.067/2*2.54,2.067/2*2.54);
 my @Dz   = (100,100,0.01*2.54/2);
 my $NUM  = 3;
 my @name = ("BMP1","BMV1","BMW1"); 
 my @mother = ("$DetectorMother","$DetectorName\_BMP1","$DetectorName\_BMV1"); 
 my @mat  = ("G4_Al","G4_Galactic","G4_Be");
 my @color = ("0000ff","808080","00FFFF");

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

#C --     Beam pipe: exit
#C
#GPARVOL10  'B3PP'  235  'HALL'    0.    0.  335.    0  'CONE'  5  310.  0.   1.80   0.  40.00  
#GPARVOL11  'B3PV'  203  'B3PP'    0.    0.    0.    0  'CONE'  5  310.  0.   1.70   0.  39.00  
#GPARVOL12  'B3DM'   99  'B3PV'    0.    0.  309.    0  'TUBE'  3   0.   38.0   1.0
#GPARVOL13  'B3W1'  265  'B3PV'    0.    0. -309.9   0  'TUBE'  3   0.    1.7  0.0125

sub make_beam_exit
{
# used during hallc He3 run 2020, downstream Be window .02thk, 17.25 inch from target center at pivot,and 0.001" thk Al cover, inner diameter 2.067" outter diameter 2.375"
# solid need smaller window to avoid target collimator
#  my $NUM  = 5;
#  my @name = ("B3PP","B3PV","B3DM","B3W1","B3W2"); 
#  my @mother=("$DetectorMother","$DetectorName\_B3PP","$DetectorName\_B3PV","$DetectorName\_B3PV","$DetectorName\_B3PV");
#  my @mat  = ("G4_Al","G4_Galactic","G4_Galactic","G4_Al","G4_Be");
#  my @color = ("0000ff","808080","808080","FF00FF","00FFFF");
#  my $thk_Al = 0.001*2.54;
#  my $thk_Be = 0.02*2.54;
#  my $pos_end_Al = $z_win_downstream + $thk_Al;
#  my $pos_end_Be = $pos_end_Al + $thk_Be; 

# Al created white powders on target cell we won't use them in future
 my $NUM  = 4;
 my @name = ("B3PP","B3PV","B3W1","B3W2");
 my @mother=("$DetectorMother","$DetectorName\_B3PP","$DetectorName\_B3PV","$DetectorName\_B3PV");
 my @mat  = ("G4_Al","G4_Galactic","G4_Be","Kryptonite");
 my @color = ("0000ff","808080","00FFFF","00FFFF");
 my $thk_Be = 0.02*2.54;
 my $pos_end_Be = $z_win_downstream + $thk_Be;

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

#     $detector{"type"}       = "Polycone";
#     if ($n==1) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 1.05*cm 19*cm 19*cm -325*cm 190*cm 550*cm";}
#     if ($n==2) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 1.*cm 18.95*cm 18.95*cm -325*cm 190*cm 550*cm";}
#     if ($n==3) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 18.95*cm 18.95*cm 549.9*cm 550*cm";}
#     if ($n==4) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 1.*cm 1.*cm $z_win_downstream*cm $pos_end_Al*cm";}
#     if ($n==5) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 1.*cm 1.*cm $pos_end_Al*cm $pos_end_Be*cm";}    

    $detector{"type"}       = "Polycone";
    if ($n==1) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 1.05*cm 19*cm 19*cm -325*cm 190*cm 550*cm";}
    if ($n==2) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 1.*cm 18.95*cm 18.95*cm -325*cm 190*cm 550*cm";}
    if ($n==3) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 1.*cm 1.*cm $z_win_downstream*cm $pos_end_Be*cm";}
    if ($n==4) {$detector{"dimensions"} = "0*deg 360*deg 2*counts 0*cm 0*cm 18.95*cm 18.95*cm 549.9*cm 550*cm";}
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

