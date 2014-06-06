use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_PVDIS_beamline';

my $DetectorMother="root";

sub solid_PVDIS_beamline
{
make_beam_entrance();
make_beam_exit();
}

# target offset in cm
my $targetoff=10;
# my $targetoff=-340;

# C -- Auxil: target center
# C
# GPARVOL02  'TARC'    0  'SOLE'    0.    0.   10.    0  'TUBE'  3   1.    1.    1.
# C
# C --     Beam pipe: entrance
# C
# GPARVOL03  'BMP1'  209  'TARC'    0.    0. -175.    0  'TUBE'  3   0.    1.25    150.   
# GPARVOL04  'BMV1'  221  'BMP1'    0.    0.    0.    0  'TUBE'  3   0.    1.22    150.   
# GPARVOL05  'BMD1'   99  'BMV1'    0.    0. -149.9   0  'TUBE'  3   0.    1.22      0.1  
# C
# C --     Beam pipe: exit
# C
# GPARVOL06  'BMP2'  209  'TARC'    0.    0.   30.    0  'TUBE'  3   0.    1.50      5.   
# GPARVOL07  'BMV2'  221  'BMP2'    0.    0.    0.    0  'TUBE'  3   0.    1.45      5.   
# GPARVOL08  'BMP3'  209  'TARC'    0.    0.  155.    0  'CONE'  5  120.  0.   1.50   0.  29.00  
# GPARVOL09  'BMV3'  221  'BMP3'    0.    0.    0.    0  'CONE'  5  120.  0.   1.45   0.  28.00  
# GPARVOL10  'BMP4'  209  'TARC'    0.    0.  335.    0  'TUBE'  3   0.   29.0      60.   
# GPARVOL11  'BMV4'  221  'BMP4'    0.    0.    0.    0  'TUBE'  3   0.   28.0      60.   
# GPARVOL12  'BMD4'   99  'BMV4'    0.    0.   59.5   0  'TUBE'  3   0.   28.    0.5
# C

sub make_beam_entrance
{
 my $NUM  = 2;
 my @z    = (-687+330,0.);
 my @Rin  = (0.,0.);
 my @Rout = (30,29.95);
 my @Dz   = (330,330);
 my @name = ("BMP1","BMV1"); 
 my @mother = ("$DetectorMother","$DetectorName\_BMP1"); 
 my @mat  = ("Aluminum","Vacuum");
 my @color = ("0000ff","808080");

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

sub make_beam_exit
{
 my $NUM  = 2;
 my @name = ("B3PP","B3PV"); 
 my @mother=("$DetectorMother","$DetectorName\_B3PP");
 my @mat  = ("Aluminum","Vacuum");
 my @color = ("0000ff","808080");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color[$n-1];
    $detector{"type"}       = "Polycone";
    if ($n==1) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 5*cm 19*cm 19*cm 47*cm 110*cm 550*cm";}
    if ($n==2) {$detector{"dimensions"} = "0*deg 360*deg 3*counts 0*cm 0*cm 0*cm 4.95*cm 18.95*cm 18.95*cm 47*cm 110*cm 550*cm";}
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
