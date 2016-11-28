#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_PVDIS_baffle_observer_CLEO2';

my $DetectorMother="root";

# Global variables governing some of the variations
my @color_baffle_observer;
my @sensitivity_baffle_observer;
my @hit_baffle_observer;
my @mother;
my @material_baffle_observer;

# System parameters
my $Nplate; # # of baffles
my $Dz;  # half thickness of baffle
my $zc0; # center of baffle system
my $Dzc;  # baffle spacing

# Baffle parameters
my @rinin;  # inner radius of inner ring
my @routout; # outer radius of outer ring

my @PlateZ;

sub solid_PVDIS_baffle_observer_CLEO2_geometry
{
# the first argument to this function becomes the variation
    $configuration{"variation"} = shift;

    $Nplate  = $parameters{"Nplate"}; 
    for (my $i = 0; $i < $Nplate; $i++)
    {
	$mother[$i] = $DetectorMother;
	$material_baffle_observer[$i] = "G4_Galactic";
	$sensitivity_baffle_observer[$i] = "flux";
	$hit_baffle_observer[$i] = "flux";
	if ($i == 0 && $configuration{"variation"} =~ /Enclosure/)
	{
	    $mother[$i] = "solid_PVDIS_target_enclosure_TACV";
	}
	$color_baffle_observer[$i] = "00C0C0";
    }

    $Dz  = $parameters{"Dz"};
    $zc0 = $parameters{"zc0"}; 
    $Dzc = $parameters{"Dzc"};
    @rinin = ($parameters{"rinin1"}, $parameters{"rinin2"}, 
	      $parameters{"rinin3"}, $parameters{"rinin4"}, 
	      $parameters{"rinin5"}, $parameters{"rinin6"}, 
	      $parameters{"rinin7"}, $parameters{"rinin8"}, 
	      $parameters{"rinin9"}, $parameters{"rinin10"}, 
	      $parameters{"rinin11"});
    @routout = ($parameters{"routout1"}, $parameters{"routout2"}, 
		$parameters{"routout3"}, $parameters{"routout4"}, 
		$parameters{"routout5"}, $parameters{"routout6"}, 
		$parameters{"routout7"}, $parameters{"routout8"}, 
		$parameters{"routout9"}, $parameters{"routout10"}, 
		$parameters{"routout11"});

    @PlateZ = ();
    for (my $i = 0; $i < $Nplate; ++$i)
    {
	my $z = $zc0 + $Dzc * ($i - ($Nplate-1) * 0.5);
	push @PlateZ, $z;
    }

    make_CLEO2_baffle_observer_plate();
}

1; # return true


sub make_CLEO2_baffle_observer_plate
{
    for(my $n=1; $n<=$Nplate; $n++)
    {
	my $n_c     = cnumber($n-1, 1);
	my %detector=init_det();
	$detector{"mother"}      = "$mother[$n-1]" ;
	my $obsthick = 0.001; # half thickness of observer
	$detector{"rotation"}   = "0*deg 0*deg 0*deg";
	$detector{"color"}      = "$color_baffle_observer[$n-1]";
	$detector{"type"}       = "Tube";
	$detector{"dimensions"} = "$rinin[$n-1]*cm $routout[$n-1]*cm 0.001*cm 0*deg 360*deg";
	$detector{"material"}   = "$material_baffle_observer[$n-1]";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "$sensitivity_baffle_observer[$n-1]";
	$detector{"hit_type"}    = "$hit_baffle_observer[$n-1]";

	$detector{"name"}        = "$DetectorName\_plate${n_c}\_up";
	$detector{"description"} = $detector{"name"};
	my $z = $PlateZ[$n-1] - $Dz - $obsthick;
	$z -= ($n == 1 && $configuration{"variation"} =~ /Enclosure/) ? 10: 0;
	$detector{"pos"}        = "0*cm 0*cm $z*cm";
	my $id = (7000 + 10*$n + 1) * 10000;
	$detector{"identifiers"} = "id manual $id";
	print_det(\%configuration, \%detector);

	$detector{"name"}        = "$DetectorName\_plate${n_c}\_down";
	$detector{"description"} = $detector{"name"};
	$z = $PlateZ[$n-1] + $Dz + $obsthick;
	$z -= ($n == 1 && $configuration{"variation"} =~ /Enclosure/) ? 10: 0;
	$detector{"pos"}        = "0*cm 0*cm $z*cm";
	$id = (7000 + 10*$n + 2) * 10000;
	$detector{"identifiers"} = "id manual $id";
	print_det(\%configuration, \%detector);
    }
}

