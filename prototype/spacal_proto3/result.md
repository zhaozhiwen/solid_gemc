# Results

> Note (repo copy, 2026-10-01): written in the development workspace before this directory was added to solid_gemc.
> `runs/<id>` directories are not in the repo; paths `hitprocess_src/` and `../solid_gemc/source/2.9/hitprocess/` are now
> `../../source/2.9/hitprocess/`, and `run_gemc.sh` is now `run.sh`. Rerun a gcard to regenerate any run.


One section per noteworthy run. Link back to `runs/<id>/` for the raw
outputs (`out.root`, `log.txt`, `config.json`) and to `analysis/` for
the script that produced each plot. Treat this file as the single
human-readable summary of what this project has produced — anything
worth showing a collaborator goes here.

## Energy scan off the crack (runs/scan-e{2,4,6,8,12,16,24,32}GeV-c{0..3}, 200 events per energy)

- **Setup:** `make_scan.py` -> `spacal_proto3_p2_scan_e<E>GeV.gcard`; e- from the origin toward the centre of block s1 j1
  (theta 43.4114, phi -1.4086 deg), vertex Gaussian 0.7 cm in y,z (sPHENIX profile; nearest crack ~3.5 sigma away), no momentum spread.
- **Method:** `analyze_scan.py`: E = sum / sf_sPHENIX (0.0190134); Gaussian core from an iterative +-2 sigma window with the analytic
  truncation correction (self-test recovers sigma to 0.4%); bootstrap errors; fit (sigma/E)^2 = a^2/E + b^2.

| Estimator | Stochastic a | Constant b | chi2/ndf |
|---|---|---|---|
| sampling + Birks (no light maps) | 12.1 +- 0.7 %/sqrt(E) | 1.7 +- 0.5 % | 11.4/6 |
| + fiber transmission and light-guide maps | 14.4 +- 1.5 %/sqrt(E) | 8.0 +- 0.4 % | 2.1/6 |
| + photo-statistics (sPHENIX 500 p.e./GeV) | 15.0 +- 1.5 %/sqrt(E) | 8.2 +- 0.4 % | 1.9/6 |

- **The 8% constant term comes from the light-guide map across the 0.7 cm spot**, not from the shower: at 32 GeV sigma/E is 2.8% without maps
  and 8.3% with them over the same events; removing a quadratic dependence on vertex position brings it to 5.1% (the map structure is finer
  than quadratic). The beam is aimed at the shared corner of four sub-towers, where the map varies most (pencil beam there: 2.0% at 32 GeV).
- **Linearity:** E_rec/E falls from 1.07 (2 GeV) to 1.03 (32 GeV) with maps; 1.09 -> 1.05 without maps, so about 4% is in the
  sampling + Birks response itself and about 2% more comes from the maps. Cause not isolated (candidates: longitudinal leakage
  out of ~15 cm, shower depth vs the fiber-transmission map).
- **Low tail: 2-2.5% of events read 3-45% of E**, from electrons that enter a fiber core almost parallel to it and travel down
  the low-Z core without showering (e.g. 32 GeV events with a single fiber hit of 27-30 MeV = 13-15 cm of minimum-ionizing track in a
  15.6 cm fiber). Real effect of a projective SPACAL with the beam from the vertex; the Gaussian core fit excludes these events.
- **Plots:** `plots/scan_resolution.png` (resolution and linearity), `plots/scan_peaks.png` (E_rec/E per energy with core fits).

## Phase 2: solid_spacal hit process (Birks, 44 um core steps, sPHENIX light maps)

Validation:

| Check | Result |
|---|---|
| Model header vs ROOT (`test_spacal_model.C`) | TH1/TH2::Interpolate reproduced to 5e-9 (float storage); 9776 sub-tower ids = oracle; Birks closed form exact |
| Hit process vs GEMC integrated raw info (`check_hitprocess.py runs/p2-e1GeV-raw-n5`, 500 fiber hits) | edep exact; 0 channel-id mismatches; every hit's avg position inside the core of the fiber its code names (1e-13 mm); local z = projection on our fiber axis (1e-12 mm); light/edepB = LG x transmission (median 2e-7, max 1.2e-3); edepB/edep 0.64-0.99, mean 0.968 |
| Step limit active | 0.0083 MeV/step = MIP dE/dx x 44 um |

Physics (e- from the origin, no smearing, FTFP_BERT+STD, 0.7 mm cut; sums over all 64 channels; `analyze_p2.py`):

| Run(s) | Impact | sf edep | sf Birks | **sf light** | light / sPHENIX 0.0190 | sigma/E (Poisson p.e., trimmed) |
|---|---|---|---|---|---|---|
| `p2-e8GeV-s1j1-n100-r1` | block centre (corner of 4 sub-towers) | 0.02105 | 0.02016 | **0.01836** | 0.966 | 4.9% |
| `p2-e32GeV-s1j1-n50-r{1,2}` | block centre | 0.02084 | 0.01996 | **0.01813 +- 0.00005** | 0.954 | 2.0% |
| `p2-e32GeV-s1j1sub-n50-r{1,2}` | sub-tower centre | 0.02031 | 0.01947 | **0.02041 +- 0.00006** | 1.074 | 2.2% |
| `p2-e32GeV-sphenixbeam-n50-r{1,2,3}` | **sPHENIX macro beam**: theta 43.6, phi 0, vertex Gaussian 0.7 cm in y,z | 0.01897 | 0.01817 | **0.01885 +- 0.00033** | **0.992** | 10.6% (crack) |

- **Benchmark:** with the default beam of sPHENIX's `Fun4All_G4_Prototype3.C` (32 GeV, theta 43.6 deg, phi 0, vertex sigma 0.7 cm in y,z),
  where its `sampling_fraction = 0.0190134 +- 0.000225` most plausibly comes from, we get 0.01885 +- 0.00033: ratio 0.992, 0.4 sigma.
  Not reproduced: 2% momentum smearing and 1 mrad divergence (no effect on the mean).
- That beam is centred on the sector 1|2 crack: events with |vy| < 2 mm give sf 0.0145, |vy| > 4 mm give 0.0204; 6/150 events below 0.012.
  Its sigma/E (10.6% trimmed) is therefore dominated by the crack, not by the calorimeter.
- The light-guide map alone moves the light sf by about +-6% with impact point (light/edepB 0.909 at a block centre, 1.048 at a sub-tower centre).
- Known one-directional bias: neutral-particle deposits are not Birks-quenched here (G4EmSaturation quenches them via the electron range),
  so our light is slightly high relative to sPHENIX; magnitude not measured. sPHENIX's physics list is FTFP_BERT (PHG4Reco.h default), as ours;
  its production cut is assumed to be the Geant4 default 0.7 mm.
- 94-95% of the light stays in the four sub-towers of the hit block. 438 / 1098 fiber hits per event at 8 / 32 GeV;
  0.8 / 4.7 s per event; 15-20 kB per event.
- sigma/E here is shower sampling + photo-statistics only (no noise, no calibration spread, no beam spread).
- Plots: `plots/p2_e8GeV_s1j1_{sf,channels}.png`, `plots/p2_e32GeV_s1j1_{sf,channels}.png`, `plots/p2_e32GeV_s1j1sub_{sf,channels}.png`, `plots/p2_e32GeV_sphenixbeam_{sf,channels}.png`.

## Geometry validation (variations mini / nofiber / Original)

| Check | Result |
|---|---|
| Perl fiber layout vs Python port of sPHENIX code (`fiber_layout_ref.py`) | 9776 unique fibers identical (index, sub-tower, centre, direction, length) |
| GEMC-text transform chain vs sPHENIX active chain (`geo_check.py`) | 39104 fibers: max centre diff 7e-7 cm, max axis diff 1e-9; enclosure centre identical |
| Geantino along fiber axis, mini (`runs/test-mini-geantino-final`) | 1 hit, id 10011 as expected, exit at local (5e-6, 4e-6, 76.186) mm = (0, 0, +L/2); 55/55 overlap checks OK |
| Geantino along corner fiber s2 j3, full (`runs/test-full-geantino-final`) | 1 hit, id 12300 as expected, exit at local (~0, ~0, 82.086) mm = +L/2 |
| Geant4 overlap check, mini (all volumes) | all OK |
| Geant4 overlap check, nofiber (`runs/test-nofiber-overlap-2`) | 16 tower/light-guide shared-face reports of 0.56 pm (rounding, << 1 nm G4 tolerance), rest OK |
| Analytic fiber clearance (`fiber_clearance.py`) | neighbour clearance 0.52 mm, fiber end rim >= 0.11 mm inside tower faces |

## smoke-e8GeV-s1j1-n50 — 8 GeV e- from origin through block s1 j1 centre

- **Setup:** `spacal_proto3_e8GeV_s1j1.gcard`, Original, e- 8 GeV, theta 43.4114 deg, phi -1.4086 deg, no vertex/momentum smearing, FTFP_BERT+STD, 50 events.
- **Key numbers:** core Edep 170.7 MeV/event, rms 7.8 MeV (4.6%); visible fraction 0.0213; 94.7% of it in the four sub-towers of s1 j1 (20-27% each, beam at their shared corner); 924 flux hits/event; 0.56 s/event; 110 kB/event ROOT.
- **Plots:** none yet.
- **Notes:** flux has 1 mm maxStep/prodThreshold and no Birks, so 0.0213 is not comparable to sPHENIX's 0.0190 (light yield, Birks, 32 GeV). Phase 2 needed for that.

## <run_id> — <one-line description>

- **Setup:** preset (e.g. `PVDIS_LD2_moved_full`), beam energy, n_events,
  GCard overrides (anything not at default).
- **Key numbers:** e.g. yield, asymmetry, σ, acceptance —
  whatever the run's purpose was probing.
- **Plots:** `runs/<id>/<plot>.png`, `analysis/<script>.py`
- **Notes:** interpretation, surprises, what to vary next.
