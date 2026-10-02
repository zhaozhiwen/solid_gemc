use strict;
use warnings;
our %configuration;

# Materials from sPHENIX PHG4Reco.cc. PMMA is NOT redefined: we use G4_PLEXIGLASS
# because sPHENIX's PMMA passes atom ratios as mass fractions (53% H by mass).

sub solid_spacal_materials
{
	my %mat = init_mat();
	$mat{"name"}          = "SL_spacal_W_Epoxy";
	$mat{"description"}   = "sPHENIX Spacal_W_Epoxy absorber, mass fractions";
	$mat{"density"}       = "12.18";   # g/cm3
	$mat{"ncomponents"}   = "3";
	$mat{"components"}    = "G4_W 0.969 G4_C 0.029 G4_H 0.002";
	print_mat(\%configuration, \%mat);

	%mat = init_mat();
	$mat{"name"}          = "SL_spacal_G10";
	$mat{"description"}   = "sPHENIX G10, atom counts";
	$mat{"density"}       = "1.700";   # g/cm3
	$mat{"ncomponents"}   = "4";
	$mat{"components"}    = "Si 1 O 2 C 3 H 3";
	print_mat(\%configuration, \%mat);
}

1;
