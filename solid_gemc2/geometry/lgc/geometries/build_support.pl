sub makeSupport
{

    my $bisect_hthk = 1.0;

    my $RpM = Math::MatrixReal->new_from_rows( [ [1,0,0], [0,1,0], [0,0,1] ] ); #diagonal matrix for rotating the central position of the PMTs.

    $RpM = &rotateZ($RpM,-$ang_zrot*$D2R);


    for(my $n=1; $n <= 3; $n++)
    {
	$RpM = &rotateZ($RpM,60.0*$D2R);

	my $RpMc = &VMconvert($RpM);


#section planes

	$detector{"name"}        = $namePre."Tank_section_$n";
	$detector{"mother"}      = $namePre."Tank" ;
	$detector{"description"} = "Tank_section $n";
	$detector{"pos"}         = "0*cm 0*cm 246*cm";
	$detector{"rotation"}    = "0*deg 0*deg ".60.0*$n."*deg";
	$detector{"color"}       = "FF9900";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "250*cm ".$bisect_hthk."*cm 55*cm";
	$detector{"mfield"}      = "no";
	$detector{"material"}    = "PVF";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "Tank_bisection_$n";
	print_det(\%configuration, \%detector);

    }
}1;

