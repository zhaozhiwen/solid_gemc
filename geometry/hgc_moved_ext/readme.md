# SoLID lite light gas Cherenkov simulation setup

Here is the SoLID lite light gas Cherenkov simulation setup using "solid_gemc" which is the SoLID simulation program based on GEMC

hgc name is kept to minimize the text changes, but it don't have its original meaning any more

## changes from ../hgc_moved

- gas is `SL_LGCCgas_SIDIS` (CO2 at 1 atm, refractive index and absorption length tables in `solid_SIDIS_hgc_materials.pl`) instead of `SL_HGC_C4F8O`
- the chamber and gas polycones get a front section at r 60-140 cm (gas 61-139 cm), z 205-270 cm, with a 1 mm front window inside the gas at z 205-205.1016 cm, r 61.02-139 cm
- the main chamber is r 77-187 cm at its upstream side (was 190-240 cm) and starts at z 317 cm (was 326 cm)

../hgc_moved_extshift is the same with the front section 40 cm further downstream.

## the setup

The setup gives a complete definition of the detector.

detector definition are in text files.
It include geometry and sensitivity,material,mirror,hit,bank definition.
The perl scripts is used to produce these text files.
The parameter text file has all external parameters and it can be editted by hand.

After setting up env, a perl script will call other perl scripts and use parameter file to produce all other text files by running command below
./solid_SIDIS_hgc.pl config_solid_SIDIS_hgc.dat

The hit definition, bank definitions and corresponding hit processing routine "solid_hgc" of "solid_gemc" have to match to produce meaningful result.
Any change in hit definition and bank definition, you need to modify the source code "solid_hgc" accordingly and recompile "solid_gemc" by following instruction there

## log

optics designed by Bo Yu and Zhiwen Zhao in 2018
