sub rotateX
{
#rotateX(vector or matrix) returns either a matrix that has been rotated about x by the given angle
    my $rotM= Math::MatrixReal->new_from_rows( [ [1,0,0], [0,cos($_[1]),-sin($_[1])], [0, sin($_[1]), cos($_[1])] ] );
    $rotM*$_[0];
}1;

sub rotateY
{
    my $rotM = Math::MatrixReal->new_from_rows( [ [cos($_[1]),0,sin($_[1])], [0,1,0], [-sin($_[1]), 0, cos($_[1])] ] );
    $rotM*$_[0];
}1;

sub rotateZ
{
    my $rotM = Math::MatrixReal->new_from_rows( [ [cos($_[1]),-sin($_[1]), 0], [sin($_[1]), cos($_[1]), 0], [0,0,1] ] );
    $rotM*$_[0];
}1;

sub rotateZv #same but for vector
{
    my $nxV = vector(cos($_[1]),-sin($_[1]), 0);
    my $nyV = vector(sin($_[1]), cos($_[1]), 0);
    my $nzV = vector(0, 0, 1);
    my $rotM = vector_matrix($nxV, $nyV, $nzV);
    $_[0]*$rotM;
}1;

sub rotateYv #same but for vector
{
    my $nxV = vector(cos($_[1]), 0, sin($_[1]));
    my $nzV = vector(-sin($_[1]), 0, cos($_[1]));
    my $nyV = vector(0, 1, 0);
    my $rotM = vector_matrix($nxV, $nyV, $nzV);
    $_[0]*$rotM;
}1;

sub rotateXv #same but for vector
{
    print "$_[0]  $_[1]\n";
    my $nyV = vector(0, cos($_[1]),-sin($_[1]));
    my $nzV = vector(0, sin($_[1]), cos($_[1]));
    my $nxV = vector(1, 0, 0);
    my $rotM = vector_matrix($nxV, $nyV, $nzV);
    $_[0]*$rotM;

  #  print "$_[0]*$rotM\n";
}1;

sub VMconvert #converts MatrixReal to the VectorReal matrix_vector
{
    my $nxV = $_[0]->matrix_row2vector(0);
    my $nyV = $_[0]->matrix_row2vector(1);
    my $nzV = $_[0]->matrix_row2vector(2);
    my $M = vector_matrix($nxV, $nyV, $nzV);
    $M;
}1;


sub buildSPmirror
{
#routine to get correct mirror variables
#give the 3-vect P1, P2, V0, and also the mirror Z.
#returns the 3-vect POS, and the radius R

#read in variables
    my $P1V;  # 3-vect containing the target vertex info
    my $P2V;  # 3-vect containing the central position of the observer (pmt array).
    my $centAng;  # central angle from target center to mirror center.
    my $Z;  # target center z-position
    my $edit_rot = 0;
    my $edit_R = 0;

    $P1V = $_[0];
    $P2V = $_[1];
    $centAng = $_[2]*$D2R;
    $Z = $_[3];
    $edit_rot = $_[4];  #if "1", then change parameters...  if "0" or not given, then use nominal.
    $edit_R = $_[5];  #if "1", then change parameters...  if "0" or not given, then use nominal.

#internal created variables
    my $V0V;	# normal vector containing central angle.
    my $ViV;	# incident vector w.r.t the source
    my $PmV;	# crossing point on mirror plane w.r.t the origin of coordinates
    my $VrV;	# reflected vector
    my $VnV;	# unitary normal vector
    my $ang_cos;  # angle between the normal and initial.
    
    
    $V0V = vector(0, sin($centAng), cos($centAng)); 
    $ViV = (($Z - $P1V->z())/$V0V->z())*$V0V;
    $PmV = $P1V + $ViV;
    $VrV = $P2V - $PmV;
    $VnV = $VrV->norm - $ViV->norm; 
    
    # play with rotating the unitary normal vector
    if($edit_rot){
        $VnV = &rotateXv($VnV, $edit_rot*$D2R);
    }
    $VnV = $VnV->norm;
    $ang_cos = -($ViV . $VnV)/($ViV->length);
    
    

#global return variables

#return R:
    $R = 2.0/($ang_cos*(1.0/$ViV->length + 1.0/$VrV->length));  # Here R is the radius of the sphere
    
  #if we want to "defocus" we can adjust $R here to be larger

    if($edit_R){
	  $R = $edit_R*$R;
    }

#and return PosV
    $PosV = $PmV + $R*$VnV;  # PosV is the center of the sphere in space.   
    
#    print "$R\n";
#    print "$PosV\n";
#    print $ViV->length." \n";
#    print "$Z \n";
#    print $P1V->z()." \n";
#    print $V0V->z()." \n";
#    print "$ang_cos \n";

}1;

sub mirrorRot
{
    print "starting mirror rotation\n";

    my $centAng;
    my $posVec;
    my $degRot;
    my $zvert;
    my $mirrorZ;
    
    $centAng = $_[0];
    $posVec = $_[1];
    $degRot = $_[2];
    $zvert  =$_[3];
    $mirrorZ = $_[4];
    
    my $mPoint = vector(0, $PosV->y() - sqrt($R*$R - ($mirrorZ - $PosV->z())*($mirrorZ - $PosV->z())), $mirrorZ);
    my $dVec = $mPoint - $posVec;
    my $Rloc = $dVec->length();
    my $delta = vector(0.0, 0.0, 0.0);
    my $alpha = 0;
    my $beta = $D2R*$degRot/2.0;
    my $dVecy = $dVec->y(); #;#because of weird highlighting in textWrangler... ignore
    
    print $dVec->z()."   ".$dVecy."\n";

    if($dVecy <=0){
        if($degRot > 0){
            $alpha = 3.1415 - asin($dVec->z()/$Rloc) - acos(sin($beta));
	    $delta = vector(0.0, 2.0*$Rloc*cos($alpha)*sin($beta), 2.0*$Rloc*sin($alpha)*sin($beta));
        }
        if($degRot < 0){
            $alpha = 3.1415 - asin(-$dVecy/$Rloc) - acos(sin(-$beta));
            $delta = vector(0.0, -2.0*$Rloc*sin($alpha)*sin(-$beta), -2.0*$Rloc*cos($alpha)*sin(-$beta));
        }
    }
    if($dVecy >=0){
        if($degRot < 0){
            $alpha = 3.1415 - asin($dVec->z()/$Rloc) - acos(sin(-$beta));
            $delta = vector(0.0, -2.0*$Rloc*cos($alpha)*sin(-$beta), 2.0*$Rloc*sin($alpha)*sin(-$beta));
        }
        if($degRot > 0){
            $alpha = 3.1415 - asin($dVecy/$Rloc) - acos(sin($beta));
            $delta = vector(0.0, 2.0*$Rloc*sin($alpha)*sin($beta), -2.0*$Rloc*cos($alpha)*sin($beta));
        }
    }
    
    
    
    print "alpha is $alpha\n";
    print "delta pos: ".$delta."\n";
    #to double check:
    
    print "dR is : ".($R - $Rloc)."\n";
    print "dTheta is : ".(asin(0.5*$delta->length()/$Rloc)*2*(1/$D2R) - $degRot)."\n";
    print "L is: ".($delta->length())."\n";
    print "R is: ".$Rloc."\n";
 
    #return:
    $delta;
}1;

sub calcIntPoints
{
#this subroutine finds the intersection points of the cone segment corners on the sphere that contructs the mirror.  The output is useful for getting mirror dimensions.

#first take the paramters of the incoming cone segment:
    my $sphereR;
    my $sphereV;

    my $coneV;
    my $coneZh;
    my $coneRin1;
    my $coneRout1;
    my $coneRin2;
    my $coneRout2;
    my $coneAngIn;
    my $coneAngOut;
    my $rotAng = 0;

    $sphereR = $_[0];
    $sphereV = $_[1];
    $coneV = $_[2];
    $coneZh = $_[3];
    $coneRin1 = $_[4];
    $coneRout1 = $_[5];
    $coneRin2 = $_[6];
    $coneRout2 = $_[7];
    $coneAngIn = 84.0;
    $coneAngOut = 84.0 + 12.0;

    if($_[8]){
	$rotAng = $_[8];
    }


#ok, so we need to calculate all 4 intersection points, so we need all 4 edges of the cone segments as rays:

    my @ray1p;
    my @ray2p;

    $ray1p[0] = vector($coneRin1*cos($coneAngIn*$D2R), $coneRin1*sin($coneAngIn*$D2R), $coneV->z() - $coneZh);
    $ray1p[1] = vector($coneRin1*cos($coneAngOut*$D2R), $coneRin1*sin($coneAngOut*$D2R), $coneV->z() - $coneZh);
    $ray1p[2] = vector($coneRout1*cos($coneAngIn*$D2R), $coneRout1*sin($coneAngIn*$D2R), $coneV->z() - $coneZh);
    $ray1p[3] = vector($coneRout1*cos($coneAngOut*$D2R), $coneRout1*sin($coneAngOut*$D2R), $coneV->z() - $coneZh);

    $ray2p[0] = vector($coneRin2*cos($coneAngIn*$D2R), $coneRin2*sin($coneAngIn*$D2R), $coneV->z() + $coneZh);
    $ray2p[1] = vector($coneRin2*cos($coneAngOut*$D2R), $coneRin2*sin($coneAngOut*$D2R), $coneV->z() + $coneZh);
    $ray2p[2] = vector($coneRout2*cos($coneAngIn*$D2R), $coneRout2*sin($coneAngIn*$D2R), $coneV->z() + $coneZh);
    $ray2p[3] = vector($coneRout2*cos($coneAngOut*$D2R), $coneRout2*sin($coneAngOut*$D2R), $coneV->z() + $coneZh);
 
    my $transV;
    my $tempos = vector(0,0,$coneV->z() - 250.5);

    if($rotAng){
	for(my $i =0; $i < 4; $i++){
	    $ray1p[$i] -= $tempos;
	    $ray1p[$i] -= $coneV;
	    $ray1p[$i] =  &rotateXv($ray1p[$i], $rotAng*$D2R);
	    print "$ray1p[$i] \n";
	    $ray1p[$i] += $coneV;


	    $ray2p[$i] -= $tempos;
	    $ray2p[$i] -= $coneV;
	    $ray2p[$i] =  &rotateXv($ray2p[$i], $rotAng*$D2R);
	    $ray2p[$i] += $coneV;
	}
    }

#ok, now we need to calculate the intersection points for each:

    my @rayR0;  #origin of ray
    my @rayRd;  #slope of ray;

#some useful substitution variables:
    my $A;
    my $B;
    my $C;

    my $t0;
    my $t1;
    my @int1;
    my @int2;


    for(my$i = 0; $i < 4; $i++){


	$rayRd[$i] = ($ray2p[$i] - $ray1p[$i])->norm;
	$rayR0[$i] = $ray1p[$i];

#	print "rayd: $rayRd[$i]\n";

	$A = $rayRd[$i] . $rayRd[$i];
	$B = 2*(($rayR0[$i] - $sphereV) . $rayRd[$i]);
	$C = ($rayR0[$i] - $sphereV) . ($rayR0[$i] - $sphereV) - $sphereR*$sphereR;
	#and solve quadratic equation At^2 + Bt + C = 0

	$t0 = (-$B - sqrt($B*$B - 4*$A*$C))/(2*$A);
	$t1 = (-$B + sqrt($B*$B - 4*$A*$C))/(2*$A);

	$int1[$i] = $rayR0[$i] + $t0*$rayRd[$i];
	$int2[$i]= $rayR0[$i] + $t1*$rayRd[$i];

	print "for ray $i, int points are $int1[$i], and $int2[$i]\n";
    }

    my $inL = ($int2[0] - $int2[1])->length;
    my $depth = ($int2[2] - $int2[1])->length;
    my $outL = ($int2[3] - $int2[2])->length;

    print " inner length: $inL\n depth: $depth\n outer length: $outL\n";

    print "\n";
    my $iny = $int2[0]->y();
    my $inz = $int2[0]->z();
    my $outy = $int2[2]->y();
    my $outz = $int2[2]->z();
    print " mirror inside y,z: $iny  $inz \n mirror outside y,z: $outy  $outz \n";


}1;

#sector map for numbering purposes, input n, output true sector:

sub sec
{
	31 - $_[0];
};
