use strict;
use warnings;
our %configuration;

# Hit definition for the solid_spacal hit process (fiber cores).
#   timeWindow 1000 ns: all steps of one fiber in an event form one hit (sPHENIX cells are per fiber);
#                       the sPHENIX 0-60 ns timing window is applied per step in the hit process
#                       (parameters spacal_time_min/max).
#   maxStep 0.044 mm:   sPHENIX fiber_core_step_limits = fiber_core_diameter/10 (G4UserLimits on the core).
#   prodThreshold 0.7 mm: Geant4 default production cut, which sPHENIX does not change.
sub solid_spacal_hit
{
	my %hit = init_hit();
	$hit{"name"}            = "solid_spacal";
	$hit{"description"}     = "sPHENIX SPACAL prototype fiber core";
	$hit{"identifiers"}     = "CH";
	$hit{"signalThreshold"} = "0*MeV";
	$hit{"timeWindow"}      = "1000*ns";
	$hit{"prodThreshold"}   = "0.7*mm";
	$hit{"maxStep"}         = "0.044*mm";
	$hit{"delay"}           = "0*ns";
	$hit{"riseTime"}        = "1*ns";
	$hit{"fallTime"}        = "1*ns";
	$hit{"mvToMeV"}         = 1;
	$hit{"pedestal"}        = 0;
	print_hit(\%configuration, \%hit);
}

1;
