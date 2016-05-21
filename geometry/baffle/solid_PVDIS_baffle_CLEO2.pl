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
solid_PVDIS_baffle_CLEO2_geometry("Original");
# require "solid_PVDIS_baffle_babarbafflemore1_photonblock.pl";
# solid_PVDIS_baffle_babarbafflemore1_photonblock();
solid_PVDIS_baffle_CLEO2_geometry("Kill");
# require "solid_PVDIS_baffle_babarbafflemore1_photonblock_kill.pl";
# solid_PVDIS_baffle_babarbafflemore1_photonblock_kill();
solid_PVDIS_baffle_CLEO2_geometry("Enclosure");
# require "solid_PVDIS_baffle_babarbafflemore1_photonblock.pl";
# solid_PVDIS_baffle_babarbafflemore1_photonblock();
solid_PVDIS_baffle_CLEO2_geometry("EnclosureKill");
# require "solid_PVDIS_baffle_babarbafflemore1_photonblock_kill.pl";
# solid_PVDIS_baffle_babarbafflemore1_photonblock_kill();

#hit and bank definition Execute only when there are changes
#hit
#require "./solid_baffle_hit.pl";
#define_solid_baffle_hit();

# banks
#require "./solid_baffle_bank.pl";
#define_solid_baffle_bank();
