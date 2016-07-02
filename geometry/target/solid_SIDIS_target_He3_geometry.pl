use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_target_He3';

my $DetectorMother="root";

my $z_target			= $parameters{"z_target"};
my $z_collimator_upstream	= $parameters{"z_collimator_upstream"};
my $z_collimator_downstream	= $parameters{"z_collimator_downstream"};

my $material_collimator = "SL_target_He3_TungstenPowder";

sub solid_SIDIS_target_He3
{
make_target();
make_collimator_upstream();
make_collimator_downstream();
}

#  --     Target  ==================================
# GPARVOL20  'TRGB'    1  'HALL'    0.    0.   0.    0  'TUBE'  3   0.    8.0   24.0
# GPARVOL21  'TCEL'  264  'TRGB'    0.    0.   0.    0  'TUBE'  3   0.9   1.0   20.0
# GPARVOL22  'TLHE'  233  'TRGB'    0.    0.   0.    0  'TUBE'  3   0.    0.90  20.0   
# GPARVOL23  'TLW1'  264  'TRGB'    0.    0. -20.006 0  'TUBE'  3   0.    0.90   0.0060   
# GPARVOL24  'TLW2'  264  'TRGB'    0.    0.  20.006 0  'TUBE'  3   0.    0.90   0.0060   

sub make_target
{
 my $NUM  = 5;
 my @z    = ($z_target,0.,0.,-20.006,20.006);
 my @Rin  = (0.0,0.9,0.0,0.0,0.0);
 my @Rout = (1.01,1.0,0.9,0.9,0.9);
 my @Dz   = (20.012,20.0,20.0,0.006,0.006);
 my @name = ("TRGB","TCEL","TLHE","TLW1","TLW2"); 
 my @mother = ("$DetectorMother","$DetectorName\_TRGB","$DetectorName\_TRGB","$DetectorName\_TRGB","$DetectorName\_TRGB");
 my @mat  = ("G4_Galactic","SL_target_He3_Glass_GE180","SL_target_He3_He3_10amg","SL_target_He3_Glass_GE180","SL_target_He3_Glass_GE180"); 
#somehow SL_target_He3_He3_10amg doesn't work for GEMC 2.2, but work for GEMC 2.1, it could be related to isotope helium3 and helium3Gas in GEMC source code materials/material_factory.cc, I don't see what's difference between 2.1 and 2.2
# my @mat  = ("G4_Galactic","SL_target_He3_Glass_GE180","He3_10amg","SL_target_He3_Glass_GE180","SL_target_He3_Glass_GE180");

# http://galileo.phys.virginia.edu/research/groups/spinphysics/glass_properties.html

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "FF0000";
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

sub make_collimator_upstream
{
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_upstream";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z_collimator_upstream*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "003300";
    $detector{"type"}       = "Cons";
    my $Rmin1 = 1.3;
    my $Rmax1 = 2.7;
    my $Rmin2 = 2.6;
    my $Rmax2 = 5.4;
    my $Dz    = 5;
    my $Sphi  = 0;
    my $Dphi  = 360;
    $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
    $detector{"material"}   = "$material_collimator";
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

sub make_collimator_downstream
{
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_downstream";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z_collimator_downstream*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "003300";
    $detector{"type"}       = "Cons";
    my $Rmin1 = 1.3;
    my $Rmax1 = 2.7;
    my $Rmin2 = 2.6;
    my $Rmax2 = 5.4;
    my $Dz    = 5;
    my $Sphi  = 0;
    my $Dphi  = 360;
    $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
    $detector{"material"}   = "$material_collimator";
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
