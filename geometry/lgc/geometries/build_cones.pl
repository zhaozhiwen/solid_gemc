sub makeCones
{
	#This subroutine creates the winstone cones and magnetc shielding.
	
    my $RpM = Math::MatrixReal->new_from_rows( [ [1,0,0], [0,1,0], [0,0,1] ] ); #diagonal matrix for rotating the central position of the PMTs.
    my $RpMx = Math::MatrixReal->new_from_rows( [ [1,0,0], [0,1,0], [0,0,1] ] );
    my $RpMy = Math::MatrixReal->new_from_rows( [ [1,0,0], [0,1,0], [0,0,1] ] );

    $RpM = &rotateZ($RpM,-$ang_zrot*$D2R); #rotate into proper orientation
    $RpMx = &rotateX($RpMx,-$ang_xrot*$D2R);
    $RpMy = &rotateY($RpMy,-$ang_yrot*$D2R);
    my $RpMxc = &VMconvert($RpMx);
    my $RpMyc = &VMconvert($RpMy);

    my $Pos_winstonCone_V = $Pos_im_Obs_V;
    my $Pos_winstonCone_off_V = vector(0.0,0.0, $z_w_half);

    $Pos_winstonCone_off_V = $Pos_winstonCone_off_V*$RpMyc;
    $Pos_winstonCone_off_V = $Pos_winstonCone_off_V*$RpMxc;
    $Pos_winstonCone_V = $Pos_winstonCone_V + $Pos_winstonCone_off_V;

#The next three lines calculate where the magnetic shielding cylinder sits based on the length of the cylinder and the size of the cone.
    
    my $crossl = sqrt(2.0)*$pmtN*$pmt_x + 0.5 - $pmtN*$pmt_x;
    my $cyl_dist = -$pmt_shield_hlength - $z_w_half + $crossl/(($rmax_w_end - ($pmtN*$pmt_x + 0.5))/(2.0*$z_w_half));
    my $shield_offV = vector(0.0,0.0, $cyl_dist);

    $shield_offV = $shield_offV*$RpMyc;
    $shield_offV = $shield_offV*$RpMxc;
	
	$RpM = &rotateZ($RpM,$initRot*$D2R);
	my $angRot = $initRot;

    for(my $n=1; $n <= $Nsec; $n++)
    {
		
	$angRot += 12.0;
	$RpM = &rotateZ($RpM,12.0*$D2R);
	my $RpMc = &VMconvert($RpM);

	#Cone:

	my $temp_pos_V = $Pos_winstonCone_V;
	$temp_pos_V = $temp_pos_V*$RpMc;

	$detector{"name"} = $namePre."wcone_".&sec($n);
	$detector{"mother"} = $namePre."Tank";
	$detector{"description"} = "Winston Cone number ".&sec($n);
	$detector{"pos"} = sprintf('%.3f',$temp_pos_V->x())."*cm ".sprintf('%.3f',$temp_pos_V->y())."*cm ".sprintf('%.3f',$temp_pos_V->z())."*cm";
	$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
	$detector{"color"}      = "F0F0F0";
	$detector{"type"}       = "Cons";
	$detector{"dimensions"} =  $pmtN*$pmt_x."*cm ".($pmtN*$pmt_x + 0.5)."*cm ".$rmin_w_end."*cm ".$rmax_w_end."*cm ".$z_w_half."*cm ". "0.*deg 360.*deg";
	$detector{"material"}   = "SL_LGC_WinstonCone";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "mirror: LGC_WinstonCone";
	$detector{"hit_type"}    = "mirror";
	$detector{"identifiers"} = "no";

	print_det(\%configuration, \%detector);

#Shield inner cylinder:

	my $temp_pos_Vc = $Pos_winstonCone_V + $shield_offV;
	$temp_pos_Vc = $temp_pos_Vc*$RpMc;

	$detector{"name"} = $namePre."coneshield_in_".&sec($n);
	$detector{"mother"} = $namePre."Tank";
	$detector{"description"} = "Cone shield in number ".&sec($n);
	$detector{"pos"} = sprintf('%.3f',$temp_pos_Vc->x())."*cm ".sprintf('%.3f',$temp_pos_Vc->y())."*cm ".sprintf('%.3f',$temp_pos_Vc->z())."*cm";
	$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
	$detector{"color"}      = "606060";
	$detector{"type"}       = "Cons";
	$detector{"dimensions"} =  (sqrt(2.0)*$pmtN*$pmt_x + 0.5)."*cm ".(sqrt(2.0)*$pmtN*$pmt_x + 0.6)."*cm ".(sqrt(2.0)*$pmtN*$pmt_x + 0.5)."*cm ".(sqrt(2.0)*$pmtN*$pmt_x + 0.6)."*cm ".$pmt_shield_hlength."*cm ". "0.*deg 360.*deg";
	$detector{"material"}   = "SL_MuMetal";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "no";
	print_det(\%configuration, \%detector);
	

	#Shield outer cylinder
	$detector{"name"} = $namePre."coneshield_out_".&sec($n);
	$detector{"mother"} = $namePre."Tank";
	$detector{"description"} = "Cone shield_out number ".&sec($n);
	$detector{"pos"} = sprintf('%.3f',$temp_pos_Vc->x())."*cm ".sprintf('%.3f',$temp_pos_Vc->y())."*cm ".sprintf('%.3f',$temp_pos_Vc->z())."*cm";
	$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
	$detector{"color"}      = "606060";
	$detector{"type"}       = "Cons";
	$detector{"dimensions"} =  (sqrt(2.0)*$pmtN*$pmt_x + 0.6)."*cm ".(sqrt(2.0)*$pmtN*$pmt_x + 0.9)."*cm ".(sqrt(2.0)*$pmtN*$pmt_x + 0.6)."*cm ".(sqrt(2.0)*$pmtN*$pmt_x + 0.9)."*cm ".$pmt_shield_hlength."*cm ". "0.*deg 360.*deg";
	$detector{"material"}   = "SL_MuMetal";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "no";
	print_det(\%configuration, \%detector);

	
    }
}1;

