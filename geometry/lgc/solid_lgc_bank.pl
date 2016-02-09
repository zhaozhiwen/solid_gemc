use strict;
use warnings;

our %configuration;

print "\n\n   -== Writing bank definitions ==- \n\n";

# Variable Type is two chars.
# The first char:
#  R for raw integrated variables
#  D for dgt integrated variables
#  S for raw step by step variables
#  M for digitized multi-hit variables
#  V for voltage(time) variables
#
# The second char:
# i for integers
# d for doubles

sub define_lgc_bank
{
	# uploading the hit definition
	my $bankId = 250;
	my $bankname = "solid_lgc";
	
	insert_bank_variable(\%configuration, $bankname, "bankid", $bankId, "Di", "$bankname bank ID");
	insert_bank_variable(\%configuration, $bankname, "hitn",   99,   "Di", "Hit Number");
	insert_bank_variable(\%configuration, $bankname, "sector",     1,   "Di", "Sector number");
	insert_bank_variable(\%configuration, $bankname, "pmt",     2,   "Di", "pmt number");
	insert_bank_variable(\%configuration, $bankname, "pixel",     3,   "Di", "pixel number");
	insert_bank_variable(\%configuration, $bankname, "nphe",     4,   "Di", "number of photoelectrons");		
	insert_bank_variable(\%configuration, $bankname, "avg_t",  5,   "Dd", "Average time");

}
define_lgc_bank();
1;










