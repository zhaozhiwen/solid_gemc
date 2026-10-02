use strict;
use warnings;
use Math::Trig;
our %configuration;
our %parameters;
our $DetectorName;

# Port of PHG4SpacalPrototypeDetector.cc (sPHENIX prototype repo), config
# kFullProjective_2DTaper_SameLengthFiberPerTower. Lengths in cm, angles in rad.
#
# Volume tree (GEMC has no G4DisplacedSolid, so every sPHENIX solid displacement is folded into pos):
#   root
#   └─ _encl   G10 box (enclosure shell = outer box, filled by _box)
#      └─ _box   air box (enclosure inner volume)
#         ├─ _elec           G10 electronics board
#         └─ _SEC<s>         air Tubs wedge, one per sector (no CopyOf: fibers carry the sector in their channel code)
#            ├─ _TWR<s>_<j>  SL_spacal_W_Epoxy G4Trap
#            │  └─ _CHa<j> / _CHb<s>_<j>_<fid>   G4_PLEXIGLASS clad Tube, ncopy = readout channel code
#            │     └─ _core<j>                   G4_POLYSTYRENE core, sensitive (flux), only inside _CHa<j>, shared by CopyOf
#            └─ _LG<s>_<j>_<ix>_<iy>             G4_PLEXIGLASS light guide G4Trap
#
# Rotations: GEMC builds M = Rz(c)*Ry(b)*Rx(a) from "a b c" and hands it to G4PVPlacement as a frame
# (passive) rotation, so the daughter is rotated by M^-1. sPHENIX uses active transforms.
#   active Rx(t) -> "-t 0 0";  active Rz(t) -> "0 0 -t";
#   fiber along unit u: M = Ry(b)*Rx(a) gives M^-1 z = (-sin b, cos b sin a, cos b cos a) = u
#   => a = atan2(uy, uz), b = -asin(ux).
#
# Sensitive volume: fiber core, hit type solid_spacal (solid_gemc/source/2.9/hitprocess/solid_spacal_hitprocess.cc).
# Core identifier "CH ncopy 0" picks up the clad copy number = fiber code:
#   100000*(s+1) + 10000*j + fid      (s sector, j tower: 0-based, parameter-file order; fid = sPHENIX fiber id)
# The hit process maps it to the readout channel 10000 + 1000*s + 100*j + 10*subx + suby.

my $D = $DetectorName;

sub P
{
	my $k = shift;
	die "missing parameter $k\n" unless exists $parameters{$k};
	return $parameters{$k};
}

sub rotx { my ($v, $a) = @_; return [$v->[0], cos($a)*$v->[1] - sin($a)*$v->[2], sin($a)*$v->[1] + cos($a)*$v->[2]]; }
sub rotz { my ($v, $a) = @_; return [cos($a)*$v->[0] - sin($a)*$v->[1], sin($a)*$v->[0] + cos($a)*$v->[1], $v->[2]]; }
sub vadd { my ($u, $v) = @_; return [$u->[0]+$v->[0], $u->[1]+$v->[1], $u->[2]+$v->[2]]; }
sub vsub { my ($u, $v) = @_; return [$u->[0]-$v->[0], $u->[1]-$v->[1], $u->[2]-$v->[2]]; }
sub vscale { my ($v, $s) = @_; return [$v->[0]*$s, $v->[1]*$s, $v->[2]*$s]; }
sub vmag { my $v = shift; return sqrt($v->[0]**2 + $v->[1]**2 + $v->[2]**2); }
sub poscm { my $v = shift; return sprintf("%.10f*cm %.10f*cm %.10f*cm", @$v); }
sub rotrad { return sprintf("%.12f*rad %.12f*rad %.12f*rad", @_); }

my $color_g10    = "339933";
my $color_air    = "ccccff";
my $color_abs    = "444444";
my $color_fiber  = "ffff00";
my $color_lg     = "66ccff";

my $mat_abs   = "SL_spacal_W_Epoxy";
my $mat_g10   = "SL_spacal_G10";
my $mat_clad  = "G4_PLEXIGLASS";
my $mat_core  = "G4_POLYSTYRENE";
my $mat_lg    = "G4_PLEXIGLASS";
my $mat_air   = "G4_AIR";

my $R       = P("radius");
my $T       = P("thickness");
my $zmin    = P("zmin");
my $zmax    = P("zmax");
my $length  = $zmax - $zmin;
my $n_az    = P("azimuthal_n_sec");
my $nsec    = P("sector_map_size");
my $ntwr    = P("sector_tower_map_size");
my $core_r  = P("fiber_core_diameter") / 2;
my $r_out   = P("fiber_clading_thickness") + $core_r;   # get_fiber_outer_r

my $max_lg = 0;
for (my $j = 0; $j < $ntwr; $j++) { $max_lg = P("tower$j\_LightguideHeight") if P("tower$j\_LightguideHeight") > $max_lg; }

my $box_x_shift = $R + 0.5*$T + P("enclosure_x_shift");
my $box_z_shift = 0.5*($zmin + $zmax);

my $vis_fiber = ($configuration{"variation"} eq "mini") ? 1 : 0;

sub put
{
	my (%a) = @_;
	my %detector = init_det();
	$detector{"name"}        = $a{name};
	$detector{"mother"}      = $a{mother};
	$detector{"description"} = $a{name};
	$detector{"pos"}         = $a{pos} // "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = $a{rot} // "0*deg 0*deg 0*deg";
	$detector{"color"}       = $a{color};
	$detector{"type"}        = $a{type};
	$detector{"dimensions"}  = $a{dims} // "0";
	$detector{"material"}    = $a{mat};
	$detector{"ncopy"}       = $a{ncopy} // 1;
	$detector{"visible"}     = $a{visible} // 1;
	$detector{"style"}       = $a{style} // 0;
	$detector{"sensitivity"} = $a{sens} // "no";
	$detector{"hit_type"}    = $a{sens} // "no";
	$detector{"identifiers"} = $a{ids} // "no";
	print_det(\%configuration, \%detector);
}

# sPHENIX Construct_Fibers_SameLengthFiberPerTower, in the tower frame.
# Returns (fiber length, list of [fid, ix, iy, subx, suby, center, vector]).
sub tower_fibers
{
	my $j = shift;
	my %t = map { $_ => P("tower$j\_$_") } qw(NFiberX NFiberY NSubtowerX NSubtowerY ModuleSkinThickness
	                                          pDz pTheta pPhi pDx1 pDx2 pDx3 pDx4 pDy1 pDy2 pAlp1 pAlp2);
	my $zs = [tan($t{pTheta})*cos($t{pPhi})*$t{pDz}, tan($t{pTheta})*sin($t{pPhi})*$t{pDz}, $t{pDz}];
	my $skin = $t{ModuleSkinThickness};
	my @raw;
	my $min_len = $t{pDz}*4;
	for (my $ix = 0; $ix < $t{NFiberX}; $ix++) {
		my $wix  = $ix/($t{NFiberX} - 1.);
		my $wdx1 = ($t{pDx1} - $skin - $r_out)*($wix*2 - 1);
		my $wdx2 = ($t{pDx2} - $skin - $r_out)*($wix*2 - 1);
		my $wdx3 = ($t{pDx3} - $skin - $r_out)*($wix*2 - 1);
		my $wdx4 = ($t{pDx4} - $skin - $r_out)*($wix*2 - 1);
		for (my $iy = 0; $iy < $t{NFiberY}; $iy++) {
			next if (($ix + $iy) % 2 == 1);   # triangular pattern
			my $wiy  = $iy/($t{NFiberY} - 1.);
			my $wdy1 = ($t{pDy1} - $skin - $r_out)*($wiy*2 - 1);
			my $wdy2 = ($t{pDy2} - $skin - $r_out)*($wiy*2 - 1);
			my $wdx12 = $wdx1*(1 - $wiy) + $wdx2*$wiy + $wdy1*tan($t{pAlp1});
			my $wdx34 = $wdx3*(1 - $wiy) + $wdx4*$wiy + $wdy1*tan($t{pAlp2});   # weighted_pDy1, as in sPHENIX
			my $v1  = vsub([$wdx12, $wdy1, 0], $zs);
			my $v2  = vadd([$wdx34, $wdy2, 0], $zs);
			my $vec = vsub($v2, $v1);
			my $mag = vmag($vec);
			$vec = vscale($vec, ($mag - $r_out)/$mag);   # fiber boundary protection
			my $cen = vscale(vadd($v1, $v2), 0.5);
			$min_len = vmag($vec) if vmag($vec) < $min_len;
			push(@raw, [$t{NFiberY}*$ix + $iy, $ix, $iy, $cen, $vec]);
		}
	}
	my @out;
	foreach my $f (@raw) {
		my ($fid, $ix, $iy, $cen, $vec) = @$f;
		my $opt = vmag($vec);
		$cen = vadd($cen, vscale($vec, ($min_len/$opt - 1)*0.5));
		$vec = vscale($vec, $min_len/$opt);
		my $subx = ($t{NSubtowerX} - 1) - int($ix/($t{NFiberX}/$t{NSubtowerX}));
		my $suby = ($t{NSubtowerY} - 1) - int($iy/($t{NFiberY}/$t{NSubtowerY}));
		push(@out, [$fid, $ix, $iy, $subx, $suby, $cen, $vec]);
	}
	return ($min_len, @out);
}

sub fiber_angles
{
	my $u = vscale($_[0], 1/vmag($_[0]));
	return (atan2($u->[1], $u->[2]), -asin($u->[0]));
}

sub solid_spacal_geometry
{
	my $var = $configuration{"variation"};

	# enclosure: cylinder_place * displacement(box_x_shift, 0, box_z_shift)
	my $zr = P("z_rotation_degree")/180*pi;
	my $encl_pos = vadd([P("xpos"), P("ypos"), P("zpos")], rotz([-($R + 0.5*$T) + $box_x_shift, 0, $box_z_shift], $zr));
	my ($ex, $ey, $ez, $et) = (P("enclosure_x"), P("enclosure_y"), P("enclosure_z"), P("enclosure_thickness"));
	put(name => "$D\_encl", mother => "root", pos => poscm($encl_pos), rot => rotrad(0, 0, -$zr),
	    color => $color_g10, type => "Box", mat => $mat_g10, style => 0,
	    dims => sprintf("%.6f*cm %.6f*cm %.6f*cm", $ex/2, $ey/2, $ez/2));
	put(name => "$D\_box", mother => "$D\_encl", color => $color_air, type => "Box", mat => $mat_air, visible => 0,
	    dims => sprintf("%.6f*cm %.6f*cm %.6f*cm", $ex/2 - $et, $ey/2 - $et, $ez/2 - $et));

	# electronics board (cylinder frame, displaced by (cos(a)*(R-LGmax) - thickness, 0, box_z_shift))
	my $a_half = 2*pi/$n_az*$nsec/2;
	my $el_t = P("electronics_thickness");
	put(name => "$D\_elec", mother => "$D\_box", color => $color_g10, type => "Box", mat => $mat_g10, style => 1,
	    pos => poscm([cos($a_half)*($R - $max_lg) - $el_t - $box_x_shift, 0, 0]),
	    dims => sprintf("%.6f*cm %.6f*cm %.6f*cm", $el_t/2, sin($a_half)*($R - $max_lg), $length/2));

	my @fl;     # per tower: [length, fibers...]
	for (my $j = 0; $j < $ntwr; $j++) { my @r = tower_fibers($j); push(@fl, \@r); }

	open(my $dump, ">", "$D\__fiberdump_$var.txt") or die;
	my $nrow = 0;
	for (my $s = 0; $s < $nsec; $s++) {
		# sector frame = cylinder frame * Rz(rot) * T(0,0,box_z_shift) (sPHENIX displaced Tubs); relative to _box
		my $rot = P("sector$s\_rotation");
		put(name => "$D\_SEC$s", mother => "$D\_box", pos => poscm([-$box_x_shift, 0, 0]), rot => rotrad(0, 0, -$rot),
		    color => $color_air, type => "Tube", mat => $mat_air, visible => 0,
		    dims => sprintf("%.6f*cm %.6f*cm %.6f*cm %.12f*rad %.12f*rad",
		                    $R - $max_lg, $R + $T, $length/2, pi/2 - pi/$n_az, 2*pi/$n_az));

		for (my $j = 0; $j < $ntwr; $j++) {
			my %t = map { $_ => P("tower$j\_$_") } qw(centralX centralY centralZ pRotationAngleX pDz pTheta pPhi
			                                          pDy1 pDx1 pDx2 pAlp1 pDy2 pDx3 pDx4 pAlp2
			                                          NSubtowerX NSubtowerY LightguideHeight LightguideTaperRatio);
			# Geant4 >= 10.7 G4Trap::MakePlanes aborts when a side face is non-planar by > tolerance.
			# With theta = alpha = 0 the +-X faces are planar iff (pDx2-pDx1)/pDy1 == (pDx4-pDx3)/pDy2;
			# the sPHENIX XML misses this by ~1e-5 mm. Use the planar pDx4 (fibers keep the original numbers).
			my $pDx4_planar = $t{pDx3} + ($t{pDx2} - $t{pDx1})*$t{pDy2}/$t{pDy1};
			printf("tower %d: pDx4 %.9f -> %.9f cm (shift %.3e mm) for G4Trap planarity\n",
			       $j, $t{pDx4}, $pDx4_planar, ($pDx4_planar - $t{pDx4})*10) if $s == 0;
			$t{pDx4} = $pDx4_planar;
			my $tpos = [$t{centralX}, $t{centralY}, $t{centralZ} - $box_z_shift];
			my $trot = rotrad(-$t{pRotationAngleX}, 0, 0);
			put(name => "$D\_TWR$s\_$j", mother => "$D\_SEC$s", pos => poscm($tpos), rot => $trot,
			    color => $color_abs, type => "G4Trap", mat => $mat_abs, style => 0,
			    dims => sprintf("%.10f*cm %.12f*rad %.12f*rad %.10f*cm %.10f*cm %.10f*cm %.12f*rad %.10f*cm %.10f*cm %.10f*cm %.12f*rad",
			                    $t{pDz}, $t{pTheta}, $t{pPhi}, $t{pDy1}, $t{pDx1}, $t{pDx2}, $t{pAlp1},
			                    $t{pDy2}, $t{pDx3}, $t{pDx4}, $t{pAlp2}));

			# fibers (variation "nofiber" skips them: Geant4 overlap check of sectors/towers/light guides only)
			my ($flen, @fibers) = ($var eq "nofiber") ? (0) : @{$fl[$j]};
			my $first = 1;
			foreach my $f (@fibers) {
				my ($fid, $ix, $iy, $subx, $suby, $cen, $vec) = @$f;
				my $ch = 100000*($s + 1) + 10000*$j + $fid;   # fiber code (clad ncopy)
				my ($fa, $fb) = fiber_angles($vec);
				if ($s == 0) {
					# self-check: direction rebuilt from the GEMC angles (M^-1 z)
					my $u = [-sin($fb), cos($fb)*sin($fa), cos($fb)*cos($fa)];
					printf $dump ("%d %d %d %d %d %d % .8f % .8f % .8f % .8f % .8f % .8f %.8f\n",
					              $j, $fid, $ix, $iy, $subx, $suby, @$cen, @{vscale($u, $flen)}, $flen);
				}
				if ($s == 0 && $first) {
					put(name => "$D\_CHa$j", mother => "$D\_TWR$s\_$j", pos => poscm($cen), rot => rotrad($fa, $fb, 0),
					    color => $color_fiber, type => "Tube", mat => $mat_clad, ncopy => $ch, visible => $vis_fiber,
					    dims => sprintf("0*cm %.6f*cm %.10f*cm 0*deg 360*deg", $r_out, $flen/2));
					put(name => "$D\_core$j", mother => "$D\_CHa$j",
					    color => $color_fiber, type => "Tube", mat => $mat_core, visible => 0,
					    dims => sprintf("0*cm %.6f*cm %.10f*cm 0*deg 360*deg", $core_r, $flen/2),
					    sens => "solid_spacal", ids => "CH ncopy 0");
					$first = 0;
				} else {
					put(name => "$D\_CHb$s\_$j\_$fid", mother => "$D\_TWR$s\_$j", pos => poscm($cen), rot => rotrad($fa, $fb, 0),
					    color => $color_fiber, type => "CopyOf $D\_CHa$j", mat => $mat_clad, ncopy => $ch, visible => $vis_fiber);
				}
				$nrow++;
			}

			# light guides (sPHENIX Construct_LightGuide), placed with the tower transform + displaced solid
			for (my $ix = 0; $ix < $t{NSubtowerX}; $ix++) {
				for (my $iy = 0; $iy < $t{NSubtowerY}; $iy++) {
					my ($nsx, $nsy) = ($t{NSubtowerX}, $t{NSubtowerY});
					my $wx1 = 1 - $iy/$nsy;
					my $wx2 = 1 - ($iy + 1)/$nsy;
					my $wxc = 1 - ($iy + 0.5)/$nsy;
					my $lg_pDx1 = ($t{pDx1}*$wx1 + $t{pDx2}*(1 - $wx1))/$nsx;
					my $lg_pDx2 = ($t{pDx1}*$wx2 + $t{pDx2}*(1 - $wx2))/$nsx;
					my $lg_pDy1 = $t{pDy1}/$nsy;
					my $lg_Alp1 = atan(($t{pDx2} - $t{pDx1})*(-$nsx + 1. + 2*$ix)/$nsx/(2.*$t{pDy1}) + tan($t{pAlp1}));
					my $shift_xc = ($t{pDx1}*$wxc + $t{pDx2}*(1 - $wxc))*(-$nsx + 1. + 2*$ix)/$nsx;
					my $shift_yc = $t{pDy1}*(-$nsy + 1. + 2*$iy)/$nsy;
					my $h  = $t{LightguideHeight};
					my $tr = $t{LightguideTaperRatio};
					my $disp = vadd(vscale([tan($t{pTheta})*cos($t{pPhi}), tan($t{pTheta})*sin($t{pPhi}), 1], -$t{pDz}),
					                [$shift_xc, $shift_yc, -0.5*$h]);
					my $lpos = vadd($tpos, rotx($disp, $t{pRotationAngleX}));
					put(name => "$D\_LG$s\_$j\_$ix\_$iy", mother => "$D\_SEC$s", pos => poscm($lpos), rot => $trot,
					    color => $color_lg, type => "G4Trap", mat => $mat_lg, style => 1,
					    dims => sprintf("%.10f*cm 0*rad 0*rad %.10f*cm %.10f*cm %.10f*cm %.12f*rad %.10f*cm %.10f*cm %.10f*cm %.12f*rad",
					                    0.5*$h, $tr*$lg_pDy1, $tr*$lg_pDx1, $tr*$lg_pDx2, $lg_Alp1,
					                    $lg_pDy1, $lg_pDx1, $lg_pDx2, $lg_Alp1));
				}
			}
		}
	}
	close($dump);
	print "Built $nsec sectors x $ntwr towers, $nrow fiber placements\n";
}

1;
