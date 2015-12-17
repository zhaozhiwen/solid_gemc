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

	my %mat;

	##########
	#SIDIS He3 target 
    # - He3 + Glass_GE180 + Vacuum   
    #--He3 Gas at 10amg

# here is how it was implemented in geant3    
# GPARMED58  233 '3He 10 atm$         '  33  0  1  1. -1. -1.   -1.   0.1    -1. 
# GPARMXT05   33 '3He 10 atm $        ' 1.33E-3  -1      3.  2.  1.

# name mat sen F Fmx Fan stmx Elo epsi st(mu,lo) user words
# GPARMED62 264 'Glass GE 180 mf $' 64 0 1 30. -1. -1. -1. 0.01 -1.
# name g/cm3 Nmat A1 Z1 W1 A2 Z2 W2
# C Aluminosilicate glass SiO2 57%, Al2O3 20%, MgO 12%, CaO 5%, B2O3 4%, Na2O 1%
# GPARMXT08 64 'Glass al-sil GE180$' 2.76 7 16. 8. 0.524 28.1 14. 0.266 27. 13. 0.072 24.3 12. 0.072 
#                                             40. 20. 0.036 11. 5. 0.013 23. 11. 0.007
    
	%mat = init_mat();
	$mat{"name"}          = "SL_target_He3_He3_10amg";
	$mat{"description"}   = "SIDIS He3 gas target at 10amg";
	$mat{"density"}       = "0.001345";  #in g/cm3,10amg, 10*44.6(amg=mol/m3)*3.016(g/mol)=1.345e-3g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "helium3Gas 1";#FIX_HERE: GEMC2 still cannot handel Isotopes externally,still defined in material_factory.cc
	#somehow SL_target_He3_He3_10amg doesn't work for GEMC 2.2, but work for GEMC 2.1, it could be related to isotope helium3 and helium3Gas in GEMC source code materials/material_factory.cc, I don't see what's difference between 2.1 and 2.2	
	print_mat(\%configuration, \%mat);

	#--Glass_GE180
	# SilicOxide-60.8%,BariumOxide-18.2%,AluminiumOxide,14.3%,
	# CalciumOxide 6.5%,StrontiumOxide 0.25%
	# refer to http://galileo.phys.virginia.edu/research/groups/spinphysics/glass_properties.html
	%mat = init_mat();
	$mat{"name"}          = "SL_target_He3_BaO";
	$mat{"description"}   = "BariumOxide in SIDIS He3 target cell";
	$mat{"density"}       = "5.720";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "Ba 1 O 1";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_target_He3_SrO";
	$mat{"description"}   = "StrontiumOxide in SIDIS He3 target cell";
	$mat{"density"}       = "4.700";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "Sr 1 O 1";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_target_He3_Glass_GE180";
	$mat{"description"}   = "SIDIS He3 target cell";
	$mat{"density"}       = "2.760";  #in g/cm3
	$mat{"ncomponents"}   = "5";
	$mat{"components"}    = "G4_SILICON_DIOXIDE 0.608 G4_ALUMINUM_OXIDE 0.143 G4_CALCIUM_OXIDE 0.065 SL_target_He3_BaO 0.182 SL_target_He3_SrO 0.002";
	print_mat(\%configuration, \%mat);
	
}
define_material();


