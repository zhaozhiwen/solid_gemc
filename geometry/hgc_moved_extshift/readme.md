# SoLID lite light gas Cherenkov simulation setup

Here is the SoLID lite light gas Cherenkov simulation setup using "solid_gemc" which is the SoLID simulation program based on GEMC

hgc name is kept to minimize the text changes, but it don't have its original meaning any more

## changes from ../hgc_moved_ext

Same as ../hgc_moved_ext (CO2 gas, front section at r 60-140 cm, main chamber r 77-187 cm from z 317 cm), except the front section is 40 cm further downstream: z 245-310 cm, front window at z 245-245.1016 cm.

## shift it 40 cm upstream at run time

This geometry must be shifted 40 cm upstream in the gcard. The front section then sits at z 205-270 cm as in ../hgc_moved_ext, and the main chamber starts at z 277 cm.

A gcard `<position>` is a displacement added to one volume, matched by volume name (gemc `detector_factory.cc`), so a `<position>` inside the `<detector name="../geometry/...">` line moves nothing. Shift the two volumes placed in root:

    <detector name="../geometry/hgc_moved_extshift/solid_SIDIS_hgc" factory="TEXT" variation="Original"/>
    <detector name="solid_SIDIS_hgc_chamber">
      <position x="0*cm" y="0*cm" z="-40*cm"/>
    </detector>
    <detector name="solid_SIDIS_hgc_virtualplane_front">
      <position x="0*cm" y="0*cm" z="-40*cm"/>
    </detector>

All other volumes are daughters of the chamber and move with it.

## variations

| variation | sectors with cone, shieldback, pmt and mirror |
|---|---|
| `Original` | all 30 |
| `4seg2sec` | 4,5,11,12,19,20,26,27 (4 segments of 2 sectors) |

Chamber, gas, front window, virtual plane and the two support blocks (in sectors 1 and 16) are in both. Materials, mirrors and hit are the same. The sector list is `%sectors_of_variation` in `solid_SIDIS_hgc_geometry.pl`.

Make the text files of both variations, in this dir:

    ./solid_SIDIS_hgc.pl config_solid_SIDIS_hgc.dat

Use one of them in the gcard:

    <detector name="../geometry/hgc_moved_extshift/solid_SIDIS_hgc" factory="TEXT" variation="Original"/>
    <detector name="../geometry/hgc_moved_extshift/solid_SIDIS_hgc" factory="TEXT" variation="4seg2sec"/>

plus the two 40 cm `<position>` shifts above.

## the setup

The setup gives a complete definition of the detector.

detector definition are in text files.
It include geometry and sensitivity,material,mirror,hit,bank definition.
The perl scripts is used to produce these text files.
The parameter text file has all external parameters and it can be editted by hand.

After setting up env, a perl script will call other perl scripts and use parameter file to produce all other text files by running command below
./solid_SIDIS_hgc.pl config_solid_SIDIS_hgc.dat
(it writes both variations, Original and 4seg2sec)

The hit definition, bank definitions and corresponding hit processing routine "solid_hgc" of "solid_gemc" have to match to produce meaningful result.
Any change in hit definition and bank definition, you need to modify the source code "solid_hgc" accordingly and recompile "solid_gemc" by following instruction there

## log

optics designed by Bo Yu and Zhiwen Zhao in 2018
