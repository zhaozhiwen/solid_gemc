# ec_segmented_separated

EC for SoLID lite: a copy of `../ec_segmented_moved` with the forward-angle EC made smaller, Rmax 240 -> 220 cm. PVDIS and the large-angle EC are unchanged. Polar angles are relative to the target center (SIDIS z = -350 cm, PVDIS z = 10 cm), taken at the z of the shower module center (`z_shower`).

Used by `../../script/solid_JPsi_LH2_lite_full.gcard`.

## how to make the text files

To produce ec text files, scripts run slightly differently than typical gemc detector construction.
We use one standard config.dat, then specify detector name as option as follow

    ./solid_ec.pl solid_PVDIS_ec_forwardangle
    ./solid_ec.pl solid_SIDIS_ec_forwardangle
    ./solid_ec.pl solid_SIDIS_ec_largeangle

## layout

layout according to ANL design for ec_forwardangle in "analysis/ec_layout"
each module is according to ANL drawing "./drawing/200318*pdf"

ANL ec_layout has 1748 modules.
Actual layout is determined by choosing only modules whose center radius is between Rmin and Rmax according to nominal acceptance (set in each `*__parameters_Original.txt`).
The resulting number of modules are as follows

| detector | N of modules | Rmin (cm) | Rmax (cm) | z_shower (cm) | polar angle (deg) |
|---|---|---|---|---|---|
| solid_PVDIS_ec_forwardangle | 1697 | 100 | 265 | 360 | 15.9-37.1 |
| solid_SIDIS_ec_forwardangle | 1145 | 95 | 220 | 467 | 6.6-15.1 |
| solid_SIDIS_ec_largeangle | 307 | 83 | 137 | -35 | 14.8-23.5 |

Note this is only a rough way to choose modules, more careful physics performance study to determine the final numbers.

## log

2022/03/31 by Zhiwen Zhao
add 6mm diameter rod and simplify scripts

2026/10/25 by Zhiwen Zhao
copied from ../ec_segmented_moved for SoLID lite; SIDIS forwardangle Rmax 240 -> 220 cm (1413 -> 1145 modules, outer edge 16.4 -> 15.1 deg).
Also fixed the module table copied from ../ec_segmented_moved/readme, which had the PVDIS and SIDIS forwardangle Rmin/Rmax swapped (PVDIS is 100-265 cm, SIDIS was 95-240 cm).
