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
my $material_baffle = "G4_Pb";
my $color_baffle="00C0C0";

# System parameters
my $Nsect;  # of sectors
my $offset;  # phi offset

sub solid_PVDIS_baffle_CLEO2_photonblock
{
# the first argument to this function becomes the variation
    $configuration{"variation"} = shift;

    if ($configuration{"variation"} =~ /Kill/)
    {
	# Inert Kryptonite
	$material_baffle = "Kryptonite";
    }
    elsif ($configuration{"variation"} =~ /Copper/)
    {
	# Inert copper
	$material_baffle = "G4_Cu";
    }
    else
    {
	# Inert lead
	$material_baffle = "G4_Pb";
    }

    $Nsect  = $parameters{"Nslit"};
    $offset = $parameters{"offset11"};

    make_ec_forwardangle_block();
}

1; # return true

sub make_ec_forwardangle_block
{
    for (my $n=1; $n<=$Nsect; $n++)
    {
	my %detector=init_det();
	my $sect_rotation = -(96.0 + ($n-1) * 12.0 + $offset);
# 	$sect_rotation -= 360.0 if $sect_rotation > 360.0;

	$detector{"name"}        = "$DetectorName\_$n";
	$detector{"mother"}      = "$DetectorMother" ;
	$detector{"description"} = $detector{"name"};
	$detector{"pos"}        = "0*cm 0*cm 320*cm";
	$detector{"rotation"}   = "0*deg 0*deg $sect_rotation*deg";
	$detector{"color"}      = "$color_baffle";
	$detector{"type"}       = "Tube";
	my $phi_s = 2.2;
	$detector{"dimensions"} = "110*cm 200*cm 2.5*cm $phi_s*deg 2.5*deg";
	$detector{"material"}   = $material_baffle;
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
