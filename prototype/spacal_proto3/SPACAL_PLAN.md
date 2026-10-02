# Plan: sPHENIX SPACAL prototype → solid_gemc Perl geometry

Status (2026-10-01): Steps 0-5 done. Phase 1 (geometry, flux) and Phase 2 (solid_spacal hit process with the sPHENIX light model) built and validated. Results in result.md.

## Decisions (2026-10-01)

1. Prototype: **Prototype3 (2017, 2D-projective)**. XML `calibrations/Prototype3/Geometry/cemc_geoparams-0-0-4294967295-1483238881.xml`.
2. Purpose: **standalone test-beam replica**. Keep the sPHENIX frame; beam along +x.
3. Hit processing: **Phase 1 only, built-in `flux`**. Phase 2 (custom hitprocess) is deferred.
4. PMMA: **correct definition, `G4_PLEXIGLASS`**.

## Source understanding (what the C++ does)

Sources read:
- `prototype/simulation/g4simulation/g4caloprototype/PHG4SpacalPrototypeDetector.cc`, `...Subsystem.cc`, `...SteppingAction.cc`
- `coresoftware/.../g4detectors/PHG4CylinderGeom_Spacalv1/v3.{h,cc}`
- `coresoftware/.../g4main/PHG4Reco.cc` (materials)
- `prototype/macros/prototype{2,3}/Fun4All_G4_Prototype{2,3}.C`
- `calibrations/Prototype3/Geometry/cemc_geoparams-...-1483238881.xml` (P3, newest) and `Prototype2/...-1474400077.xml` (P2, newest). Assumption: the newest timestamp is the one loaded.

The geometry is entirely data-driven: the `.cc` holds the algorithm, the XML holds all numbers.

Volume tree and transforms:

```
World
└─ cylinder box (G4_AIR, enclosure_x × y × z), displaced by (box_x_shift, 0, box_z_shift)
   placed at  T(xpos,ypos,zpos) · Rz(z_rotation) · T(-(radius+thickness/2), 0, 0)
   ├─ sector ×N (G4_AIR Tubs wedge 2π/azimuthal_n_sec, r ∈ [radius-max_LG_height, max_radius]),
   │    solid displaced by box_z_shift; placed with Rz(sector_map[i].rotation), copyNo = sector id
   │  ├─ tower ×M (Spacal_W_Epoxy G4Trap, 11 params from sector_tower_map[j]),
   │  │    placed T(centralX,Y,Z) · Rx(pRotationAngleX), copyNo = tower id
   │  │  └─ fiber clad ×(NFiberX·NFiberY/2) (PMMA Tube r=fiber_outer_r), copyNo = NFiberY·ix+iy
   │  │     └─ fiber core (G4_POLYSTYRENE Tube r=core_d/2)   ← active (sensitive)
   │  └─ light guide ×(NSubtowerX·NSubtowerY) per tower (PMMA G4Trap, displaced solid), same transform as tower
   ├─ electronics (G10 box, thickness 0.254 cm, displaced)
   └─ enclosure shell (G10, outer box − inner box, thickness 0.1016 cm, displaced)
```

Fiber layout (`Construct_Fibers_SameLengthFiberPerTower`):
- Lattice ix ∈ [0,NFiberX), iy ∈ [0,NFiberY). Fibers with `(ix+iy)%2==1` are skipped, giving a triangular pattern.
- Each fiber runs from a point on the −pDz face to the matching interpolated point on the +pDz face. The insets are skin thickness plus fiber radius, and the tapered x widths are interpolated in y. So fibers are **not parallel**: they fan with the 2D taper.
- Every fiber in a tower uses the same length: the minimum over the tower, recentered.
- Rotation: any rotation taking ẑ to the fiber direction works, because the fiber is cylindrically symmetric.

Key numbers:

| | Prototype3 (2017) | Prototype2 (2016) |
|---|---|---|
| sectors × towers | 4 × 4 = 16 blocks | 8 × 4 = 32 blocks |
| subtowers / block | 2×2 → 64 readout ch | 1×2 → 64 readout ch |
| fibers / block | 94×52/2 = 2444 | 30×104/2 = 1560 |
| total fibers | ~39k | ~50k |
| radius / thickness | 97.5 / 15.35 cm | 116.38 / 14.28 cm |
| light guide | 5.08 cm, taper 0.525 | 2.54 cm, taper 0.525 |
| enclosure (x,y,z) | 40.64 × 33.02 × 48.26 cm | 33.02³ cm |

Materials:
- Absorber `Spacal_W_Epoxy`: ρ = 12.18 g/cm³, mass fractions W 0.969 / C 0.029 / H 0.002.
- Fiber: core `G4_POLYSTYRENE`, cladding PMMA. Core diameter 0.044 cm, cladding 0.0015 cm, so outer r = 0.0235 cm.
- Light guides: PMMA.
- Enclosure and electronics: `G10` (ρ = 1.70 g/cm³, atom counts Si1 O2 C3 H3).
- Step limit in the core: core_d/10 = 44 µm. Visible energy uses Birks.

## GEMC 2.9 facts this design relies on (checked in source inside the jlabce 2.5 container)

| Fact | Where it comes from | What it means for this design |
|---|---|---|
| `G4Trap` with exactly 11 args, in constructor order | `detector.cc:426` | Towers and light guides map 1:1. Angles are passed as `*rad`. |
| `CopyOf X` reuses X's logical volume, daughters included | `detector.cc:591` | Build 1 fiber (clad + core) per tower and copy it. Copies keep their own name, `ncopy` and identifiers. |
| No `G4DisplacedSolid` | — | Fold every displacement into the `pos` column. |
| Hit identity = volume name, looked up in the detector map | `sensitiveDetector.cc:127` | The shared core has one identity, so sector, tower and fiber must come from `ncopy`. |
| `ncopy` rule walks the whole touchable history; the **last** (outermost) name match wins | `identifier.cc:95` | Use name tokens that appear at exactly one level. |
| `SetId` exits if any id is 0 | `identifier.cc` | Every `ncopy` gets +1 (fiber id 0 exists). |
| Rotation = `rotateX→Y→Z` matrix passed as a pointer to `G4PVPlacement` (a frame rotation) | `gemcUtils.cc:98`, `detector.cc:868` | **Highest-risk item**: active→passive conversion. Verify with a geantino test. |
| Volumes are built in alphabetical order; a copy built before its original segfaults | EC `showe`/`shower` trick | Originals get names that sort first. |
| flux hit: maxStep 1 mm, prodThreshold 1 mm, no Birks | built-in | Phase 1 validates geometry only, **not** a physics benchmark. |

## GEMC volume design

Mirror the sPHENIX hierarchy 1:1 so the touchable depth matches and `scint_id_coder(sector, tower, fiber)` maps directly.

| Level | Name pattern | Type | ncopy | Rows |
|---|---|---|---|---|
| enclosure shell | `<det>_encl` | `Operation:` outer − inner (`Component` operands) | 1 | 3 |
| air mother | `<det>_box` | Box G4_AIR, displacement folded into pos | 1 | 1 |
| electronics | `<det>_elec` | Box G10 | 1 | 1 |
| sector | `<det>_SEC<s>` (4 originals, no copies) | Tubs wedge, air, rotated about z | — | 4 |
| tower | `<det>_TWR<s>_<j>` (16 originals, no copies) | G4Trap Spacal_W_Epoxy | — | 16 |
| clad | `<det>_FIBa<j>` original per eta row, `<det>_FIBb<s>_<j>_<k>` copies | Tube G4_PLEXIGLASS | **readout channel code** | ~2444 × 16 |
| core | `<det>_core<j>` (inside each clad original, shared) | Tube polystyrene, **sensitive (flux)** | 1 | 4 |
| light guide | `<det>_LG<s>_<j>_<ix>_<iy>` | G4Trap G4_PLEXIGLASS, displacement folded into pos | — | 64 |

Sensitive volume = fiber core, as in sPHENIX. There are 4 core logical volumes and ~39k physical placements.

Identifier on the core: `CH ncopy 0` only. Token CH appears only in clad names.
Reason: flux writes only `identity[0].id` (`flux_hitprocess.cc:9`), so the full readout channel must be in that single id.
The clad's ncopy = 1 + 100·sector + 10·tower_row + subtower (subtower from the fiber index via `get_sub_tower_ID_x/y`, both axes inverted). That gives 64 channels.
flux (timeWindow 0) then makes one hit per (track, channel), summed over all fibers that track crosses in that channel. Fiber-level hits are never produced.

Why sectors and towers are not `CopyOf`: a copy shares all daughters, so the fibers of a copied sector would carry the original sector's channel code.
Cost: ~39k rows instead of ~10k, and a geometry txt of roughly 15 MB. GEMC load time to be measured on the full build.

Row count: about 39k for P3.

## File layout (project subdir, mirrors `geometry/ec_segmented_moved/`)

```
spacal_proto/                      # project subdir seeded by the skill
  CLAUDE.md / log.md / result.md   # from template (rules first)
  sphenix_ref/                     # downloaded sPHENIX sources + XML (provenance, read-only)
  sphenix_xml2param.py             # XML → GEMC parameters txt (both prototypes, + "mini" variation)
  fiber_layout_ref.py              # direct Python port of .cc lines 648–726 (validation oracle)
  config.dat
  solid_spacal.pl                  # driver: ./solid_spacal.pl solid_spacal_proto3 [variation]
  solid_spacal_geometry.pl
  solid_spacal_materials.pl        # Spacal_W_Epoxy, G10 (PMMA -> G4_PLEXIGLASS, built in)
  solid_spacal_hit.pl              # Phase 2
  solid_spacal_bank.pl             # Phase 2
  solid_spacal_proto3__parameters_{Original,mini}.txt
  solid_spacal_proto3__{geometry,materials,hit,bank}_*.txt   # generated
  spacal_proto3.gcard              # standalone: this detector only, HALL_MATERIAL=Air
  runs/<id>/
```

The Perl runs through `bin/solid-gemc-run exec`, because `$GEMC/api/perl` exists only inside the container.

## Steps

### Step 0: workspace
`solid-gemc-run init` (one-time; heavy: image + clone + build), then seed `spacal_proto/`. Needs your approval.

### Step 1: parameters
`sphenix_xml2param.py` parses the PdbParameterMap XML (dparams, iparams, cparams) into the GEMC `__parameters` format. It also writes a `mini` variation: 1 sector, 1 tower, NFiber reduced to about 6×4.
Check: the dumped values match the XML exactly.

### Step 2: geometry Perl
Transform composition happens in Perl with 3×3 matrices; no CPAN deps (the EC script also avoids Math::MatrixReal).
Check: fiber endpoints from the Perl generator match `fiber_layout_ref.py` to 1e-6 cm.

### Step 3: geometry validation (mini first, then full)
1. Geantino shot along one fiber axis: it must stay in the core for the full length. This validates the rotation convention.
2. `CHECK_OVERLAPS=1` on mini, then full. Full is slow with 2444 siblings per tower.
3. GEMC-printed tower mass vs analytic: (trap volume − N·π·r²·L)·12.18 g/cm³ plus fiber mass.
4. Fold-in check of displacements: compare enclosure/sector centers with sPHENIX's `box_x_shift` and `box_z_shift`.
5. Visual check in GUI mode with `virualize_fiber` on.

### Step 4: Phase 1 run (flux on cores)
e⁻ 1–8 GeV along +x into the central tower. Sum core Edep / total Edep.
Purpose: confirm the shower is contained and the fibers are hit. **Not** a sampling-fraction benchmark (flux maxStep and prodThreshold are 1 mm, against fibers 0.47 mm wide, and there is no Birks).

### Step 5: Phase 2 hitprocess `solid_spacal`
1. Clone the `solid_ec_hitprocess` pattern, which already has Birks.
2. Hit definition: maxStep 0.044 mm in the core (as sPHENIX), small prodThreshold.
3. Map (sector, tower, fiber) → readout channel = (sector, tower, subtower x/y).
4. Bank: per-channel Edep, light (Birks), time.
5. Recompile `solid_gemc/source/2.9` with `scons OPT=1` in the container.

Then: sampling fraction and resolution vs the published sPHENIX test-beam paper for the chosen prototype (paper not yet looked up).
Internal sPHENIX benchmark: `sampling_fraction = 0.0190134 ± 0.000225`, from 0° 32 GeV e⁻ (`Fun4All_G4_Prototype3.C:301`).

The sPHENIX "light" chain to reproduce (no optical photons are tracked anywhere):
1. Per step in the core: `light_yield = G4EmSaturation::VisibleEnergyDepositionAtAStep` (Birks-quenched energy, in GeV).
2. Per fiber: multiply by `fiber_transmission(local z)` and `light_guide_efficiency(x, y in sub-tower)`. Both maps are in `calibrations/CEMC/LightCollection/Prototype2Module.xml`.
3. Per sub-tower: sum the light yield (`RawTowerBuilder` default `kLightYield`).
4. Digitize: Poisson photoelectrons with 500 p.e. per GeV of total deposition, i.e. `500/sampling_fraction` per visible GeV; then ADC (0.24 LG / 3.8 HG ADC per p.e.).

### Step 6: only if decision 2 = SoLID candidate
Add a top-level envelope with pos/rot parameters, the SoLID `detID` offset, and a SoLID-frame GCard.

## Source issues found

1. **sPHENIX PMMA composition is wrong.** `PHG4Reco.cc` calls `AddElement(el, 3.6/10.7)` etc. With a double argument, that is a **mass fraction**, but 3.6 : 5.7 : 1.4 are atom ratios of C₅H₈O₂. The result is 53% hydrogen by mass instead of 8%.
   Impact: the 15 µm cladding is negligible. The 5 cm PMMA light guide sits behind the towers, so the effect on the shower is small but nonzero. See decision 4.
2. The light guide is placed with the tower's transform plus a displaced solid. When folded into `pos` it is easy to get the sign of `-pDz` and of the LG half-height wrong. Step 3.4 covers this.

## Risks

| Risk | Mitigation |
|---|---|
| Rotation active/passive sign error | mini build + geantino-along-fiber test before the full build |
| `ncopy` identity resolves at the wrong level | unique name tokens; a hit dump on mini checks all three ids |
| Alphabetical build order segfault | originals named to sort first (`SECa`/`SECb`, `FIBa`/`FIBb`) |
| Full overlap check too slow | run on mini; on full, check only the tower and LG level |
| Output size with per-fiber flux hits | Phase 1 uses few events; Phase 2 sums per channel |
