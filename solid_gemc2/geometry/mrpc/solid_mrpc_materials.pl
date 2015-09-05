#!/usr/bin/perl -w
###################################################################
# This script defines all materials used in the SoLID simulation. #
# If a new material is added, please specify your name, date and  #
# the purpose of adding this. Please make sure all materials      #
# have their names started with SL_mrpc_*                              #
# 
# Note: G4_* are for materials, so use percentage
#       For components,like C9H10, use the element "C" but not "G4_C"                                
#                                                                 #
#  -- Zhihong Ye, yez@jlab.org, 06/12/2014                        # 
###################################################################

############
#Note:
# (0) Define your new material in the section it belongs to,
#     DO-NOT just simply add it to the end of the file. 
#     Put your name and date near where you define your new items.
# (1) Pay attention to the density unit, which should be g/cm3
# (2) For elements, they should be like "He","C", ...
#     For materials, they should be like "G4_He", "G4_C"
# (3) "SL_mrpc_NewMaterial" is the newly defined material for SoLID    
# (4) If the new material is composed of elements, 
#     use "integer" to define the number of elements,
#     e.g "H 2 O 1"
# (5) If the new material is mixers of other materials,
#     use "mass fraction" to define the components, 
#     e.g. "G4_Si 0.70 G4_O 0.30"       
# (6) When you define a new material mixed by other materials, 
#     pay attention to how they are mixed,
#     e.g. by "mass fraction" or by "mole fraction" or volumn etc.
#
 
use strict;
use lib ("$ENV{GEMC}/io");
use utils;
use materials;

# Help Message
sub help()
{
	print "\n Usage: \n";
	print "   this_script.pl <configuration filename>\n";
 	print "   Will create materials used in SoLID\n";
	exit;
}

# Make sure the argument list is correct
# If not pring the help
if( scalar @ARGV != 1)
{
	help();
	exit;
}

# Loading configuration file from argument
our %configuration = load_configuration($ARGV[0]);

sub define_material
{

	my %mat = init_mat();

	##############
	# Mylar
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_mrpc_MMMylar";
	$mat{"description"}   = "Mylar in MRPC";
	$mat{"density"}       = "1.400";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "G4_H 0.041958 G4_C 0.625017 G4_O 0.333025";
	print_mat(\%configuration, \%mat);
	##############
	# AlHoneycomb-- Components are not final determined yet--FIX_HERE
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_mrpc_AlHoneycomb";
	$mat{"description"}   = "AlHoneycomb in MRPC";
	$mat{"density"}       = "0.130";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_Al 1";#FIX_HERE What is AlMnCu?
#	$mat{"ncomponents"}   = "3";
#	$mat{"components"}    = "G4_Al 0.987 G4_Mn 0.01 G4_Gu 0.003";#What is AlMnCu?
	print_mat(\%configuration, \%mat);
	##############
	# AlHoneycomb2
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_mrpc_AlHoneycomb2";
	$mat{"description"}   = "denser AlHoneycomb";
	$mat{"density"}       = "1.000";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_Al 1";
	print_mat(\%configuration, \%mat);
	##############
	# PCB board
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_mrpc_PCBoardM";
	$mat{"description"}   = "PCB board in MRPC";
	$mat{"density"}       = "1.860";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "G4_C 0.4 G4_Si 0.3 G4_Fe 0.3";
	print_mat(\%configuration, \%mat);
				
	##############
	# MRPC_Gas 
	# 90% Freon (C2H2F4, 4.25mg/cm3) --> 86.59% in mass fraction
	# 5% Iso-Butane (C4H10, 2.51mg/cm3) --> 2.69% in mass fraction
	# 5% SF6 (SF6, 10mg/cm3 ) --> 10.72% in mass fraction
	%mat = init_mat();
	$mat{"name"}          = "SL_mrpc_Freon";
	$mat{"description"}   = "TetraFluoroEthane";
	$mat{"density"}       = "0.00425";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "C 2 H 2 F 4";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_mrpc_SF6";
	$mat{"description"}   = "Sulfur hexafluoride";
	$mat{"density"}       = "0.010";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "S 1 F 6";
	print_mat(\%configuration, \%mat);
		
	%mat = init_mat();
	$mat{"name"}          = "SL_mrpc_Gas";
	$mat{"description"}   = "Gas in MRPC";
	$mat{"density"}       = "0.00445";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "SL_mrpc_Freon 0.8659 SL_mrpc_SF6 0.0269 G4_BUTANE 0.1072";
	print_mat(\%configuration, \%mat);
}
define_material();


