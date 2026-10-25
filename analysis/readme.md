Here is a set of scripts to process root tree output from solid_gemc

individual detector response is handled in their function
analysis_tree_solid_lgc.C
analysis_tree_solid_hgc.C
analysis_tree_solid_ec.C
analysis_tree_solid_spd.C
analysis_tree_solid_mrpc.C

Then they are used for various analysis by
analysis_PVDIS.C
analysis_SIDIS.C
analysis_simple.C

run the scripts after compilation to avoid error and slowness
see the example scripts below
getnumber_SIDIS_He3
getnumber_SIDIS_NH3
getnumber_JPsi
getnumber_PVDIS
getnumber_simple

other scripts
plot_gem_r.C   make gem rate plots with output from analysis_simple.C

