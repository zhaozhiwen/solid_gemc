#!/usr/bin/perl -w

# Perl Dependencies:  Math::VectorReal and Math::MatrixReal to build the Mirrors and do the neceissary rotations.  See www.cpan.org to obtain these modules.


# This file loads a configuration file and builds all the necessary components for the PVDIS or SIDIS Cherenkov detector.  Each component is run under a seperate perl script.  Note that the necissary variables are loaded from an external perl vile declared in the command line.  This is done to allow scripting and optimization of the geometry database.

#use strict;

my $lowEM = 0;
my $detPlane = 0;

print "starting new update\n";

use lib ("$ENV{GEMC}/io");
use parameters;
use utils;
use geometry;
use hit;
use bank;
use math;
use Math::MatrixReal;
use Math::VectorReal qw(:all);
use Getopt::Long;
use Math::Trig;

do 'common/my_vars.pl';  #sets the neccissary variable names
require 'common/common_functions.pl';  #rotations and mirror building functions.

#use 'configs/'.$ARGV[0];  #sets variable values for geometry;
if($#ARGV < 0){
    do 'configs/pvdis_CLEO_nominal.pl';
}else{
    do $ARGV[0];
}

#file settings:
if($DEBUG){
	our %configuration = load_configuration("configs/solid_lgc_DEBUG.config");
}else{
	if($use_pvdis){
		our %configuration = load_configuration("configs/solid_lgc_PVDIS.config");  #This is the configuration file that keeps track of database information.
	}else{
		our %configuration = load_configuration("configs/solid_lgc_SIDIS.config");
	}
}
#make geometry:
require 'geometries/build_world_and_tank.pl';
require 'geometries/build_pmts.pl';
require 'geometries/build_cones.pl';
require 'geometries/build_mirror1.pl';
require 'geometries/build_mirror2.pl';
require 'geometries/build_mirror3.pl';
require 'geometries/build_support.pl';
require 'geometries/build_blinder.pl';
# make_mother();

#note: lowEM files not on repo yet -- MP: 01/20/16
if($lowEM){
    require 'lowEM/solid_CLEO_PVDIS_baffle_inspection.pl';
    make_baffle_plate_inner();
    make_baffle_plate_outer();
#    make_baffle_plate();
    make_baffle_blocks();
    require 'lowEM/solid_CLEO_PVDIS_beamline.pl';
    make_beam_entrance();
    make_beam_exit();
    require 'lowEM/solid_CLEO_solenoid.pl';
    make_coil_yoke();
    make_cryostat();
    require 'lowEM/solid_CLEO_PVDIS_target.pl'; 
    make_target_PVDIS_target();
    require 'lowEM/solid_CLEO_PVDIS_absorber.pl';
    make_absorber_forwarangle_1();
    make_absorber_forwarangle_2();
}

if($detPlane){
    require 'build_detPlane.pl';
    makeDetPlanes();
}

#start building the pieces:

if($buildTank){
    if($use_CLEO){
	make_tank_CLEO_pvdis();
	if(!$use_pvdis){
	    make_tank_CLEO_sidis();
	}else{
	    make_tank_CLEO_frontwindow();
	}
    }else{
	make_tank_BaBar_pvdis();
    }
}
if($buildPMTs){
    makePMTs();
}
if($buildCones){
    makeCones();
}
if($buildM1){
    make_mirror1();
}
if($buildM2){
    make_mirror2();
}
if($buildM3){
    make_mirror3();
}
if($buildSupport){
    makeSupport();
}

if($use_pvdis){
 if($buildBaffle){
    make_baffle_plate_inner();
    make_baffle_plate_outer();
    make_baffle_blocks();
 }
}
if($buildBlinders){
	make_blinder();
}

if($use_pvdis){
require "geometries/solid_PVDIS_lgc_virtualplane.pl";
solid_PVDIS_lgc_virtualplane();
}
else {
require "geometries/solid_SIDIS_lgc_virtualplane.pl";
solid_SIDIS_lgc_virtualplane();
}
require 'solid_lgc_mirror.pl';
require 'solid_lgc_OptMats.pl';
require 'solid_lgc_bank.pl';
require 'solid_lgc_hit.pl';
