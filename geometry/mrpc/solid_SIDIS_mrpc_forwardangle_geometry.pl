use strict;
use warnings;
our %detector;
our %configuration;
our %parameters;

use Getopt::Long;
use Math::Trig;

my $DetectorName = 'solid_SIDIS_mrpc_forwardangle';

my $DetectorMother="root";

my $z		= $parameters{"z"};
my $Rmin	= $parameters{"Rmin"};
my $Rmax	= $parameters{"Rmax"};
my $Dz   	= $parameters{"Dz"}; # half thickness

my $sen="solid_mrpc";

sub solid_SIDIS_mrpc_forwardangle
{
mrpc();
}

# MRPC structure
# Atucal: First Layer: 6mm Honeycomb + 0.8mm PCB                  (1)+(2)
#                     + Mylar 0.15mm + Electrode 0.4mm            (3)+(4) 
#                        + Glass 0.7mm + Gas 0.25mm               (5)+(6)
#                        + Glass 0.7mm + Gas 0.25mm               (7)+(8)
#                        + Glass 0.7mm + Gas 0.25mm               (9)+(10)
#                        + Glass 0.7mm + Gas 0.25mm               (11)+(12)
#                        + Glass 0.7mm + Gas 0.25mm + Glass 0.7mm (13)+(14)+(15)
#                     + Electrode 0.4mm + Mylar 0.15mm + 1.6mm PCB(16)+(17)+(18)
#                 
#       Second Layer:  Mylar 0.15mm + Electrode 0.4mm             ()+()
#                        + Glass 0.7mm + Gas 0.25mm               ()+()
#                        + Glass 0.7mm + Gas 0.25mm               ()+()
#                        + Glass 0.7mm + Gas 0.25mm               ()+()
#                        + Glass 0.7mm + Gas 0.25mm               ()+()
#                        + Glass 0.7mm + Gas 0.25mm + 0.7mm Glass ()+()+()
#                     + 0.4mm Electrode + 0.15mm Mylar            ()+()
#                     + 0.8mm PCB + 6mm Honey comb                ()+()

sub mrpc
{ 
 my $Nlayer = 35;
 my @layer_thickness = (0.6,0.08,0.015,0.04,0.07,0.025,0.07,0.025,0.07,0.025,0.07,0.025,0.07,0.025,0.07,0.04,0.015,0.16,0.015,0.04,0.07,0.025,0.07,0.025,0.07,0.025,0.07,0.025,0.07,0.025,0.07,0.04,0.015,0.08,0.6);
 my @material = ("SL_mrpc_AlHoneycomb","SL_mrpc_PCBoardM","SL_mrpc_MMMylar","G4_GRAPHITE","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","G4_GRAPHITE","SL_mrpc_MMMylar","SL_mrpc_PCBoardM","SL_mrpc_MMMylar","G4_GRAPHITE","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","SL_mrpc_Gas","G4_GLASS_PLATE","G4_GRAPHITE","SL_mrpc_MMMylar","SL_mrpc_PCBoardM","SL_mrpc_AlHoneycomb");
 my $color="00ff00";

    my %detector=init_det();
    $detector{"name"}        = "$DetectorName";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "111111";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"}  = "$Rmin*cm $Rmax*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "Vacuum";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 0;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "no";
    $detector{"identifiers"} = "no";
    print_det(\%configuration, \%detector);

    my $counter_gas=0;
    my $counter_glass=0;

    for(my $i=1; $i<=$Nlayer; $i++)
    {
	my $layerZ = -$Dz;
	for(my $k=1; $k<=$i-1; $k++)
	{	
	   $layerZ = $layerZ+$layer_thickness[$k-1];
	}
	$layerZ = $layerZ+$layer_thickness[$i-1]/2;
	
	my $DlayerZ=$layer_thickness[$i-1]/2;

	my %detector=init_det();
	$detector{"name"}        = "$DetectorName\_$i";
	$detector{"mother"}      = "$DetectorName";
	$detector{"description"} = $detector{"name"};
	$detector{"pos"}        = "0*cm 0*cm $layerZ*cm";
	$detector{"rotation"}   = "0*deg 0*deg 0*deg";
	$detector{"color"}      = "$color";
	$detector{"type"}       = "Tube";
	$detector{"dimensions"} = "$Rmin*cm $Rmax*cm $DlayerZ*cm 0*deg 360*deg";
	$detector{"material"}   = "$material[$i-1]";
	$detector{"mfield"}     = "no";
	$detector{"ncopy"}      = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	if ($detector{"material"} eq "SL_mrpc_Gas")
	{
	  $detector{"sensitivity"} = "$sen";
	  $detector{"hit_type"}    = "$sen";
	  $counter_gas=$counter_gas+1;
	  my $id=4100000+$counter_gas;
	  $detector{"identifiers"} = "id manual $id";
	}
	elsif ($detector{"material"} eq "G4_GLASS_PLATE")
	{
	  $detector{"sensitivity"} = "$sen";
	  $detector{"hit_type"}    = "$sen";
	  $counter_glass=$counter_glass+1;
	  my $id=4120000+$counter_glass;
	  $detector{"identifiers"} = "id manual $id";
	}
	else{
	  $detector{"sensitivity"} = "no";
	  $detector{"hit_type"}    = "no";
	  $detector{"identifiers"} = "no";
	}
	print_det(\%configuration, \%detector);
    }
}
