
use strict;
use warnings;
use materials;

our %configuration;

print "\n\n   -== Writing material properties ==- \n\n";


#if( scalar @ARGV != 1)
#{
#	help();
#	exit;
#}

#our %configuration = load_configuration($ARGV[0]);



sub define_lgc_material
{

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

    my @h12700_eff = ( 
	"0.016", "0.02", "0.024", "0.035",
	"0.040", "0.050", "0.055", "0.061",
	"0.077", "0.085", "0.101", "0.121",
	"0.145", "0.163", "0.181", "0.194",
	"0.203", "0.224", "0.235", "0.253",
	"0.268", "0.285", "0.300", "0.309",
	"0.319", "0.329", "0.333", "0.335",
	"0.333", "0.327", "0.322", "0.329",
	"0.334", "0.318", "0.313", "0.327",
	"0.331", "0.331", "0.331", "0.331",
	"0.0331"
	);
    my @UVwin_index = ( 
        "1.51568", "1.513", "1.51024", "1.50472",
        "1.50196", "1.49783", "1.49507", "1.49231",
        "1.48679", "1.48403", "1.48128", "1.47852",
        "1.47576", "1.473", "1.46901", "1.46995",
        "1.46667", "1.46799", "1.46733", "1.46767",
        "1.46934", "1.47201", "1.47434", "1.47838",
        "1.4868", "1.49445", "1.5008", "1.50321",
        "1.504", "1.504", "1.504", "1.504",
        "1.504", "1.504", "1.504", "1.504",
        "1.504", "1.504", "1.504", "1.504",
        "1.504"
	);
    my @CO2_1atm_index = (
	"1.000418", "1.000418", "1.000418", "1.000419", 
	"1.000419", "1.000419", "1.000419", "1.000419",
	"1.000420", "1.000420", "1.000421", "1.000421",
	"1.000421", "1.000421", "1.000422", "1.000422",
	"1.000423", "1.000423", "1.000424", "1.000425",
	"1.000425", "1.000426", "1.000427", "1.000428",
	"1.000429", "1.000431", "1.000433", "1.000435",
	"1.000437", "1.000440", "1.000442", "1.000445",
	"1.000448", "1.000451", "1.000456", "1.000459",
	"1.000462", "1.000466", "1.000473", "1.000481",
	"1.000489"
	);
    my @CO2_1atm_AbsLen = (
	"70316.5*m", "66796.2*m", "63314.0*m", "56785.7*m",
	"53726.5*m", "49381.2*m", "46640.7*m", "44020.0*m",
	"39127.2*m", "36845.7*m", "34671.4*m", "32597.4*m",
	"30621.3*m", "28743.4*m", "26154.3*m", "23775.1*m",
	"22306.7*m", "19526.3*m", "18263.4*m", "16473.0*m",
	"14823.5*m", "12818.8*m", "11053.4*m", "9837.32*m",
	"8351.83*m", "6747.67*m", "5648.87*m", "4694.87*m",
	"3876.99*m", "3150.27*m", "2706.97*m", "2310.46*m",
	"1859.36*m", "1568.2*m", "1237.69*m", "1093.38*m",
	"962.586*m", "846.065*m", "643.562*m", "520.072*m",
	"133.014*m"
	);
	
    my @CO2_1atm_AbsLen_alt = (
         "70316.5*m", "66796.2*m", "63314.0*m", "56785.7*m",
         "53726.5*m", "49381.2*m", "46640.7*m", "44020.0*m",
         "39127.2*m", "36845.7*m", "34671.4*m", "32597.4*m",
         "30621.3*m", "28743.4*m", "26154.3*m", "23775.1*m",
         "22306.7*m", "19526.3*m", "18263.4*m", "16473.0*m",
         "14823.5*m", "12818.8*m", "11053.4*m", "9837.32*m",
         "8351.83*m", "6747.67*m", "5648.87*m", "4694.87*m",
         "3876.99*m", "3150.27*m", "2706.97*m", "2310.46*m",
         "1859.36*m", "1568.2*m", "1237.69*m", "1093.38*m",
         "962.586*m", "846.065*m", "643.562*m", "80.0*m",
         "4.0*m"
         );
	


    my @reflect0 = ( 
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0", "0.0", "0.0", "0.0",
	"0.0"
	);



    my %mat = init_mat();
##########################
# LGC Section 
##########################
    ##############
    #gas
    #
    #1atm C4F8O,density is assumed !!!!!!!!!!!!!!! 
    %mat = init_mat();
    $mat{"name"}          = "SL_C4F8O";
    $mat{"description"}   = "C4F8O";
    $mat{"density"}       = "0.001";  #in g/cm3  
    $mat{"ncomponents"}   = "3";
    $mat{"components"}    = "C 4 F 8 O 1";
    print_mat(\%configuration, \%mat);
    
    #65% C4F8O, 35% N2
    #density=0.65*0.001+0.35*0.0011652=0.001058
    #fractionmass 0.6145 and 0.3855
    %mat = init_mat();
    $mat{"name"}          = "SL_CCgas_PVDIS";
    $mat{"description"}   = "Gas in CC of PVDIS";
    $mat{"density"}       = "0.001058";  #in g/cm3
    $mat{"ncomponents"}   = "2";
    $mat{"components"}    = "SL_C4F8O 0.6145 G4_N 0.3855";
    $mat{"photonEnergy"}      = "2*eV 6*eV";
    $mat{"indexOfRefraction"} = "1.001 1.001";	
    print_mat(\%configuration, \%mat);
    
    #Polyvinyl Flouride as entrance and exit windows
    %mat = init_mat();
    $mat{"name"}          = "SL_PVF";
    $mat{"description"}   = "Polyvinyl Flouride";
    $mat{"density"}       = "1.450";  #in g/cm3
    $mat{"ncomponents"}   = "3";
    $mat{"components"}    = "G4_H 0.5 G4_C 0.33 G4_F 0.17";	
    print_mat(\%configuration, \%mat);
    

    #Reinforced carbon fiber polymer composition for mirrors
    %mat = init_mat();
    $mat{"name"}          = "SL_RCFP";
    $mat{"description"}   = "Reinforced carbon fiber polymer";
    $mat{"density"}       = "1.8";  #in g/cm3
    $mat{"ncomponents"}   = "4";
    $mat{"components"}    = "G4_C 0.42 G4_N 0.17 G4_O 0.08 G4_H 0.33";	
    print_mat(\%configuration, \%mat);

    #Glass for winston cones:
    %mat = init_mat();
    $mat{"name"}          = "SL_LGC_WinstonCone";
    $mat{"description"}   = "Silicon glass";
    $mat{"density"}       = "2.203";  #in g/cm3
    $mat{"ncomponents"}   = "1";
	$mat{"components"}    = "G4_SILICON_DIOXIDE 1";	
    print_mat(\%configuration, \%mat);
    
    #MuMetal:
    %mat = init_mat();
    $mat{"name"}          = "SL_MuMetal";
    $mat{"description"}   = "MuMetal";
    $mat{"density"}       = "8.700";  #in g/cm3
    $mat{"ncomponents"}   = "4";
    $mat{"components"}    = "G4_Ni 0.77 G4_Fe 0.16 G4_Cu 0.05 G4_Cr 0.02";	
    print_mat(\%configuration, \%mat);
    

    %mat = init_mat();
    $mat{"name"}          = "SL_LGCCgas_SIDIS";
    $mat{"description"}   = "Gas in LGCC of SIDIS";
    $mat{"density"}       = "0.00184212";  #in g/cm3
    $mat{"ncomponents"}   = "1";
    $mat{"components"}    = "G4_CARBON_DIOXIDE 1";
    $mat{"photonEnergy"}      = arrayToString(@PhotonEnergy);
    $mat{"indexOfRefraction"} = arrayToString(@CO2_1atm_index);
    $mat{"absorptionLength"}  = arrayToString(@CO2_1atm_AbsLen_alt);	
    print_mat(\%configuration, \%mat);
    
#PMT UV window material:  From Hamamatsu rep
    %mat = init_mat();
    $mat{"name"}          = "SL_H12700UVwin";
    $mat{"description"}   = "H12700UVwin";
    $mat{"density"}       = "2.32";  #in g/cm3
    $mat{"ncomponents"}   = "4";
    $mat{"components"}    = "G4_Si 0.25 G4_B 0.08 G4_Na 0.03 G4_O 0.64";
    $mat{"photonEnergy"}      = arrayToString(@PhotonEnergy);
    $mat{"indexOfRefraction"} = arrayToString(@UVwin_index);
    print_mat(\%configuration, \%mat);
    
#PMT cathode material // right now just a vacuum
    %mat = init_mat();
    $mat{"name"}          = "SL_H12700";
    $mat{"description"}   = "H12700";
    $mat{"density"}       = "1.00000000000000168";  #in g/cm3
    $mat{"ncomponents"}   = "1";
    $mat{"components"}    = "G4_H 1";
    $mat{"photonEnergy"}      = arrayToString(@PhotonEnergy);
    $mat{"efficiency"}   = arrayToString(@h12700_eff);
    $mat{"indexOfRefraction"}      = arrayToString(@CO2_1atm_index);
    print_mat(\%configuration, \%mat);

}
define_lgc_material();
1;


