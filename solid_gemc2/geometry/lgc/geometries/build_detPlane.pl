#Made to build a cylindrical detplane where you like
sub makeDetPlanes
{
    $detector{"name"}        = $namePre."_detplane";
    $detector{"mother"}      = $detMom;
    $detector{"description"} = "det_plane";
    $detector{"pos"}         = "0.0*cm 0.0*cm 10.0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "319890";
    $detector{"type"}        = "Sphere";
    $detector{"dimensions"}  = "200.0*cm 200.0001*cm 0*deg 1800*deg 20*deg 36*deg";
    $detector{"material"}    = "Vacuum";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "FLUX";
    $detector{"hit_type"}    = "FLUX";
    $detector{"identifiers"} = "id manual 1";
    print_det(\%configuration, \%detector);
}1;
