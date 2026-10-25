# gem_separated

SIDIS GEM for SoLID lite, split into two detectors that can be loaded separately. Polar angles are relative to the SIDIS target center at z = -350 cm.

- `solid_SIDIS_LA_gem`: large-angle GEM, 4 planes, covers 14-25 deg
- `solid_SIDIS_FA_gem`: forward-angle GEM, 5 planes, covers 6-14 deg

Started from `../gem_moved/solid_SIDIS_{LA,FA}_gem*`. Plane positions and sizes are in the parameter files; the GEM module (layers, materials) is the same as in `../gem_moved`.

Wiki: https://solid.jlab.org/wiki/index.php/GEM_Digitization and https://solid.jlab.org/wiki/index.php/Solid_Tracking

## files

| | LA | FA |
|---|---|---|
| driver | `solid_SIDIS_LA_gem.pl` | `solid_SIDIS_FA_gem.pl` |
| geometry, virtual planes | `solid_SIDIS_LA_gem_geometry.pl`, `_virtualplane.pl` | `solid_SIDIS_FA_gem_geometry.pl`, `_virtualplane.pl` |
| plane z, Rin, Rout | `solid_SIDIS_LA_gem__parameters_Original.txt` | `solid_SIDIS_FA_gem__parameters_Original.txt` |
| generated | `solid_SIDIS_LA_gem__{geometry,materials,hit,bank}*` | `solid_SIDIS_FA_gem__{geometry,materials,hit,bank}*` |

Both drivers share `solid_gem_materials.pl`, `solid_gem_hit.pl` and `solid_gem_bank.pl`.

Used by `../../script/solid_JPsi_LH2_lite_full.gcard`.

## how to make the text files

After setting up the env (`$GEMC`), run in this dir

    ./solid_SIDIS_LA_gem.pl config_solid_SIDIS_LA_gem.dat
    ./solid_SIDIS_FA_gem.pl config_solid_SIDIS_FA_gem.dat

Edit the parameter file, then rerun the driver: gemc reads only the generated text files.

## planes

Rin = (350+z) tan(theta_min) rounded down and Rout = (350+z) tan(theta_max) rounded up, with theta measured from the SIDIS target center at z = -350 cm. z is in the hall frame, in cm.

| detector | plane | z | Rin | Rout |
|---|---|---|---|---|
| LA (14-25 deg) | 1 | -175 | 43 | 82 |
| | 2 | -150 | 49 | 94 |
| | 3 | -119 | 57 | 108 |
| | 4 | -68 | 70 | 132 |
| FA (6-14 deg) | 2 | 0 | 36 | 88 |
| | 3 | 45 | 41 | 99 |
| | 4 | 90 | 46 | 110 |
| | 5 | 135 | 50 | 121 |
| | 6 | 180 | 55 | 133 |

Each plane is 30 sectors of 12 deg, each sector 25 layers (7 of them sensitive, hit type `solid_gem`). A flux virtual plane sits 1 cm upstream of each GEM plane.

## hit id

LA and FA write into the same `solid_gem` and `flux` banks, so their ids must not overlap:

| | GEM layer (`solid_gem`) | virtual plane (`flux`) |
|---|---|---|
| LA | 1200000 + n*10000 + sec*100 + layer | 1200000 + n*10000 |
| FA | 1100000 + n*10000 + sec*100 + layer | 1100000 + n*10000 |

n is the plane index inside each detector, 1-4 for LA and 1-5 for FA (FA plane 2 is n = 1), sec 1-30, layer 1-25. So digit 2 of the id is 1 for FA and 2 for LA, digit 3 is n.

These ids differ from the combined `../gem_moved/solid_SIDIS_gem` (1000000 + plane*100000 + sec*1000 + layer); analysis code that decodes GEM ids needs to follow this layout.

## GEM module geometry and material log

Copied from the readme of ../gem_moved.

```
= GEM geometry and material log =========================

****** initial checkin  2015/10/15 by Zhiwen Zhao ************************

The GEM module construction is borrowed from SBS mc code as described below and converted from  previous file for GEMC 1.x
SBS code is at http://www.iss.infn.it/cisbani/atmp/sbs/ft/gemc/code/ (a local copy http://hallaweb.jlab.org/12GeV/SoLID/download/tracking/SBS_code)

only first two gas layer is kept sensitive and use flux as hitprocess

hit processing is taken from
https://jlabsvn.jlab.org/svnroot/solid/solid_gemc/database_io/banks/solid_hits_def.txt
https://jlabsvn.jlab.org/svnroot/solid/solid_gemc/database_io/banks/bankdefs/SBSGEM.bank

 * Describe the single GEM Chamber module (similar to COMPASS)
 * see: "Construction Of GEM Detectors for the COMPASS experiment", CERN Tech Note TA1/00-03
 *
 * Consist of 15 layers of different size, material and position
 *
 * HoneyComb
 *  0   NEMA G10 120 um
 *  1   NOMEX    3 mm  #should be 3um?
 *  2   NEMA G10 120 um
 * Drift Cathode
 *  3   Copper 5 um    #should exchange with 4?
 *  4   Kapton 50 um   #should exchange with 3?
 *  5   Air 3 mm
 * GEM0
 *  6   Copper 5 um
 *  7   Kapton 50 um
 *  8   Copper 5 um
 *  9   Air 2 mm
 * GEM1
 * 10   Copper 5 um
 * 11   Kapton 50 um
 * 12   Copper 5 um
 * 13   Air 2 mm
 * GEM2
 * 14   Copper 5 um
 * 15   Kapton 50 um
 * 16   Copper 5 um
 * 17   Air 2 mm 
 * Readout Board
 * 18   Copper 10 um
 * 19   Kapton 50 um
 * 20   G10 120 um + 60 um (assume 60 um glue as G10)    # not implmented yet
 * Honeycomb
 * 21   NEMA G10 120 um
 * 22   NOMEX    3 mm       #should be 3um?
 * 23   NEMA G10 120 um

****** update 2015/12/30 by Zhiwen Zhao ************************

make several copper layers to be sensitive, similar to 
https://jlabsvn.jlab.org/svnroot/solid/solid_gemc/database_io/geometry/solid_CLEO_PVDIS_gem_sbsgem.pl
https://jlabsvn.jlab.org/svnroot/solid/solid_gemc/database_io/geometry/solid_CLEO_SIDIS_gem_sbsgem.pl

SoLID GEM geometry below is similar to the updated SBS GEM geometry except SBS GEM has an additional bottom Honeycomb {l) Honeycomb l.0)   NEMA G10 120 um l.1)   NOMEX    3 um  l.2)   NEMA G10 120 um} between k and m

a) Entrance window 
 a.0) Al 5um (approx)
 a.1) Mylar 20um
b) First GAP (do not contribute to the signal)
 b.0) 70Ar30CO2 3 mm
c) Drift Cathode
 c.0) Kapton 50 um
 c.1) Copper 5 um 
d) Second GAP (mainly contributor to the signal)
 d.0) 70Ar30CO2 3 mm
e) GEM0
 e.0) Copper 5 um
 e.1) Kapton 50 um
 e.2) Copper 5 um
f) Third GAP (small contribution to the signal) 
 f.0) 70Ar30CO2 2 mm
g) GEM1
 g.0) Copper 5 um
 g.1) Kapton 50 um
 g.2) Copper 5 um
h) Forth GAP (negligible contribution to the signal)
 h.0) 70Ar30CO2 2 mm
i) GEM2
 i.0)   Copper 5 um
 i.1)   Kapton 50 um
 i.2)   Copper 5 um
j) Fifth GAP
 j.0) 70Ar30CO2 2 mm 
k) Readout Board
 k.0)   Copper 10 um
 k.1)   Kapton 50 um
 k.2)   G10 120 um + 60 um (assume 60 um glue as G10)
m) Sixth GAP
 m.0) 70Ar30CO2 3 mm
n) Closing window
 n.0) Mylar 20um
 n.1) Al 5um (approx)

****** update 2022/08/16 by Zhiwen Zhao ************************

update 2022/08/16 by Zhiwen Zhao
according to SBS GEM running experience, 
change Entrance and Closing window from 5 to 50um Al, replace 1st and 6th gap gas with honeycomb

update 2024/01/18 by Zhiwen Zhao
add a missing G10 layer at top (c.0) according to Xinzhan Bai  

a) Entrance window 
 a.0) Al 50um (approx)
b) Honeycomb
 b.0) G10 125 um
 b.1) NOMEX 3 mm
c) Drift Cathode
 c.0) G10 120 um + 60 um (assume 60 um glue as G10)  (added 2024/01/18)
 c.1) Kapton 50 um
 c.2) Copper 5 um 
d) Second GAP (mainly contributor to the signal)
 d.0) 70Ar30CO2 3 mm
e) GEM0
 e.0) Copper 5 um
 e.1) Kapton 50 um
 e.2) Copper 5 um
f) Third GAP (small contribution to the signal) 
 f.0) 70Ar30CO2 2 mm
g) GEM1
 g.0) Copper 5 um
 g.1) Kapton 50 um
 g.2) Copper 5 um
h) Forth GAP (negligible contribution to the signal)
 h.0) 70Ar30CO2 2 mm
i) GEM2
 i.0)   Copper 5 um
 i.1)   Kapton 50 um
 i.2)   Copper 5 um
j) Fifth GAP
 j.0) 70Ar30CO2 2 mm 
k) Readout Board
 k.0)   Copper 10 um
 k.1)   Kapton 50 um
 k.2)   G10 120 um + 60 um (assume 60 um glue as G10)
m) Honeycomb
 m.0) NOMEX 3 mm
 m.1) G10 125 um
n) Closing window
 n.0) Al 50um (approx)
```
