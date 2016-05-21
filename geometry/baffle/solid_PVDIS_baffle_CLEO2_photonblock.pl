#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_PVDIS_baffle_CLEO2_photonblock';

my $DetectorMother="root";

sub solid_PVDIS_baffle_CLEO2_photonblock
{
# the first argument to this function becomes the variation
    $configuration{"variation"} = shift;

    $Nplate  = $parameters{"Nplate"}; 
    for (my $i = 0; $i < $Nplate; $i++)
    {
	$rout_adj[$i] = 0; # adjustments to routin and routout
	$Dphi_adj[$i] = 0;
	$mother[$i] = $DetectorMother;
	# adjustments -- 
	if ($configuration{"variation"} =~ /Zigzag/)
	{
	    $Dphi_adj[$i] = ($i % 2 == 0 ? 0 : -1); # Open up even # baffles
	}
	if ($configuration{"variation"} =~ /Kill/)
	{
	    # Inert Kryptonite
	    $material_baffle[$i] = "Kryptonite";
	    $material_baffle_within[$i] = "G4_Galactic";
	    $sensitivity_baffle[$i] = "no";
	    $hit_baffle[$i] = "no";
	}
	elsif ($configuration{"variation"} =~ /Copper/)
	{
	    # Inert copper
	    $material_baffle[$i] = "G4_Cu";
	    $material_baffle_within[$i] = "G4_AIR";
	    $sensitivity_baffle[$i] = "no";
	    $hit_baffle[$i] = "no";
	}
	else
	{
	    # Inert lead
	    $material_baffle[$i] = "G4_Pb";
	    $material_baffle_within[$i] = "G4_AIR";
	    $sensitivity_baffle[$i] = "no";
	    $hit_baffle[$i] = "no";
	}
	if ($i == 0 && $configuration{"variation"} =~ /Enclosure/)
	{
	    $mother[$i] = "solid_PVDIS_target_enclosure_TACV";
	    $material_baffle_within[$i] = "G4_Galactic";
	}
	$color_baffle[$i] = "00C0C0";
    }
    
make_ec_forwardangle_block();
}

my $color_baffle="00C0C0";

my $material="G4_Pb";#"Lead";

sub make_ec_forwardangle_block
{
 for(my $n=1; $n<=30; $n++)
 {
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$n";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm 320*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color_baffle";
    $detector{"type"}       = "Tube";
    my $phi_s=($n-1)*12+2.2;
    $detector{"dimensions"} = "110*cm 200*cm 2.5*cm $phi_s*deg 2.5*deg";
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
}
