sub makePMTs
{
	# Offset vectors for the position of each PMT and MaPMT pixel.  First, the center of the array if found.  Then a loop is performed over each row and column of PMTs (3x3 currently, but can be set to different), and the offset vector, when added to the central vector will point to the center of the PMT.  Then a for loop is done over each row and column of pixels (8x8, hard-coded) and a second offset vector, when added to the previous two vectors, will point to the center of the pixel.  Additional offset vectors point to the position of the windows, and the "light-catch" behind the PMT sensetive geometry.
	
    my $temp_off_V = vector(0.0,0.0,0.0);
    my $temp_off_V_save = vector(0.0,0.0,0.0);
    my $temp_off_Vpix = vector(0.0,0.0,0.0);
    my $tempWindow_off_V = vector(0.0,0.0,0.0);
    my $tempWindow_pos_V = vector(0.0,0.0,0.0);
    my $tempBack_off_V = vector(0.0,0.0,0.0);
    my $tempBack_pos_V = vector(0.0,0.0,0.0);
    my $Pos_obs_V = $Pos_im_Obs_V;
    my $Pos_obs_hfloff = vector(0.0, 0.0, -$PMT_hflngth);
    my $RpM = Math::MatrixReal->new_from_rows( [ [1,0,0], [0,1,0], [0,0,1] ] ); 
    my $RpMx = Math::MatrixReal->new_from_rows( [ [1,0,0], [0,1,0], [0,0,1] ] );
    my $RpMy = Math::MatrixReal->new_from_rows( [ [1,0,0], [0,1,0], [0,0,1] ] );
    $RpM = &rotateZ($RpM,-$ang_zrot*$D2R);
    $RpMx = &rotateX($RpMx,-$ang_xrot*$D2R);
    $RpMy = &rotateY($RpMy,-$ang_yrot*$D2R);

    my $RpMxc = &VMconvert($RpMx);
    my $RpMyc = &VMconvert($RpMy);

    $Pos_obs_hfloff = $Pos_obs_hfloff*$RpMyc;
    $Pos_obs_hfloff = $Pos_obs_hfloff*$RpMxc;

    $Pos_obs_V = $Pos_obs_V + $Pos_obs_hfloff;

	$RpM = &rotateZ($RpM,$initRot*$D2R);
	my $angRot = $initRot;

    for(my $n=1; $n <= $Nsec; $n++)
    {
	$angRot += 12.0;
	$RpM = &rotateZ($RpM,12.0*$D2R);
	my $RpMc = &VMconvert($RpM);

	my $temp_pos_V = $Pos_obs_V;
	my $temp_posW_V = $Pos_obs_V + $Pos_obsWin_V;
	$temp_pos_V = $temp_pos_V*$RpMc;

	my $temp_init_V = $temp_pos_V;
	$writedet = 1;
	my $curr_pmt = 0;
	for(my $j = 0; $j < $pmtN; $j++){
	    for(my $k = 0; $k < $pmtN; $k++){
		$curr_pmt++;
		if(!$pmt232){  #special case for pmts = 7
		    if($pmtN%2){
			$temp_off_V = vector(2.0*($j -($pmtN -1)/2.0)*$pmt_x,  2.0*($k -($pmtN -1)/2.0)*$pmt_x, $PMT_hflngth - 2*$PMTwindow_hfthk- 0.01);
		    }else{
			$temp_off_V = vector((2.0*$j - ($pmtN -1))*$pmt_x,  (2.0*$k - ($pmtN -1))*$pmt_x, $PMT_hflngth - 2*$PMTwindow_hfthk - 0.01);
		    }
		}else{
		    $writedet = 1;

		    if(($j == 0 && $k <= 1) || ($j==2 && $k <=1)){
			$temp_off_V = vector(2.0*($j - 1.0)*$pmt_x,  (2.0*$k - 1.0)*$pmt_x, $PMT_hflngth - 2*$PMTwindow_hfthk - 0.01);
		    }elsif($j==1 && $k <=2){
			$temp_off_V = vector(2.0*($j -1.0)*$pmt_x,  2.0*($k - 1.0)*$pmt_x, $PMT_hflngth - 2*$PMTwindow_hfthk- 0.01);
		    }else{
			$writedet = 0;
		    }
		}

		

		$tempWindow_off_V = $temp_off_V + vector(0,0, $PMTwindow_hfthk + 0.01);
		$tempWindow_off_V = $tempWindow_off_V*$RpMxc;
		$tempWindow_off_V = $tempWindow_off_V*$RpMc;
		$tempWindow_pos_V = $temp_init_V + $tempWindow_off_V;

		$tempBack_off_V = $temp_off_V + vector(0,0, $PMTwindow_hfthk - 2.0);
		$tempBack_off_V = $tempBack_off_V*$RpMxc;
		$tempBack_off_V = $tempBack_off_V*$RpMc;
		$tempBack_pos_V = $temp_init_V + $tempBack_off_V;


		$temp_off_V_save = $temp_off_V;

                #now for each pixel!


		my $curr_pix = 0;
		for(my $jpix = 0; $jpix < 8; $jpix++){
		    for(my $kpix = 0; $kpix < 8; $kpix++){
			$curr_pix++;
			$temp_off_Vpix = vector((2.0*$jpix - 7)*$pmt_x/8.0,  (2.0*$kpix - 7)*$pmt_x/8.0, 0.0);
			$temp_off_V = $temp_off_V_save + $temp_off_Vpix;

			$temp_off_V = $temp_off_V*$RpMxc;
			$temp_off_V = $temp_off_V*$RpMyc;
			$temp_off_V = $temp_off_V*$RpMc;

			$temp_pos_V = $temp_init_V + $temp_off_V;

			$detector{"name"} = $namePre."PMT_".&sec($n)."_".$curr_pmt."_".$curr_pix;
			$detector{"mother"} = $namePre."Tank";
			$detector{"description"} = "PMT number $n $j $k $jpix $kpix";
			$detector{"pos"} = sprintf('%.3f',$temp_pos_V->x())."*cm ".sprintf('%.3f',$temp_pos_V->y())."*cm ".sprintf('%.3f',$temp_pos_V->z())."*cm";
			$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
			if(($j + $k)%2){
			    if(($jpix + $kpix)%2){
				$detector{"color"}      = "ff9999";
			    }else{
				$detector{"color"}      = "ff0000";
			    }
			}else{
			    if(($jpix + $kpix)%2){
				$detector{"color"}      = "99ff99";
			    }else{
				$detector{"color"}      = "00cc00";
			    }
			}
			$detector{"type"}       = "Box";
			$detector{"dimensions"} = ($pmt_x/8.0 - 0.0001)."*cm ".($pmt_x/8.0 - 0.0001)."*cm 0.0001*mm"; #shrink pixels by a um to keep away overlaps, since this is a half length, it equates to a total of 4um gap between pixels...  Probably smaller than actual dead area.
			$detector{"material"}   = "SL_H12700";
			$detector{"mfield"}     = "no";
			$detector{"ncopy"}      = 1;
			$detector{"pMany"}       = 1;
			$detector{"exist"}       = 1;
			$detector{"visible"}     = 0;
			$detector{"style"}       = 1;
			$detector{"sensitivity"} = "solid_lgc";
			$detector{"hit_type"}    = "solid_lgc";
			$detector{"identifiers"} = "sector manual ".&sec($n)." pmt manual $curr_pmt pixel manual $curr_pix";
			if($writedet){
			    print_det(\%configuration, \%detector);
			}
		    }
		}
	    
#window
	

		$detector{"name"} = $namePre."PMT_Window_".&sec($n)."_".$j."_".$k;
		$detector{"mother"} = $namePre."Tank";
		$detector{"description"} = "PMT number window ".&sec($n)." $j $k";
		$detector{"pos"} = sprintf('%.3f',$tempWindow_pos_V->x())."*cm ".sprintf('%.3f',$tempWindow_pos_V->y())."*cm ".sprintf('%.3f',$tempWindow_pos_V->z())."*cm";
		$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
		$detector{"color"}      = "ff00ff";
		$detector{"type"}       = "Box";
		$detector{"dimensions"} = ($pmt_x - $pmt_shell)."*cm ".($pmt_x -$pmt_shell)."*cm ".($PMTwindow_hfthk)."*cm";
		$detector{"material"}   = "SL_H12700UVwin"; 
		$detector{"mfield"}     = "no";
		$detector{"ncopy"}      = 1;
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "no";
		$detector{"identifiers"} = "no";
		if($writedet){
		    print_det(\%configuration, \%detector);
		}

		
#light catch at back of pmt:
		$detector{"name"} = $namePre."PMT_lightBlock_".&sec($n)."_".$j."_".$k;
		$detector{"mother"} = $namePre."Tank";
		$detector{"description"} = "PMT number lightBlock ".&sec($n)." $j $k";
		$detector{"pos"} = sprintf('%.3f',$tempBack_pos_V->x())."*cm ".sprintf('%.3f',$tempBack_pos_V->y())."*cm ".sprintf('%.3f',$tempBack_pos_V->z())."*cm";
		$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
		$detector{"color"}      = "0000ff";
		$detector{"type"}       = "Box";
		$detector{"dimensions"} = ($pmt_x - $pmt_shell)."*cm ".($pmt_x -$pmt_shell)."*cm 0.01*cm";
		$detector{"material"}   = "SL_H12700UVwin"; 
		$detector{"mfield"}     = "no";
		$detector{"ncopy"}      = 1;
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "mirror: LGC_PMT_LightStop";
		$detector{"hit_type"}    = "mirror";
		$detector{"identifiers"} = "no";
		if($writedet){
		    print_det(\%configuration, \%detector);
		}

	    }
	}
#this is for the PMT box enclosure, currently it is not being built.

	$temp_posW_V = $temp_posW_V*$RpMc;
	    
	$detector{"name"} = $namePre."PMTbulk_".$n;
	$detector{"mother"} = $namePre."Tank";
	$detector{"description"} = "PMTbulk number $n";
	$detector{"pos"} = sprintf('%.3f',$temp_posW_V->x())."*cm ".sprintf('%.3f',$temp_posW_V->y())."*cm ".sprintf('%.3f',$temp_posW_V->z())."*cm";
#	$detector{"rotation"}   = "ordered: zyx ".(-$ang_zrot + $n*12.0)."*deg 0*deg -".$ang_xrot."*deg";
	$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
	$detector{"color"}      = "ff0000";
	$detector{"type"}       = "Box";
	$detector{"dimensions"} = $pmtN*$pmt_x."*cm ".$pmtN*$pmt_x."*cm ".$PMT_hflngth."*cm";
	$detector{"material"}   = "Component";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "PMTbulk_$n";
#	print_det(\%configuration, \%detector);
	    
	$detector{"name"} = $namePre."PMTframe_".$n;
	$detector{"mother"} = $namePre."Tank";
	$detector{"description"} = "PMTframe number $n";
	$detector{"pos"} = sprintf('%.3f',$temp_posW_V->x())."*cm ".sprintf('%.3f',$temp_posW_V->y())."*cm ".sprintf('%.3f',$temp_posW_V->z())."*cm";
#	$detector{"rotation"}   = "ordered: zyx ".(-$ang_zrot + $n*12.0)."*deg 0*deg -".$ang_xrot."*deg";
	$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
	$detector{"color"}      = "ff0000";
	$detector{"type"}       = "Box";
	$detector{"dimensions"} = ($pmtN*$pmt_x + $PMTbox_HL)."*cm ".($pmtN*$pmt_x + $PMTbox_HL)."*cm ".$PMT_hflngth."*cm";
	$detector{"material"}   = "Component"; 
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "no";
	$detector{"identifiers"} = "PMTFrame_$n";
#	print_det(\%configuration, \%detector);
	    
	$detector{"name"} = $namePre."PMTenclosure_".$n;
	$detector{"mother"} = $namePre."Tank";
	$detector{"description"} = "PMTenc number $n";
	$detector{"pos"} = sprintf('%.3f',$temp_posW_V->x())."*cm ".sprintf('%.3f',$temp_posW_V->y())."*cm ".sprintf('%.3f',$temp_posW_V->z())."*cm";
#	$detector{"rotation"}   = "ordered: zyx ".(-$ang_zrot + $n*12.0)."*deg 0*deg -".$ang_xrot."*deg";
	$detector{"rotation"}   = "ordered: zxy ".(-$ang_zrot + $angRot)."*deg -".$ang_xrot."*deg -".$ang_yrot."*deg";
	$detector{"color"}      = "000000";
	$detector{"type"}       = "Operation:@ ".$namePre."PMTframe_$n - ".$namePre."PMTbulk_$n";
	$detector{"material"}   = "Kryptonite"; 
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "PMTenc_$n";
#	print_det(\%configuration, \%detector);
		

    }
}1;
