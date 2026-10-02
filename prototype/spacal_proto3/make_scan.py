#!/usr/bin/env python3
"""Generate the energy-scan GCards and job list (off-crack beam).

Beam: e- from the origin toward the centre of tower block s1 j1 (theta 43.4114, phi -1.4086 deg, from geo_check),
vertex Gaussian sigma 0.7 cm in y and z as in sPHENIX Fun4All_G4_Prototype3.C; the nearest sector crack is ~2.5 cm
(~3.5 sigma) away. No momentum spread (calorimeter resolution only).
Writes spacal_proto3_p2_scan_e<E>GeV.gcard and scan_jobs.txt ("<gcard> <run_id> -RANDOM=<seed>" per line).
Run: xargs -P 3 -L 1 ./run.sh < scan_jobs.txt
"""
ENERGIES = [2, 4, 6, 8, 12, 16, 24, 32]   # GeV
CHUNKS, NEV = 4, 50

TEMPLATE = '''<gcard>
	<!-- Energy scan (make_scan.py): {E} GeV e- from the origin toward the centre of block s1 j1, vertex Gaussian 0.7 cm in y,z
	     (sPHENIX beam profile, off the sector crack). solid_spacal hit process, 0.7 mm cut. No momentum spread. -->
	<detector name="solid_spacal_proto3" factory="TEXT" variation="Original"/>

	<option name="HIT_PROCESS_LIST" value="solid"/>
	<option name="PHYSICS" value="FTFP_BERT+STD"/>
	<option name="PRODUCTIONCUT" value="0.7"/>
	<option name="HALL_MATERIAL" value="G4_AIR"/>
	<option name="HALL_DIMENSIONS" value="5*m,5*m,5*m"/>

	<option name="BEAM_P" value="e-, {E}*GeV, 43.4114*deg, -1.4086*deg"/>
	<option name="SPREAD_P" value="0*GeV, 0*deg, 0*deg"/>
	<option name="BEAM_V" value="(0, 0, 0)cm"/>
	<option name="SPREAD_V" value="(0.0, 0.7, 0.7, cm, gauss)"/>

	<option name="N" value="{N}"/>
	<option name="USE_GUI" value="0"/>
</gcard>
'''

jobs = []
for E in ENERGIES:
    g = "spacal_proto3_p2_scan_e%dGeV.gcard" % E
    open(g, "w").write(TEMPLATE.format(E=E, N=NEV))
    for c in range(CHUNKS):
        jobs.append((E, "%s scan-e%dGeV-c%d -RANDOM=%d" % (g, E, c, 10000 + 100 * E + c)))
# longest jobs first so the pool drains evenly
open("scan_jobs.txt", "w").write("".join(j + "\n" for _, j in sorted(jobs, key=lambda x: -x[0])))
print("%d gcards, %d jobs" % (len(ENERGIES), len(jobs)))
