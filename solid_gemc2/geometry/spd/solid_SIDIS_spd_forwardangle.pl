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
$configuration{"detector_name"} = "solid_SIDIS_spd_forwardangle";
$configuration{"variation"} = "Original";

# To get the parameters proper authentication is needed.
our %parameters    = get_parameters(%configuration);
# $configuration{"detector_name"} = "solid_PVDIS";

#Geometry definition
require "solid_SIDIS_spd_forwardangle_geometry.pl";
solid_SIDIS_spd_forwardangle();
require "solid_SIDIS_spd_forwardangle_virtualplane.pl";
solid_SIDIS_spd_forwardangle_virtualplane();

#materials definition 
require "./solid_spd_materials.pl";

#hit definition 
require "./solid_spd_hit.pl";

# bank definition
require "./solid_spd_bank.pl";
