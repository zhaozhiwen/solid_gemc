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

############
#Note:
# (0) Define your new material in the section it belongs to,
#     DO-NOT just simply add it to the end of the file. 
#     Put your name and date near where you define your new items.
# (1) Pay attention to the density unit, which should be g/cm3
# (2) For elements, they should be like "He","C", ...
#     For materials, they should be like "G4_He", "G4_C"
# (3) "SL_NewMaterial" is the newly defined material for SoLID    
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
	print "   materials.pl <configuration filename>\n";
 	print "   Will create a simple scintillator material\n";
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

# One can change the "variation" here if one is desired different from the config.dat
# $configuration{"variation"} = "myvar";


# Photon energy bins
my @PhotonEnergyBin = ( "2.034*eV", "2.068*eV", "2.103*eV", "2.139*eV",
       	        	"2.177*eV", "2.216*eV", "2.256*eV", "2.298*eV",
                	"2.341*eV", "2.386*eV", "2.433*eV", "2.481*eV",
                	"2.532*eV", "2.585*eV", "2.640*eV", "2.697*eV",
                	"2.757*eV", "2.820*eV", "2.885*eV", "2.954*eV",
                	"3.026*eV", "3.102*eV", "3.181*eV", "3.265*eV",
                	"3.353*eV", "3.446*eV", "3.545*eV", "3.649*eV",
                	"3.760*eV", "3.877*eV", "4.002*eV", "4.136*eV" );

# Table of optical properties for aerogel
my @AgelRefrIndex = ( 1.02435, 1.0244,  1.02445, 1.0245,  1.02455,
              	      1.0246,  1.02465, 1.0247,  1.02475, 1.0248,
              	      1.02485, 1.02492, 1.025,   1.02505, 1.0251,
             	      1.02518, 1.02522, 1.02530, 1.02535, 1.0254,
              	      1.02545, 1.0255,  1.02555, 1.0256,  1.02568,
               	      1.02572, 1.0258,  1.02585, 1.0259,  1.02595,
              	      1.026,   1.02608 );

my @AgelAbsLength = ( "3.448*m",  "4.082*m",  "6.329*m",  "9.174*m",
		      "12.346*m", "13.889*m", "15.152*m", "17.241*m",
		      "18.868*m", "20.000*m", "26.316*m", "35.714*m",
		      "45.455*m", "47.619*m", "52.632*m", "52.632*m",
	  	      "55.556*m", "52.632*m", "52.632*m", "47.619*m",
		      "45.455*m", "41.667*m", "37.037*m", "33.333*m",
		      "30.000*m", "28.500*m", "27.000*m", "24.500*m",
		      "22.000*m", "19.500*m", "17.500*m", "14.500*m" );

# Table of optical properties for lens Acrylic
my @AcRefrIndex = ( 1.4902, 1.4907, 1.4913, 1.4918, 1.4924,
                  1.4930,  1.4936,  1.4942,  1.4948,  1.4954,
                  1.4960,  1.4965,  1.4971,  1.4977,  1.4983,
                  1.4991,  1.5002,  1.5017,  1.5017,  1.5017,
                  1.5017,  1.5017,  1.5017,  1.5017,  1.5017,
                  1.5017,  1.5017,  1.5017,  1.5017,  1.5017,
                  1.5017,  1.5017 );

my @AcAbsLength = (  "00.448*cm", "00.082*cm", "00.329*cm", "00.174*cm",
		     "00.346*cm", "00.889*cm", "00.152*cm", "00.241*cm",
		     "00.868*cm", "00.000*cm", "00.316*cm", "00.714*cm",
                     "00.455*cm", "00.619*cm", "00.632*cm", "00.632*cm",
		     "00.556*cm", "00.632*cm", "00.632*cm", "00.619*cm",
		     "00.455*cm", "00.667*cm", "00.037*cm", "00.333*cm",
                     "00.001*cm", "00.001*cm", "00.001*cm", "00.001*cm",
		     "00.001*cm", "00.001*cm", "00.001*cm", "00.001*cm" ); 

my @PhotonEnergy = (
"2.04358*eV","2.0664*eV","2.09046*eV","2.14023*eV",
"2.16601*eV","2.20587*eV","2.23327*eV","2.26137*eV",
"2.31972*eV","2.35005*eV","2.38116*eV","2.41313*eV",
"2.44598*eV","2.47968*eV","2.53081*eV","2.58354*eV",
"2.6194*eV","2.69589*eV","2.73515*eV","2.79685*eV",
"2.86139*eV","2.95271*eV","3.04884*eV","3.12665*eV",
"3.2393*eV","3.39218*eV","3.52508*eV","3.66893*eV",
"3.82396*eV","3.99949*eV","4.13281*eV","4.27679*eV",
"4.48244*eV","4.65057*eV","4.89476*eV","5.02774*eV",
"5.16816*eV","5.31437*eV","5.63821*eV","5.90401*eV",
"6.19921*eV"
);
  
my @RefractiveIndex_C4F8O = (1.00205, 1.00205, 1.00205, 1.00206,
                                              1.00206, 1.00206, 1.00206, 1.00206,
                                              1.00206, 1.00206, 1.00206, 1.00207,
                                              1.00207, 1.00207, 1.00207, 1.00207,
                                              1.00207, 1.00208, 1.00208, 1.00208,
                                              1.00209, 1.00209, 1.00209, 1.0021,
                                              1.00211, 1.00211, 1.00212, 1.00213,
                                              1.00214, 1.00215, 1.00216, 1.00217,
                                              1.00219, 1.0022, 1.00222, 1.00223,
                                              1.00224, 1.00225, 1.00228, 1.00231,
                                              1.00234);  


sub define_materials
{
	my %mat;
	
# 	Aerogel
	%mat = init_mat();
	$mat{"name"}          = "SL_HGC_aerogel";
	$mat{"description"}   = "aerogel material";
	$mat{"density"}       = "0.02";  # in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "Si 1 O 2";
	$mat{"photonEnergy"}      = arrayToString(@PhotonEnergyBin);
	$mat{"indexOfRefraction"} = arrayToString(@AgelRefrIndex);
	$mat{"absorptionLength"}  = arrayToString(@AgelAbsLength);
	print_mat(\%configuration, \%mat);

# 	Lens Acrylic
	%mat = init_mat();
	$mat{"name"}          = "SL_HGC_acrylic";
	$mat{"description"}   = "lens material";
	$mat{"density"}       = "1.19";  # in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "C 5 H 8 O 2";
	$mat{"photonEnergy"}      = arrayToString(@PhotonEnergyBin);
	$mat{"indexOfRefraction"} = arrayToString(@AcRefrIndex);
	$mat{"absorptionLength"}  = arrayToString(@AcAbsLength);
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_HGC_C4F8O";
	$mat{"description"}   = "SL_HGC_C4F8O";
	$mat{"density"}       = "13.47255e-3";  # in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "C 4 F 8 O 1";
	$mat{"photonEnergy"}      = arrayToString(@PhotonEnergy);
	$mat{"indexOfRefraction"} = arrayToString(@RefractiveIndex_C4F8O);
# 	$mat{"absorptionLength"}  = arrayToString(@AgelAbsLength);	
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_HGC_mylar";
	$mat{"description"}   = "SL_HGC_mylar";
	$mat{"density"}       = "1.397";  # in g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "G4_H 0.042 G4_C 0.625 G4_O 0.333";
	print_mat(\%configuration, \%mat);	

	%mat = init_mat();
	$mat{"name"}          = "SL_HGC_kevlar";
	$mat{"description"}   = "SL_HGC_kevlar";
	$mat{"density"}       = "1.44";  # in g/cm3
	$mat{"ncomponents"}   = "4";
	$mat{"components"}    = "G4_H 0.04 G4_C 0.71 G4_O 0.12 G4_N 0.13";
	print_mat(\%configuration, \%mat);
	
	%mat = init_mat();
	$mat{"name"}          = "SL_HGC_pmt_surface";
	$mat{"description"}   = "SL_HGC_pmt_surface";
	$mat{"density"}       = "1.032";  # in g/cm3
	$mat{"ncomponents"}   = "2";
	$mat{"components"}    = "G4_C 0.91533 G4_H 0.08467";
	print_mat(\%configuration, \%mat);	
	
    #Carbon-fiber¨Reinforced polymer composition for mirrors
    %mat = init_mat();
    $mat{"name"}          = "SL_HGC_CFRP";
    $mat{"description"}   = "Carbon-fiber¨Reinforced polymer";
    $mat{"density"}       = "1.8";  #in g/cm3
    $mat{"ncomponents"}   = "4";
    $mat{"components"}    = "G4_C 0.42 G4_N 0.17 G4_O 0.08 G4_H 0.33";	
    print_mat(\%configuration, \%mat);	

}

define_materials();
