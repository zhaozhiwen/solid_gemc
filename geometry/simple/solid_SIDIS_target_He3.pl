#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_target_He3';

my $DetectorMother="root";

sub solid_SIDIS_target_He3
{
	make_target();
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
 my @z    = (0.-350,0.,0.,-20.006,20.006);
 my @Rin  = (0.0,0.9,0.0,0.0,0.0);
 my @Rout = (1.01,1.0,0.9,0.9,0.9);
 my @Dz   = (20.012,20.0,20.0,0.006,0.006);
 my @name = ("TRGB","TCEL","TLHE","TLW1","TLW2"); 
 my @mother = ("$DetectorMother","$DetectorName\_TRGB","$DetectorName\_TRGB","$DetectorName\_TRGB","$DetectorName\_TRGB");
 #SL_Vacuum is the vacuum with certain air, or use G4_Galactic for pure vacuum 
 my @mat  = ("SL_Vacuum","SL_Glass_GE180","He3_10amg","SL_Glass_GE180","SL_Glass_GE180");

# GPARMED58  233 '3He 10 atm$         '  33  0  1  1. -1. -1.   -1.   0.1    -1. 
# GPARMXT05   33 '3He 10 atm $        ' 1.33E-3  -1      3.  2.  1.
# GPARMED62  264 'Glass GE 180 mf    $'  64  0  1 30. -1. -1.   -1.   0.01   -1.
# GPARMXT08   64 'Glass al-sil  GE180$' 2.76      7     16.  8. 0.524  28.1 14. 0.266   27. 13. 0.072  24.3 12. 0.072 
#                                                       40. 20. 0.036  11.   5. 0.013   23. 11. 0.007   

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
