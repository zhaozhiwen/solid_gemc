use strict;
use warnings;

our %configuration;
our %parameters;

sub define_hit
{
	# uploading the hit definition
	my %hit = init_hit();
	$hit{"name"}            = "solid_SIDIS_hgc";
	$hit{"description"}     = "solid SIDIS hgc hit definition";
	$hit{"identifiers"}     = "id";
	$hit{"signalThreshold"} = "0.*MeV";
	$hit{"timeWindow"}      = "0*ns";
	$hit{"prodThreshold"}   = "0*mm";
	$hit{"maxStep"}         = "0*cm";
	$hit{"delay"}           = "10*ns";
	$hit{"riseTime"}        = "1*ns";
	$hit{"fallTime"}        = "1*ns";
	$hit{"mvToMeV"}         = 100;
	$hit{"pedestal"}        = -20;
	print_hit(\%configuration, \%hit);
}
define_hit();

1;