#!/usr/bin/perl -w
###################################################################
# This script defines all materials used in the SoLID simulation. #
# If a new material is added, please specify your name, date and  #
# the purpose of adding this. Please make sure all materials      #
# have their names started with SL_*                              #
# 
# Note: G4_* are for materials, so use percentage
#       For components,like C9H10, use the element "C" but not "G4_C"                                
#                                                                 #
#  -- Zhihong Ye, yez@jlab.org, 06/12/2014                        # 
###################################################################

use strict;
use lib ("$ENV{GEMC}/io");
use utils;
use materials;

# Help Message
sub help()
{
	print "\n Usage: \n";
	print "   SoLID_Materials.pl <configuration filename>\n";
 	print "   Will create new materials used in SoLID\n";
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

##########################
# General Materials
##########################
    #The Vacuum defined inside G4 is G4_Galactic
	#Prepare a realistic vacuum since we cannot obtain actual vacuum
	#but low presure environment,eg. in beamline
	my %mat = init_mat();
	$mat{"name"}          = "SL_Vacuum";
	$mat{"description"}   = "Vacuum in the beamline and target chamber";
	$mat{"density"}       = "0.00000000000000168";  # in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "G4_N 0.7 G4_O 0.3";
	print_mat(\%configuration, \%mat);

   	#########################
	#Lead Tungsten
	#
#	%mat = init_mat();
#	$mat{"name"}          = "SL_LeadTungsten";
#	$mat{"description"}   = "Lead Tungsten";
#	$mat{"density"}       = "8.28";  #in g/cm3
#	$mat{"ncomponents"}   = "3";
#	$mat{"components"}    = "G4_Pb 1 G4_W 1 G4_O 4";
#	print_mat(\%configuration, \%mat);

	##############
	#Kapton
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_Kapton";
	$mat{"description"}   = "Kapton";
	$mat{"density"}       = "1.420";  #in g/cm3
	$mat{"ncomponents"}   = "4";
	$mat{"components"}    = "G4_H 0.026362 G4_C 0.691133 G4_N 0.07327 G4_O 0.209235";
	print_mat(\%configuration, \%mat);


	###################
    #He4 
	#
	#1atm
	%mat = init_mat();
	$mat{"name"}          = "SL_He4_1atm";
	$mat{"description"}   = "He4 gas at 1atm";
	$mat{"density"}       = "0.0001786";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_He 1";
	print_mat(\%configuration, \%mat);
	#2atm
	%mat = init_mat();
	$mat{"name"}          = "SL_He4_2atm";
	$mat{"description"}   = "He4 gas at 2atm";
	$mat{"density"}       = "0.0003572";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_He 1";
	print_mat(\%configuration, \%mat);
	#3atm
	%mat = init_mat();
	$mat{"name"}          = "SL_He4_3atm";
	$mat{"description"}   = "He4 gas at 3atm";
	$mat{"density"}       = "0.0005358";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_He 1";
	print_mat(\%configuration, \%mat);
	#7atm
	%mat = init_mat();
	$mat{"name"}          = "SL_He4_7atm";
	$mat{"description"}   = "He4 gas at 7atm";
	$mat{"density"}       = "0.0012502";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_He 1";
	print_mat(\%configuration, \%mat);

##########################
# Beamline Section 
##########################

##########################
# Target Section 
##########################
	##########
	# PVDIS LD2 target
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_LD2";
	$mat{"description"}   = "PVDIS LD2 target";
	$mat{"density"}       = "0.169";  # in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "LD 1"; #FIX_HERE: GEMC2 still cannot handel Isotopes externally,still defined in material_factory.cc
	print_mat(\%configuration, \%mat);
	
	##########
	#SIDIS He3 target 
    # - He3 + Glass_GE180 + Vacuum   
	   	
    #--He3 Gas at 10amg
	%mat = init_mat();
	$mat{"name"}          = "SL_He3_10amg";
	$mat{"description"}   = "SIDIS He3 target at 10amg";
	$mat{"density"}       = "0.001345";  #in g/cm3,10amg, 10*44.6(amg=mol/m3)*3.016(g/mol)=1.345e-3g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "helium3Gas 1";#FIX_HERE: GEMC2 still cannot handel Isotopes externally,still defined in material_factory.cc
	print_mat(\%configuration, \%mat);

	#--Glass_GE180
	# SilicOxide-60.8%,BariumOxide-18.2%,AluminiumOxide,14.3%,
	# CalciumOxide 6.5%,StrontiumOxide 0.25%
	%mat = init_mat();
	$mat{"name"}          = "SL_BaO";
	$mat{"description"}   = "BariumOxide in SIDIS He3 target cell";
	$mat{"density"}       = "5.720";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "Ba 1 O 1";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_SrO";
	$mat{"description"}   = "StrontiumOxide in SIDIS He3 target cell";
	$mat{"density"}       = "4.700";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "Sr 1 O 1";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_Glass_GE180";
	$mat{"description"}   = "SIDIS He3 target cell";
	$mat{"density"}       = "2.760";  #in g/cm3
	$mat{"ncomponents"}   = "5";
	$mat{"components"}    = "G4_SILICON_DIOXIDE 0.608 G4_ALUMINUM_OXIDE 0.143 G4_CALCIUM_OXIDE 0.065 SL_BaO 0.182 SL_SrO 0.002";
	print_mat(\%configuration, \%mat);

	#pol proton target 
	# - NH3 + He4
	%mat = init_mat();
	$mat{"name"}          = "SL_NH3_solid";
	$mat{"description"}   = "NH3 target NH3_solid";
	$mat{"density"}       = "0.817";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "H 3 N 1";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_He4_liquid";
	$mat{"description"}   = "NH3 target He4_liquid";
	$mat{"density"}       = "0.145";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_He 1";
	print_mat(\%configuration, \%mat);
	
	%mat = init_mat();
	$mat{"name"}          = "SL_NH3He";
	$mat{"description"}   = "NH3 target NH3He";
	$mat{"density"}       = "0.515";  #in g/cm3,(0.817*0.55+0.145*0.45)=0.515 
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "SL_NH3_solid 0.8732 SL_He4_liquid 0.1268";
	print_mat(\%configuration, \%mat);	
	
##########################
# Solenoid Section 
##########################
 ##############
 #Stainless Steel
 #Mn 2%,Cr 19%, Ni 10%, G4_Si 1%, G4_Fe 68%
 	%mat = init_mat();
	$mat{"name"}          = "SL_StainlessSteel";
	$mat{"description"}   = "StainlessSteel in Solenoid";
	$mat{"density"}       = "8.020";  #in g/cm3
	$mat{"ncomponents"}   = "5";
	$mat{"components"}    = "G4_Si 0.01 G4_Fe 0.68 G4_Mn 0.02 G4_Cr 0.19 G4_Ni 0.10";
	print_mat(\%configuration, \%mat);

	
##########################
# GEM Section 
##########################
	##############
	#GEM gas--basically ArCO2
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_CO2";
	$mat{"description"}   = "CO2 mixed in GEM gas";
	$mat{"density"}       = "0.001977";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "C 1 O 2";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_Argon";
	$mat{"description"}   = "Argon mixed in GEM gas";
	$mat{"density"}       = "0.0017823";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_Ar 1";
	print_mat(\%configuration, \%mat);
		
#note		
# 	G4double density_ArCO2 = .7*density_Ar + .3*density_CO2;
# 	G4Material *ArCO2 = new G4Material("GEMgas", density_ArCO2, nel=2);
# 	ArCO2->AddMaterial(Argon, 0.7*density_Ar/density_ArCO2) ;
# 	ArCO2->AddMaterial(CO2, 0.3*density_CO2/density_ArCO2) ;		
	%mat = init_mat();
	$mat{"name"}          = "SL_GEMgas";
	$mat{"description"}   = "GEM gas";
	$mat{"density"}       = "0.0018407";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "SL_CO2 0.32 SL_Argon 0.68";
	print_mat(\%configuration, \%mat);

 
	##############
	#NEMAG10
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_NEMAG10";
	$mat{"description"}   = "NEMA G10 in GEM";
	$mat{"density"}       = "1.700";  #in g/cm3
	$mat{"ncomponents"}   = "4";
	$mat{"components"}    = "Si 1 O 2 C 3 H 3";
	print_mat(\%configuration, \%mat);

	##############
	#NOMEX
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_NOMEX_pure";
	$mat{"description"}   = "pure NOMEX";
	$mat{"density"}       = "1.380";  #in g/cm3
	$mat{"ncomponents"}   = "5";
	$mat{"components"}    = "G4_H 0.04 G4_C 0.54 G4_N 0.09 G4_O 0.10 G4_Cl 0.23";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_NOMEX";
	$mat{"description"}   = "NOMEX mixed with air in GEM";
	$mat{"density"}       = "0.040";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "G4_AIR 0.55 SL_NOMEX_pure 0.45";
	print_mat(\%configuration, \%mat);
	

##########################
# EC Section 
##########################
	##############
	#LgTF1, Lead-Glass for EC
	# LeadOxide 51.20%, SilicOxide 41.3%, PotasOxide 4.22%, SodMonOxide 2.78%, As203 0.5%
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_As2O3";
	$mat{"description"}   = "As2O3 in EC";
	$mat{"density"}       = "3.738";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "As 2 O 3";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_LgTF1";
	$mat{"description"}   = "LeadGlass LgTF1 in EC";
	$mat{"density"}       = "3.860";  #in g/cm3
	$mat{"ncomponents"}   = "5";
	$mat{"components"}    = "G4_LEAD_OXIDE 0.5120 G4_SILICON_DIOXIDE 0.4130 G4_POTASSIUM_OXIDE 0.0422 G4_SODIUM_MONOXIDE 0.0278 SL_As2O3 0.0050";
	print_mat(\%configuration, \%mat);


##########################
# LGC Section 
##########################
	##############
	#CCGas, Light Gas Cherenkov  
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_CCGas";
	$mat{"description"}   = "Gas in LGC";
	$mat{"density"}       = "0.01012";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "G4_F 0.7 G4_C 0.3";
	print_mat(\%configuration, \%mat);

##########################
# HGC Section 
##########################


##########################
# MRPC Section 
##########################
	##############
	# Mylar
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_MMMylar";
	$mat{"description"}   = "Mylar in MRPC";
	$mat{"density"}       = "1.400";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "G4_H 0.041958 G4_C 0.625017 G4_O 0.333025";
	print_mat(\%configuration, \%mat);
	##############
	# AlHoneycomb-- Components are not final determined yet--FIX_HERE
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_AlHoneycomb";
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
	$mat{"name"}          = "SL_AlHoneycomb2";
	$mat{"description"}   = "denser AlHoneycomb";
	$mat{"density"}       = "1.000";  #in g/cm3
	$mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_Al 1";
	print_mat(\%configuration, \%mat);
	##############
	# PCB board
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_PCBoardM";
	$mat{"description"}   = "PCB board in MRPC";
	$mat{"density"}       = "1.860";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "G4_C 0.4 G4_Si 0.3 G4_Fe 0.3";
	print_mat(\%configuration, \%mat);
				
	##############
	# MRPC_Gas 
	# 90% Freon (C2H2F4, 4.25mg/cm3)
	# 5% Iso-Butane (C4H10, 2.51mg/cm3)
	# 5% SF6 (SF6, 10mg/cm3 )
	%mat = init_mat();
	$mat{"name"}          = "SL_Freon";
	$mat{"description"}   = "TetraFluoroEthane";#use GEM gas temp
	$mat{"density"}       = "0.00425";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "C 2 H 2 F 4";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_SF6";
	$mat{"description"}   = "";#use GEM gas temp
	$mat{"density"}       = "0.010";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "S 1 F 6";
	print_mat(\%configuration, \%mat);
		
	%mat = init_mat();
	$mat{"name"}          = "SL_MRPC_Gas";
	$mat{"description"}   = "Gas in MRPC";#use GEM gas temp
	$mat{"density"}       = "0.00445";  #in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "SL_Freon 0.90 SL_SF6 0.05 G4_BUTANE 0.05";
	print_mat(\%configuration, \%mat);
	
##########################
# SPD Section 
##########################
	##############
	#ScintillatorB
	#
	%mat = init_mat();
	$mat{"name"}          = "SL_ScintillatorB";
	$mat{"description"}   = "Scintillator for SPD";
	$mat{"density"}       = "1.032";  #in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "H 10 C 9";
	print_mat(\%configuration, \%mat);
	#questions: How to set: ScintillatorB->GetIonisation()->SetBirksConstant(0.126*mm/MeV);
 

##########################
# Baffle Section 
##########################



##################
# The end
##################
}
define_material();


