# beamline_moved

Beam pipes for the "moved" SoLID configurations: an entrance pipe upstream of
the target (volumes `BM*`) and an exit pipe downstream of it (volumes `B3*`).

## files

| configuration | driver script | text files | used by |
|---|---|---|---|
| J/psi, DDVCS | `solid_JPsi_beamline.pl` + `_geometry.pl` | `solid_JPsi_beamline__*_Original.txt` | `script/solid_JPsi_LH2_moved_full.gcard`, `script/solid_JPsi_DDVCS_LH2_moved_full.gcard` |
| PVDIS | `solid_PVDIS_beamline.pl` + `_geometry.pl` | `solid_PVDIS_beamline__*_Original.txt` | `script/solid_PVDIS_LD2_moved_full.gcard` |
| SIDIS He3 | `solid_SIDIS_beamline_He3.pl` + `_geometry.pl` | `solid_SIDIS_beamline_He3__*_Original.txt` | `script/solid_SIDIS_He3_moved_full.gcard`, `analysis/hgc_study/solid_SIDIS_He3_full_moved*.gcard` |
| SIDIS NH3 | `solid_SIDIS_beamline_NH3.pl` + `_geometry.pl` | `solid_SIDIS_beamline_NH3__*_Original.txt` | `script/solid_SIDIS_NH3_moved_full.gcard` |

`solid_beamline_materials.pl` defines `SL_beamline_He4_1atm` (He4 gas, 1 atm).
No beamline volume uses it at present.

## how to make the text files

After setting up the env (`$GEMC`), run in this dir, for example

    ./solid_SIDIS_beamline_He3.pl config_solid_SIDIS_beamline_He3.dat

and the same for the other three with their `config_*.dat`. It writes
`*__geometry_Original.txt`, and `*__materials_Original.txt` where the driver
loads `solid_beamline_materials.pl` (not PVDIS, where that line is commented
out).

The drivers add `$GEMC/api/perl` to the perl library path and load their
geometry script as `./*_geometry.pl` (newer perl no longer searches the current
dir), so they run with the gemc perl api in the jlab_ce container.

## volumes

z is in the hall frame, in cm.

| configuration | entrance pipe | exit pipe | Be windows | downstream end |
|---|---|---|---|---|
| J/psi | Al tube, r 1.25, z -627.5 to -327.5 | Al cone, r 1.8 to 29, z -302.5 to 802.5 | 0.25 mm at z -327.5 (entrance) and -302.5 (exit) | `B3DM`, Kryptonite, z 802.3 to 802.5 |
| PVDIS | Al tube, r 30, z -687 to -27 | Al polycone, r 5 to 19, z 47 to 550 | none | `B3DM`, Kryptonite, z 549.9 to 550 |
| SIDIS He3 | Al tube, r 3.0, z -575 to -375 | Al polycone, r 1.05 to 19, z -325 to 550 | 0.254 mm at z -375, 0.508 mm at z -325 | `B3W2`, Kryptonite, z 549.9 to 550 |
| SIDIS NH3 | none | Al polycone, r 1.05 to 19, z -300 to 550 | 0.4 mm at z -300 | `B3DM`, Kryptonite, z 549.9 to 550 |

Every pipe is filled with `G4_Galactic` (vacuum).

## downstream Kryptonite disk

The exit pipe ends with a 1 mm disk of `Kryptonite` filling the pipe bore. gemc
kills every track that enters Kryptonite, so the beam and everything travelling
down the exit pipe stop there instead of being tracked through the material
downstream of SoLID.

- J/psi and NH3: the existing `B3DM` disk changed from `G4_Galactic` to
  Kryptonite. For J/psi its upstream radius changed from 28.9 to 28.8 cm so it
  stays inside the cone bore (28.895 cm at the disk's upstream face).
- PVDIS and He3: a new disk, inside the exit-pipe vacuum `B3PV`.
