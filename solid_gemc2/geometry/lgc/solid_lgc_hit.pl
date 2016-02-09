use strict;
use warnings;

our %configuration;
our %parameters;

print "\n\n   -== Writing hit definitions ==- \n\n";

sub define_lgc_hit
{
	# uploading the hit definition
	my %hit = init_hit();
	$hit{"name"}            = "solid_lgc";
	$hit{"description"}     = "solid lgc hit definition";
	$hit{"identifiers"}     = "sector pmt pixel";
	$hit{"signalThreshold"} = "0.5*MeV";
	$hit{"timeWindow"}      = "5*ns";
	$hit{"prodThreshold"}   = "1*mm";
	$hit{"maxStep"}         = "1*cm";
	$hit{"delay"}           = "50*ns";
	$hit{"riseTime"}        = "1*ns";
	$hit{"fallTime"}        = "2*ns";
	$hit{"mvToMeV"}         = 100;
	$hit{"pedestal"}        = -20;
	print_hit(\%configuration, \%hit);
}
define_lgc_hit();

1;
