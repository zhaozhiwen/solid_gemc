#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_cherenkov_lightgas';

my $DetectorMother="root";

sub solid_SIDIS_cherenkov_lightgas
{
make_frontchamber();
make_frontchamber_window_front();
make_frontchamber_window_back();
make_backchamber();
make_backchamber_window_front();
make_backchamber_window_back();
# make_lg_lightout();
}

# C --- Gas Cherenkov
# C
# 
# GPARVOL67  'AEOO'  235  'SOLE'      0.    0.   367.   0 'CONE'  5   10.    103.   191.  108.   197.   
# GPARVOL68  'AEO1'  240  'AEOO'      0.    0.    0.    0 'CONE'  5   9.8    102.6  190.6 107.6. 196.6 
# 
# GPARVOL69  'CHRV'  235  'SOLE'      0.    0.   332.   0  'CONE'  5   25.    92.   178.  103.   191.
# GPARVOL70  'CHRG'  240  'CHRV'      0.    0.    0.   0  'CONE'  5   24.8   91.6  177.6 102.6  190.6
# 
# 
# PARVOL71  'CHRA'  828  'SOLE'    0.    0.    0.    0  'PCON'  12 0. 360. 3.  
# 	97. 62. 127.  200. 78. 142. 225. 82. 160. 
# PARVOL72  'CHRB'  235  'CHRA'    0.    0.    97.02    0  'TUBE'  3 62.1  126.9 0.02 
# PARVOL73  'CHRC'  828  'SOLE'    0.    0.    0.    0  'PCON'  15 0. 360. 4.
# 	209. 240. 257. 225. 190. 265. 225. 82. 265. 301. 90. 265.
# PARVOL74  'CHRD'  235  'SOLE'    0.    0.    300.98   0  'TUBE' 3  90.1  264.9 0.02
# 	     
# RMATR52    63.0    0.   90.  90.     117.0       0.
# PARVOL75 'CEDE'  828 'CHRC'    244.0   0.0  223.00      52  'BOX ' 3  15. 20. 4.0
# 
# 
# RMATR51    119.861    0.   90.  90.       60.1391     0.    
# PARVOL76 'CHM1'  860 'CHRC'    122.  0.0  -137.5  -1051  'ELLI'  8  454.  454.5  25.  39.  155. 205.  0.842046 0.842046
# PARVOL77 'CHM2'  860 'CHRC'    0.0   0.0   226.2      0  'CONE'  5  0.2   146. 195. 146. 195.
# PARVOL78 'CHM3'  860 'CHRC'    0.0   0.0   300.5       0  'CONE'  5  0.2   185. 250. 185. 250.
# 
# 
# GPARVOL79  'AEO2'  258  'AEO1'      0.    0.    0.    0 'CONE'  5   4.5    102.6  190.6 107.6. 196.6 
# 
# C Collimator for Gas Cherenkov PMT
# 
# GPARVOL80  'QCO1'  261  'CHRC'     0.   0.    233.    0  'CONE' 5   13. 212. 222.  200. 210.
# GPARVOL81  'QCO2'  261  'CHRC'     0.   0.    263.    0  'CONE' 5   20. 255. 262.  240. 250.
# GPARVOL82  'QCO3'  261  'SOLE'     0.   0.    307.    0  'CONE' 5   5. 203. 260.  205. 260.
# 
# C RMATR53    120.174    0.   90.  90.       59.8265     0.    
# C PARVOL79 'CHM4'  860 'CHRC'    125.   0.0   -135.  -1053  'ELLI'  8  461.5  462.  37.4  39.5  155. 205.  0.84272 0.84272

#Babar
# Z(97,200,225,301)
# Rin(62,78,82,90)
# Rout(127,142,160,265)

#CLEOv8
# Z(97,194,209,301)
# Rin(58,65,67,85)
# Rout(127,144,155,265)

my $material_gas="G4_CARBON_DIOXIDE";

sub make_frontchamber
{
  my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_frontchamber";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Polycone";
 $detector{"dimensions"}  = "0*deg 360*deg 2*counts 58*cm 65*cm 127*cm 144*cm 97*cm 194*cm";
 $detector{"material"}    = $material_gas;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}

sub make_frontchamber_window_front
{
  my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_frontchamber_window_front";
 $detector{"mother"}      = "$DetectorName\_frontchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 97.0025*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "58.1*cm 126.9*cm 0.0025*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_POLYVINYL_CHLORIDE"; #should be POLYVINYL fluride 1.45g/cm3
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}

sub make_frontchamber_window_back
{
  my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_frontchamber_window_back";
 $detector{"mother"}      = "$DetectorName\_frontchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 193.995*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "65.1*cm 143.9*cm 0.005*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_POLYVINYL_CHLORIDE"; #should be POLYVINYL fluride 1.45g/cm3
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}

sub make_backchamber
{
  my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_backchamber";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Polycone";
 $detector{"dimensions"}  = "0*deg 360*deg 4*counts 65*cm 67*cm 67*cm 85*cm 144*cm 155*cm 265*cm 265*cm 194*cm 209.01*cm 209.01*cm 301*cm";
 $detector{"material"}    = $material_gas;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}

sub make_backchamber_window_front
{
  my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_backchamber_window_front";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 194.0025*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "65.1*cm 143.9*cm 0.0025*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_POLYVINYL_CHLORIDE"; #should be POLYVINYL fluride 1.45g/cm3
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}

sub make_backchamber_window_back
{
  my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_backchamber_window_back";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 300.995*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "85.1*cm 264.9*cm 0.005*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_POLYVINYL_CHLORIDE"; #should be POLYVINYL fluride 1.45g/cm3
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "no";
 $detector{"identifiers"} = "no";
 print_det(\%configuration, \%detector);
}


# For the electron Cherenkov:
# z = 240 cm
# R = 240 cm
# angle = 67 deg
# photon detector size = 4" x 4"

sub make_lg_lightout
{
  my %detector=init_det();
 $detector{"name"}        = "$DetectorName\_lightout";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 240*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 240-15.6/2.*sin(23./180.*3.1415926);
 my $Rmax1 = $Rmin1+0.1;
 my $Rmin2 = 240+15.6/2.*sin(23./180.*3.1415926);
 my $Rmax2 = $Rmin2+0.1;
 my $Dz    = 15.6/2.*cos(23./180.*3.1415926);
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "SL_Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "flux";
 $detector{"hit_type"}    = "flux";
 $detector{"identifiers"} = "id manual 2100000";
 print_det(\%configuration, \%detector);
}
