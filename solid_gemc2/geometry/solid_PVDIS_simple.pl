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


# Loading configuration file and paramters
my $config_file   = $ARGV[0];
our %configuration = load_configuration($config_file);

#if($#ARGV < 0){
#    do 'configs/pvdis_CLEO_nominal.pl';
#}else{
#    do 'configs/'.$ARGV[0];
#}

# One can change the "variation" here if one is desired different from the config.dat
$configuration{"detector_name"} = "solid_CLEO_PVDIS_simple";
$configuration{"variation"} = "Original";

# To get the parameters proper authentication is needed.
# our %parameters    = get_parameters(%configuration);
# $configuration{"detector_name"} = "solid_CLEO_PVDIS";

#Geometry definition
require "solid_CLEO_solenoid_kill.pl";
solid_CLEO_solenoid_kill();
require "solid_CLEO_PVDIS_baffle_babarbafflemore1_kill.pl";
solid_CLEO_PVDIS_baffle_babarbafflemore1_kill();
require "solid_CLEO_PVDIS_ec_forwardangle_block_kill.pl";
solid_CLEO_PVDIS_ec_forwardangle_block_kill();
require "solid_CLEO_PVDIS_ec_forwardangle_kill.pl";
solid_CLEO_PVDIS_ec_forwardangle_kill();
require "solid_CLEO_PVDIS_virtualplane_cher.pl";
solid_CLEO_PVDIS_virtualplane_cher();
require "solid_CLEO_PVDIS_virtualplane_ec.pl";
solid_CLEO_PVDIS_virtualplane_ec();
require "solid_CLEO_PVDIS_virtualplane_gem.pl";
solid_CLEO_PVDIS_virtualplane_gem();

# Hit definition
# Execute only when there are changes
# require "./meic_det1_hit.pl";
# flux_hit();

# banks
# require "./meic_det1_bank.pl";
# define_flux_bank();