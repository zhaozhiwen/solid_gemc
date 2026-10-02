#!/usr/bin/perl -w

# sPHENIX 2017 SPACAL prototype (Prototype3) for solid_gemc.
# Port of PHG4SpacalPrototypeDetector.cc; numbers from the sPHENIX geometry XML,
# converted by sphenix_xml2param.py into <detector>__parameters_<variation>.txt.
#
# Usage: ./solid_spacal.pl <detector name> [variation]
#   ./solid_spacal.pl solid_spacal_proto3            # variation Original
#   ./solid_spacal.pl solid_spacal_proto3 mini       # 1 sector, 1 tower, 6x4 fibers

use lib ("$ENV{GEMC}/io");
use lib ("$ENV{GEMC}/api/perl");
use parameters;
use utils;
use geometry;
use materials;
use hit;
use bank;

sub help()
{
	print "\n Usage: \n";
	print "   solid_spacal.pl <detector name> [variation]\n\n";
	exit;
}

if( scalar @ARGV < 1 || scalar @ARGV > 2) { help(); }

my $config_file   = "config.dat";
our %configuration = load_configuration($config_file);
$configuration{"detector_name"} = "$ARGV[0]";
$configuration{"variation"}     = (scalar @ARGV == 2) ? "$ARGV[1]" : "Original";

our %parameters = get_parameters(%configuration);
our $DetectorName = $ARGV[0];
print "DetectorName $DetectorName variation $configuration{'variation'}\n";

require "./solid_spacal_materials.pl";
require "./solid_spacal_geometry.pl";
require "./solid_spacal_hit.pl";
require "./solid_spacal_bank.pl";

solid_spacal_materials();
solid_spacal_geometry();
solid_spacal_hit();
solid_spacal_bank();
