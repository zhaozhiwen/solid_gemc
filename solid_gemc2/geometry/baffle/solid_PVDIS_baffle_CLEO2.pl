#!/usr/bin/perl -w

use strict;
use lib ("$ENV{GEMC}/io");
use parameters;
use utils;

use geometry;
use hit;
use bank;
use math;

use Math::Trig;
# use Math::MatrixReal;
# use Math::VectorReal;

# system("rm meic_det1_simple__*txt");

# Help Message
sub help()
{
	print "\n Usage: \n";
	print "   detector.pl <configuration filename>\n";
 	print "   Will create the detector\n";
 	print "   Note: The passport and .visa files must be present to connect to MYSQL. \n\n";
	exit;
}

# Make sure the argument list is correct
if( scalar @ARGV != 1) 
{
	help();
	exit;
}


# Loading configuration file and parameters
my $config_file   = $ARGV[0];
our %configuration = load_configuration($config_file);

# One can change the "variation" here if one is desired different from the config.dat
$configuration{"detector_name"} = "solid_PVDIS_baffle_CLEO2";
$configuration{"variation"} = "Original";

# To get the parameters proper authentication is needed.
our %parameters    = get_parameters(%configuration);

require "solid_PVDIS_baffle_CLEO2_geometry.pl";
require "solid_PVDIS_baffle_CLEO2_shldPOLY_geometry.pl";
require "solid_PVDIS_baffle_CLEO2_photonblock.pl";

solid_PVDIS_baffle_CLEO2_geometry("Original");
solid_PVDIS_baffle_CLEO2_shldPOLY_geometry("Original");
solid_PVDIS_baffle_CLEO2_photonblock("Original");
solid_PVDIS_baffle_CLEO2_geometry("Kill");
solid_PVDIS_baffle_CLEO2_shldPOLY_geometry("Kill");
solid_PVDIS_baffle_CLEO2_photonblock("Kill");
solid_PVDIS_baffle_CLEO2_geometry("Enclosure");
solid_PVDIS_baffle_CLEO2_shldPOLY_geometry("Enclosure");
solid_PVDIS_baffle_CLEO2_photonblock("Enclosure");
solid_PVDIS_baffle_CLEO2_geometry("EnclosureKill");
solid_PVDIS_baffle_CLEO2_shldPOLY_geometry("EnclosureKill");
solid_PVDIS_baffle_CLEO2_photonblock("EnclosureKill");

#materials definition 
require "solid_PVDIS_baffle_materials.pl";
define_material("Original");
define_material("Enclosure");

#hit and bank definition Execute only when there are changes
#hit
#require "./solid_baffle_hit.pl";
#define_solid_baffle_hit();

# banks
#require "./solid_baffle_bank.pl";
#define_solid_baffle_bank();
