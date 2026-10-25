#!/usr/bin/perl -w
use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_solenoid';

my $DetectorMother="root";

sub solid_solenoid
{
make_yoke();
make_coil_collars();
}

sub make_yoke
{
# modeled after CLEO-II, no modification

 my $NUM  = 4;
 my @name =
 ("InnerOctagon","OuterOctagon","SpacerBarUpstream","SpacerBarDownstream");
 my @exist = (1,1,1,1);
 my $material_yoke = "G4_Fe";
#  my $color_yoke = "F63BFF";
 my @color_yoke = ("F63BFF","F63BFF","F63BFF","F63BFF");
 
 for(my $n=1; $n<=$NUM; $n++)
 {
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = $DetectorMother;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    
    if ($n<=6) {$detector{"rotation"}   = "0*deg 0*deg 22.5*deg";}
    else  {$detector{"rotation"}   = "0*deg 0*deg 0*deg";}
    
#     $detector{"color"} = $color_yoke;
    $detector{"color"} = $color_yoke[$n-1];
    
    if ($n<=6) {$detector{"type"}       = "Pgon";}
    else  {$detector{"type"}       = "Polycone";}
    
    if ($n==1) {$detector{"dimensions"} = "0*deg 360*deg 8*counts 2*counts 191.075*cm 191.075*cm 230.142*cm 230.142*cm -266.7*cm 266.7*cm";} # Inner Octagon, no modification
    if ($n==2) {$detector{"dimensions"} = "0*deg 360*deg 8*counts 2*counts 239.763*cm 239.763*cm 278.832*cm 278.832*cm -266.7*cm 266.7*cm";} # Outer Octagon, no modification
    if ($n==3) {$detector{"dimensions"} = "0*deg 360*deg 8*counts 2*counts 230.142*cm 230.142*cm 239.763*cm 239.763*cm -266.7*cm -241.2*cm";} # spacer bar upstream   
    if ($n==4) {$detector{"dimensions"} = "0*deg 360*deg 8*counts 2*counts 230.142*cm 230.142*cm 239.763*cm 239.763*cm 241.2*cm 266.7*cm";} # spacer bar downstream, mirror of upstream
    
    $detector{"material"} = $material_yoke;
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}	     = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = $exist[$n-1];
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "no";
    $detector{"identifiers"} = "no";
    print_det(\%configuration, \%detector);
 }
}

sub make_coil_collars
{
# Upstream and downstream coil collars: octagon outside, round bore at r=144cm inside
# each built as boolean (solid octagon) - (tube), components are not placed

 my @collar = (
   ["UpstreamCoilCollar",   "-266.7*cm -189.23*cm"],
   ["DownstreamCoilCollar", "189.23*cm 266.7*cm"],
 );
 for my $col (@collar)
 {
  my ($cname, $zplanes) = @$col;
  my @comp = (
    ["$cname\_pgon", "Pgon", "0*deg 360*deg 8*counts 2*counts 0*cm 0*cm 191.075*cm 191.075*cm $zplanes"],
    ["$cname\_hole", "Tube", "0*cm 144*cm 300*cm 0*deg 360*deg"],
  );
  for my $c (@comp)
  {
    my %detector=init_det();
    $detector{"name"}        = "$DetectorName\_$c->[0]";
    $detector{"mother"}      = $DetectorMother;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}         = "0*cm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "F63BFF";
    $detector{"type"}        = $c->[1];
    $detector{"dimensions"}  = $c->[2];
    $detector{"material"}    = "Component";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "no";
    $detector{"identifiers"} = "no";
    print_det(\%configuration, \%detector);
  }

  my %detector=init_det();
  $detector{"name"}        = "$DetectorName\_$cname";
  $detector{"mother"}      = $DetectorMother;
  $detector{"description"} = $detector{"name"};
  $detector{"pos"}         = "0*cm 0*cm 0*cm";
  $detector{"rotation"}    = "0*deg 0*deg 22.5*deg";
  $detector{"color"}       = "F63BFF";
  $detector{"type"}        = "Operation:@ $DetectorName\_$cname\_pgon - $DetectorName\_$cname\_hole";
  $detector{"dimensions"}  = "0";
  $detector{"material"}    = "G4_Fe";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = 1;
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "no";
  $detector{"hit_type"}    = "no";
  $detector{"identifiers"} = "no";
  print_det(\%configuration, \%detector);
 }
}

