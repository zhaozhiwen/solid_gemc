use strict;
use warnings;
our %configuration;

# Digitized bank of the solid_spacal hit process: one entry per fiber with energy in the time window.
sub solid_spacal_bank
{
	my $bankId   = 330;
	my $bankname = "solid_spacal";
	insert_bank_variable(\%configuration, $bankname, "bankid", $bankId, "Di", "$bankname bank ID");
	insert_bank_variable(\%configuration, $bankname, "fiber",  1, "Di", "fiber code 100000*(sector+1) + 10000*tower + sPHENIX fiber id");
	insert_bank_variable(\%configuration, $bankname, "edep",   2, "Dd", "energy deposited in the core, MeV");
	insert_bank_variable(\%configuration, $bankname, "edepB",  3, "Dd", "Birks-quenched edep (kB = spacal_birks_kB), MeV");
	insert_bank_variable(\%configuration, $bankname, "light",  4, "Dd", "edepB x fiber transmission x light-guide efficiency, MeV");
	insert_bank_variable(\%configuration, $bankname, "t",      5, "Dd", "edep-weighted time, ns");
	insert_bank_variable(\%configuration, $bankname, "id",    98, "Di", "readout channel 10000 + 1000*sector + 100*tower + 10*subx + suby");
	insert_bank_variable(\%configuration, $bankname, "hitn",  99, "Di", "hit number");
}

1;
