#!/usr/bin/env python3
"""Validation oracle: direct port of sPHENIX fiber placement.

Source: PHG4SpacalPrototypeDetector.cc, Construct_Fibers_SameLengthFiberPerTower (lines 638-773),
and PHG4CylinderGeom_Spacalv3 get_sub_tower_ID_x/y.
Reads a GEMC __parameters txt (from sphenix_xml2param.py) and writes, per fiber in the tower frame (cm):
  tower fiber_id ix iy subx suby  cx cy cz  vx vy vz  length
after the same-length cut. Compare against the Perl generator's dump.

Usage: fiber_layout_ref.py <det>__parameters_<var>.txt > ref_fibers_<var>.txt
"""
import math
import sys


def load(path):
    p = {}
    for line in open(path):
        f = [s.strip() for s in line.split("|")]
        if len(f) >= 2 and f[0]:
            p[f[0]] = f[1]
    return p


def main():
    p = load(sys.argv[1])
    core_d = float(p["fiber_core_diameter"])
    r_out = float(p["fiber_clading_thickness"]) + core_d / 2  # get_fiber_outer_r
    for j in range(int(p["sector_tower_map_size"])):
        t = lambda k: float(p["tower%d_%s" % (j, k)])
        ti = lambda k: int(p["tower%d_%s" % (j, k)])
        nfx, nfy, nsx, nsy = ti("NFiberX"), ti("NFiberY"), ti("NSubtowerX"), ti("NSubtowerY")
        skin = t("ModuleSkinThickness")
        pDz, pTheta, pPhi = t("pDz"), t("pTheta"), t("pPhi")
        pDx1, pDx2, pDx3, pDx4 = t("pDx1"), t("pDx2"), t("pDx3"), t("pDx4")
        pDy1, pDy2, pAlp1, pAlp2 = t("pDy1"), t("pDy2"), t("pAlp1"), t("pAlp2")
        zs = (math.tan(pTheta) * math.cos(pPhi) * pDz, math.tan(pTheta) * math.sin(pPhi) * pDz, pDz)

        fibers = {}
        min_len = pDz * 4
        for ix in range(nfx):
            wix = ix / (nfx - 1.0)
            wdx1 = (pDx1 - skin - r_out) * (wix * 2 - 1)
            wdx2 = (pDx2 - skin - r_out) * (wix * 2 - 1)
            wdx3 = (pDx3 - skin - r_out) * (wix * 2 - 1)
            wdx4 = (pDx4 - skin - r_out) * (wix * 2 - 1)
            for iy in range(nfy):
                if (ix + iy) % 2 == 1:
                    continue
                wiy = iy / (nfy - 1.0)
                wdy1 = (pDy1 - skin - r_out) * (wiy * 2 - 1)
                wdy2 = (pDy2 - skin - r_out) * (wiy * 2 - 1)
                wdx12 = wdx1 * (1 - wiy) + wdx2 * wiy + wdy1 * math.tan(pAlp1)
                # NB: sPHENIX uses weighted_pDy1 (not pDy2) with pAlp2 here; ported verbatim.
                wdx34 = wdx3 * (1 - wiy) + wdx4 * wiy + wdy1 * math.tan(pAlp2)
                v1 = (wdx12 - zs[0], wdy1 - zs[1], 0 - zs[2])
                v2 = (wdx34 + zs[0], wdy2 + zs[1], 0 + zs[2])
                vec = [b - a for a, b in zip(v1, v2)]
                mag = math.sqrt(sum(c * c for c in vec))
                vec = [c * (mag - r_out) / mag for c in vec]
                cen = [(a + b) / 2 for a, b in zip(v1, v2)]
                fid = nfy * ix + iy
                fibers[fid] = (ix, iy, vec, cen)
                min_len = min(min_len, math.sqrt(sum(c * c for c in vec)))

        for fid in sorted(fibers):
            ix, iy, vec, cen = fibers[fid]
            opt = math.sqrt(sum(c * c for c in vec))
            cen = [c + (min_len / opt - 1) * 0.5 * v for c, v in zip(cen, vec)]
            vec = [v * min_len / opt for v in vec]
            subx = (nsx - 1) - math.floor(ix / (nfx / nsx))
            suby = (nsy - 1) - math.floor(iy / (nfy / nsy))
            print("%d %d %d %d %d %d % .8f % .8f % .8f % .8f % .8f % .8f %.8f"
                  % (j, fid, ix, iy, subx, suby, cen[0], cen[1], cen[2], vec[0], vec[1], vec[2], min_len))


if __name__ == "__main__":
    main()
