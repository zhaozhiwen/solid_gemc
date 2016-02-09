sub make_blinder
{
    my $PosV = vector(0.,140.,250.);
    my $PosV_temp = $PosV;
    $PosV_temp = &rotateZv($PosV_temp,6.0*$D2R);
    for(my $n=1; $n<=$Nsec; $n++)
    {
	$PosV_temp = &rotateZv($PosV_temp,12.0*$D2R);

	$detector{"name"}        = $namePre."blinder_$n";
	$detector{"mother"}      = $namePre."Tank" ;
	$detector{"description"} = "blinder $n";
	$detector{"pos"}        = sprintf('%.3f',$PosV_temp->x())."*cm ".sprintf('%.3f',$PosV_temp->y())."*cm ".sprintf('%.3f',$PosV_temp->z())."*cm";
	$detector{"rotation"}   = "0*deg 0*deg ".(6.0 + 12.0*$n)."*deg";
	$detector{"color"}      = "009900";
	$detector{"type"}       = "Box";
	$detector{"dimensions"} = "1.0*cm 60.0*cm 40.0*cm";
	$detector{"material"}   = "SL_RCFP";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "no";
	
	#print_det(\%configuration, \%detector);
	}
}1;

