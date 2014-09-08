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
$configuration{"detector_name"} = "solid_SIDIS_He3_simple";
$configuration{"variation"} = "Original";

# To get the parameters proper authentication is needed.
# our %parameters    = get_parameters(%configuration);
# $configuration{"detector_name"} = "solid_SIDIS";

#Geometry definition
require "solid_solenoid_kill.pl";
solid_solenoid_kill();
require "solid_SIDIS_target_He3_collimator_kill.pl";
solid_SIDIS_target_He3_collimator_kill();
require "solid_SIDIS_absorber.pl";
solid_SIDIS_absorber();
require "solid_SIDIS_ec_forwardangle_kill.pl";
solid_SIDIS_ec_forwardangle_kill();
require "solid_SIDIS_ec_largeangle_kill.pl";
solid_SIDIS_ec_largeangle_kill();
require "solid_SIDIS_virtualplane_cher.pl";
solid_SIDIS_virtualplane_cher();
require "solid_SIDIS_virtualplane_ec.pl";
solid_SIDIS_virtualplane_ec();
require "solid_SIDIS_virtualplane_gem.pl";
solid_SIDIS_virtualplane_gem();
require "solid_SIDIS_virtualplane_mrpc.pl";
solid_SIDIS_virtualplane_mrpc();
require "solid_SIDIS_virtualplane_spd.pl";
solid_SIDIS_virtualplane_spd();

# Hit definition
# Execute only when there are changes
# require "./meic_det1_hit.pl";
# flux_hit();

# banks
# require "./meic_det1_bank.pl";
# define_flux_bank();