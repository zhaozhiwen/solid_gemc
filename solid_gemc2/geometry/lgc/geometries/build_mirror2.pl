sub make_mirror2
{
    my $V0_tg_V = vector(0.,0.,$ztarg_cent2);

    $R = 0.;  #zero out buildSPmirror globals
    $PosV = vector(0.,0.,0.);
    
    my $mirrRotPoint = vector(0.0, (-$V0_tg_V->z() + $zMirrRotPoint2)*tan($cr_ang2*$D2R), $zMirrRotPoint2);

    my $Z_front = 200.0 - $V0_tg_V->z();
    my $Z_end = 301.0 - $V0_tg_V->z();
    my $R_front_in = $Z_front*tan($Angle_in2*$D2R);
    my $R_front_out = $Z_front*tan($Angle_out2*$D2R);
    my $R_end_in = $Z_end*tan($Angle_in2*$D2R);
    my $R_end_out = $Z_end*tan($Angle_out2*$D2R);

    &buildSPmirror($V0_tg_V, $Pos_im_Obs_V, $cr_ang2, $Z_M2);
    my $PosV_temp = $PosV;
    my $PosV_cone = vector(0.,0.,250.5);
    my $PosV_delta = vector(0., 0., 0.);
    my $PosV_deltaC = vector(0., 0., 0.);

    print "MIRROR 2:\n";
    print "sphere center $PosV\n";
    print "sphere R: $R\n";
    &calcIntPoints($R, $PosV, $PosV_cone, 0.5*($Z_end - $Z_front), $R_front_in, $R_front_out, $R_end_in, $R_end_out);

    
    if($mirrAng2){
	$PosV_delta = mirrorRot($cr_ang2, $PosV_temp, $mirrAng2, $ztarg_cent2, $zMirrRotPoint2);
	$PosV_temp = $PosV_temp + $PosV_delta;
    

	$PosV_deltaC = mirrorRot($cr_ang2, $PosV_cone, $mirrAng2, $ztarg_cent2, $zMirrRotPoint2);

	$PosV_cone = $PosV_cone + $PosV_deltaC;
    }
    my $PosV_temp_CM = $PosV_temp;
        
		
	my $rotAng = $initRot;
	$PosV_temp = &rotateZv($PosV_temp, $initRot*$D2R);
	$PosV_cone = &rotateZv($PosV_cone, $initRot*$D2R);
	$PosV_temp_CM = &rotateZv($PosV_temp_CM, $initRot*$D2R);

    for(my $n=1; $n<=$Nsec; $n++)
    {
	
	$rotAng += 12.0;
		
	$PosV_temp = &rotateZv($PosV_temp,12.0*$D2R);

	$detector{"name"}        = $namePre."Mirror2s_$n";
	$detector{"mother"}      = $namePre."Tank" ;
	$detector{"description"} = "Mirror2 Sphere number $n";
	$detector{"pos"}        = sprintf('%.3f',$PosV_temp->x())."*cm ".sprintf('%.3f',$PosV_temp->y())."*cm ".sprintf('%.3f',$PosV_temp->z())."*cm";
	$detector{"rotation"}   = "0*deg 0*deg 0*deg";
	$detector{"color"}      = "66bbff";
	$detector{"type"}       = "Sphere";
	$detector{"dimensions"} = sprintf('%.3f',$R)."*cm ". sprintf('%.3f',$R + 0.1*$T_M2)."*cm 0.0 360.0*deg 0.0 90.0*deg";
	$detector{"material"}   = "Component";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "Mirror2 sphere $n";
	
	print_det(\%configuration, \%detector);

	$PosV_cone = &rotateZv($PosV_cone,12.0*$D2R);

	$detector{"name"}        = $namePre."Mirror2c_$n";
	$detector{"mother"}      = $namePre."Tank" ;
	$detector{"description"} = "Mirror2 cone $n";
	$detector{"pos"}        = sprintf('%.3f',$PosV_cone->x())."*cm ".sprintf('%.3f',$PosV_cone->y())."*cm ".sprintf('%.3f',$PosV_cone->z())."*cm";
	$detector{"rotation"}   = "ordered: zyx ".$rotAng."*deg 0*deg ".(-$mirrAng2)."*deg";
	$detector{"color"}      = "66bbff";
	$detector{"type"}       = "Cons";
	$detector{"dimensions"} = sprintf('%.3f',$R_front_in)."*cm ". sprintf('%.3f',$R_front_out)."*cm ".sprintf('%.3f',$R_end_in)."*cm ".sprintf('%.3f',$R_end_out)."*cm ".sprintf('%.3f',0.5*($Z_end - $Z_front))."*cm "." 84*deg 12*deg";
	$detector{"material"}   = "Component";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "Mirror2 cone $n";
	
	print_det(\%configuration, \%detector);

	$PosV_temp_CM = &rotateZv($PosV_temp_CM,12.0*$D2R);	
	
	$detector{"name"}        = $namePre."Mirror2_".&sec($n);
	$detector{"mother"}      = $namePre."Tank" ;
	$detector{"description"} = "Mirror2 segment ".&sec($n);
	$detector{"pos"}        = sprintf('%.3f',$PosV_temp_CM->x())."*cm ".sprintf('%.3f',$PosV_temp_CM->y())."*cm ".sprintf('%.3f',$PosV_temp_CM->z())."*cm";
	$detector{"rotation"}   = "0*deg 0*deg 0*deg";
	$detector{"color"}      = "111166";
	$detector{"type"}       = "Operation:@ ".$namePre."Mirror2s_$n * ".$namePre."Mirror2c_$n";
	$detector{"material"}   = "SL_RCFP";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "mirror: LGC_Mirror";
	$detector{"hit_type"}    = "mirrors";
	$detector{"identifiers"} = "no";
	print_det(\%configuration, \%detector);


    }
}1;
