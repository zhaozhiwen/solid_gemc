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
$configuration{"detector_name"} = "solid_SIDIS_ec_forwardangle";
$configuration{"variation"} = "Original";

# To get the parameters proper authentication is needed.
our %parameters    = get_parameters(%configuration);
# $configuration{"detector_name"} = "solid_PVDIS";

#Geometry definition
# require "solid_solenoid.pl";
# solid_solenoid();
# require "solid_PVDIS_baffle_babarbafflemore1.pl";
# solid_PVDIS_baffle_babarbafflemore1();
# require "solid_PVDIS_target_LD2.pl";
# solid_PVDIS_target_LD2();
# require "solid_PVDIS_baffle_babarbafflemore1_enclosure.pl";
# solid_PVDIS_baffle_babarbafflemore1_enclosure();
# require "solid_PVDIS_target_LD2_enclosure.pl";
# solid_PVDIS_target_LD2_enclosure();
# require "solid_PVDIS_beamline.pl";
# solid_PVDIS_beamline();
# require "solid_PVDIS_cherenkov.pl";
# solid_PVDIS_cherenkov();
# require "solid_PVDIS_ec_forwardangle_block.pl";
# solid_PVDIS_ec_forwardangle_block();
require "solid_SIDIS_ec_forwardangle_geometry.pl";
solid_SIDIS_ec_forwardangle();
# require "solid_PVDIS_gem.pl";
# solid_PVDIS_gem();
# require "solid_PVDIS_virtualplane_cher.pl";
# solid_PVDIS_virtualplane_cher();
# require "solid_PVDIS_virtualplane_ec.pl";
# solid_PVDIS_virtualplane_ec();
# require "solid_PVDIS_virtualplane_gem.pl";
# solid_PVDIS_virtualplane_gem();

#materials definition 
require "./solid_ec_materials.pl";

#hit definition 
require "./solid_ec_hit.pl";

# bank definition
require "./solid_ec_bank.pl";
