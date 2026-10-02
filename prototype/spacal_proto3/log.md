# Project log

> Note (repo copy, 2026-10-01): written in the development workspace before this directory was added to solid_gemc.
> `runs/<id>` directories are not in the repo; paths `hitprocess_src/` and `../solid_gemc/source/2.9/hitprocess/` are now
> `../../source/2.9/hitprocess/`, and `run_gemc.sh` is now `run.sh`. Rerun a gcard to regenerate any run.


Chronological notes on this solid_gemc simulation project. Prepend the
most recent entry at the top. Each entry captures **what the user
asked for**, **what Claude planned**, **what the user decided**, and
**what actually happened**. Future Claude sessions read this to pick
up where you left off; the user reads it to remember why a particular
run exists.

Use the template below for each new entry. Keep prose tight — link to
specific `runs/<id>/` directories or analysis scripts rather than
quoting their contents.

---

## 2026-10-01 — Add to solid_gemc git under prototype/spacal_proto3

### Request

> make a plan to add spacal_proto3 to git under solid_gemc/prototype/, be critical what's to include or exclude

> 1 prototype/spacal_proto3, 2 agree, 3 yes, 4 fork and PR. also commit spacal_proto3/SPACAL_PLAN.md,spacal_proto3/CLAUDE.md with AGENTS.md as link, spacal_proto3/log.md, spacal_proto3/result.md. why do you need Phase 1 geometry?

### Plan

`GIT_PLAN.md` (workspace only): commit 1 = hit process in source/2.9; commit 2 = prototype/spacal_proto3 with generators,
generated text files, validation suite, analysis, gcards, plots, docs; exclude runs, dumps, sPHENIX sources (no license), plugin-specific runner.

### Decision

Approved with: flat `prototype/spacal_proto3/`; no sPHENIX sources (pinned URLs instead); commit the 19.5 MB geometry; fork + PR;
also commit SPACAL_PLAN.md, CLAUDE.md (+ AGENTS.md symlink), log.md, result.md.

### Outcome

- Branch `spacal_proto3` in the workspace clone; files staged in `prototype/spacal_proto3/` (not yet committed).
- Repo-side changes: `run.sh` (no plugin), paths to `../../source/2.9/hitprocess/`, `.gitignore`, readme, CLAUDE.md rewritten for the repo,
  geantino gcards ported to solid_spacal (Phase 1 geometry was never needed: only the hit type and the clad copy-number meaning changed).
- Verified from the repo location: pinned sPHENIX inputs reproduce all text files and lightmaps.h byte for byte; model unit test, geo_check,
  fiber_clearance, geantino x2, nofiber overlap, check_hitprocess all pass; clean scratch build of source/2.9 OK (no warnings from new code);
  upstream script/solid_PVDIS_simple.gcard runs; 50-event sPHENIX-beam smoke run 0.01812 +- 0.00075 (0.9 sigma from the 150-event value).
- Found: container shell is tcsh (`env VAR=...`); container Python 3.6 has no numpy (checks and analysis run on the host);
  geantinos take a single step through a core (step limit does not apply), so their hit position is the exit point.

## 2026-10-01 — Energy scan off the crack

### Request

> 1 energy scan off the crack

### Plan

e- 2-32 GeV (8 energies x 200 events) from the origin toward the centre of block s1 j1 with sPHENIX's 0.7 cm Gaussian spot;
Gaussian-core fits, (sigma/E)^2 = a^2/E + b^2, linearity; estimators with and without light maps and with sPHENIX p.e. statistics.

### Decision

Approved ("1 energy scan off the crack").

### Outcome

- Run ids: `runs/scan-e{2,4,6,8,12,16,24,32}GeV-c{0,1,2,3}` (32 runs, all exit 0).
- Status: succeeded. 15.0%/sqrt(E) (+) 8.2% with sPHENIX light model and p.e.; 12.1%/sqrt(E) (+) 1.7% without light maps.
- Found: the constant term is the light-guide map's position dependence across the spot; 2-2.5% low tail from fiber channeling;
  ~4-6% non-linearity over 2-32 GeV (cause not isolated).
- Next: tilt the beam a few degrees to suppress channeling; aim at a sub-tower centre or apply a position-dependent correction; leakage study.

## 2026-10-01 — Phase 2: solid_spacal hit process with sPHENIX light model

### Request

> Do phase 2

### Plan

`SPACAL_PLAN.md` Step 5: custom hit process reproducing sPHENIX's fiber-level light (Birks, 44 um core step, fiber-transmission
and light-guide maps, 0-60 ns window), per-fiber hits, channel id in the output; validate; compare with sPHENIX sampling fraction.

### Decision

Approved ("Do phase 2").

### Outcome

- Run ids: `runs/p2-e1GeV-raw-n5` (validation), `runs/p2-e8GeV-s1j1-n100-r1`, `runs/p2-e32GeV-s1j1-n50-r{1,2}`, `runs/p2-e32GeV-s1j1sub-n50-r{1,2}`
  (superseded: `p2-e1GeV-allraws-n5`, `p2-e1GeV-allraws-n5-b`: GEMC allraws tree came out empty).
- Status: succeeded. With sPHENIX's macro beam (`runs/p2-e32GeV-sphenixbeam-n50-r{1,2,3}`): light sf 0.01885 +- 0.00033 vs sPHENIX 0.0190134 +- 0.000225 (ratio 0.992). Pencil beams: 0.01813 (block centre) / 0.02041 (sub-tower centre).
- Code: source of truth `hitprocess_src/` (4 files + `solid_gemc_registration.patch` + `install.sh`); installed in
  `solid_gemc/source/2.9/hitprocess/` (uncommitted changes in the solid_gemc working tree).
- Found: (1) Geant4 10.7 gives G4_POLYSTYRENE kB = 0.07943 mm/MeV once EmSaturation() is called (as sPHENIX does);
  (2) GEMC's default PRODUCTIONCUT is 10 mm (Phase 1 ran with it), Phase 2 uses 0.7 mm;
  (3) sPHENIX's Prototype3 macro loads Prototype2Module.xml, whose fiber-transmission map spans +-6.75 cm while P3 fibers reach +-8.2 cm
      (TH1::Interpolate clamps; reproduced as is); (4) light sf depends on impact point by about +-6% through the light-guide map.
- Next: energy scan with off-crack beam for a resolution curve; Birks for neutral deposits; commit hit process upstream (needs approval).

## 2026-10-01 — sPHENIX 2017 SPACAL prototype built in GEMC (Phase 1, flux)

### Request

> understand this detector in geant4 and https://github.com/sPHENIX-Collaboration/prototype/blob/master/simulation/g4simulation/g4caloprototype/PHG4SpacalPrototypeDetector.cc and make a plan to build it with perl script for solid_gemc

Decisions (user): "1 2017, 2 standalone, 3 phase 1 with flux, 4 correct one", then "Go".

### Plan

`SPACAL_PLAN.md`: Prototype3 geometry XML -> GEMC parameters -> Perl generators (EC layout) -> validation
(oracle, transform chain, geantino, overlaps) -> flux smoke run. Phase 2 (custom hitprocess, Birks, light maps) deferred.

### Decision

Approved as planned.

### Outcome

- Run ids: `runs/test-mini-geantino-final`, `runs/test-full-geantino-final`, `runs/test-nofiber-overlap-2`, `runs/smoke-e8GeV-s1j1-n50`
  (superseded: `test-mini-geantino`, `test-full-geantino` (pre-precision-fix geometry), `test-nofiber-overlap` (10 nm rounding), `smoke-e8GeV-n20` (no EM physics), `smoke-e8GeV-n20-std` (beam in the sector crack)).
- Status: succeeded. Geometry: 4 sectors x 4 towers, 39104 fibers, 39195 rows, 19.5 MB; loads in ~6 s.
- Found on the way:
  1. Geant4 10.7 aborts on the sPHENIX tower G4Trap (side face non-planar by ~1e-4 mm); pDx4 set to the planar value (shift <= 3.2e-4 mm).
  2. GEMC `PHYSICS="FTFP_BERT"` has no EM physics; needs `+STD`. 17 upstream solid_gemc gcards use bare `QGSP_BERT` (not checked further).
  3. GEMC TEXT parameter factory parses every value as a number, so string parameters cannot go in `__parameters`.
  4. sPHENIX beam (theta 43.6, phi 0 from origin) runs along the sector 1|2 crack in this geometry.
- Next: Phase 2 `solid_spacal` hitprocess (Birks, 44 um core step, fiber-transmission and light-guide maps), then compare with sPHENIX sampling fraction 0.0190.

## YYYY-MM-DD HH:MM UTC — <one-line headline>

### Request

> <verbatim user request, in their own words; quote it so future-you
>  can tell what was asked vs. what Claude inferred>

### Plan (seven-field spec)

- Project name:    <the `<name>/` subdir under the workspace root>
- Physics goal:    <…>
- SoLID config:    <PVDIS_LD2 / PVDIS_LH2 / SIDIS_He3 / J_psi / …>
- Beam:            <particle, energy, n_events>
- GCard:           <preset + parameter overrides>
- Output:          `runs/<id>/out.root`
- Analysis:        <plot type, observable>
- Steps:           <e.g. config → run → analyze>
- Risks:           <only if real>

### Decision

<approved as-is | edited spec to <…> | wrote plan only, did not run>

### Outcome

- Run id:  `runs/<id>` (or "n/a — plan only")
- Status:  <succeeded | failed at <step> with <reason>>
- Notes:   <one or two lines: what worked, what surprised, what's next>
