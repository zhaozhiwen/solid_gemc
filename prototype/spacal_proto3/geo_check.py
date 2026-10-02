#!/usr/bin/env python3
"""Independent placement check for the generated GEMC SPACAL geometry.

Chain A (GEMC): parse <det>__geometry_<var>.txt, compose daughter->mother as
    p_mother = pos + M^-1 p_daughter,  M = Rz(c) Ry(b) Rx(a) from "a b c"
(G4PVPlacement(pRot, tlate) semantics, gemcUtils.cc rotateX->Y->Z).
Chain B (sPHENIX, active transforms from PHG4SpacalPrototypeDetector.cc):
    world = T(xpos,ypos,zpos) Rz(zrot) T(-(R+T/2),0,0) * Rz(sector rot) * T(central) Rx(pRotX) * fiber
using the oracle fibers (ref_fibers_<var>.txt, tower frame).

Usage: geo_check.py <det> <var> [geantino s j fid]
Prints max deviations; with "geantino" prints BEAM_V / BEAM_P for a geantino along that fiber's axis.
"""
import math
import sys

import numpy as np


def Rx(a): c, s = math.cos(a), math.sin(a); return np.array([[1, 0, 0], [0, c, -s], [0, s, c]])
def Ry(a): c, s = math.cos(a), math.sin(a); return np.array([[c, 0, s], [0, 1, 0], [-s, 0, c]])
def Rz(a): c, s = math.cos(a), math.sin(a); return np.array([[c, -s, 0], [s, c, 0], [0, 0, 1]])


UNITS = {"cm": 1.0, "mm": 0.1, "m": 100.0, "rad": 1.0, "deg": math.pi / 180, "mrad": 1e-3}


def num(tok):
    v, u = tok.split("*")
    return float(v) * UNITS[u]


def load_params(path):
    p = {}
    for line in open(path):
        f = [s.strip() for s in line.split("|")]
        if len(f) >= 2 and f[0]:
            p[f[0]] = f[1]
    return p


def load_geo(path):
    g = {}
    for line in open(path):
        f = [s.strip() for s in line.split("|")]
        if len(f) < 18:
            continue
        pos = np.array([num(t) for t in f[3].split()])
        a, b, c = [num(t) for t in f[4].split()]
        M = Rz(c) @ Ry(b) @ Rx(a)
        g[f[0]] = dict(mother=f[1], pos=pos, Minv=M.T, type=f[6], ncopy=int(f[10]))
    return g


def to_world(g, name):
    """Return (R, t) with p_world = R p_local + t."""
    R, t = np.eye(3), np.zeros(3)
    while name != "root":
        v = g[name]
        R, t = v["Minv"] @ R, v["Minv"] @ t + v["pos"]
        name = v["mother"]
    return R, t


def main():
    det, var = sys.argv[1], sys.argv[2]
    p = load_params("%s__parameters_%s.txt" % (det, var))
    g = load_geo("%s__geometry_%s.txt" % (det, var))
    ref = np.loadtxt("ref_fibers_%s.txt" % var, ndmin=2)
    P = lambda k: float(p[k])
    R, T = P("radius"), P("thickness")
    C_R = Rz(P("z_rotation_degree") * math.pi / 180)
    C_t = np.array([P("xpos"), P("ypos"), P("zpos")]) + C_R @ np.array([-(R + T / 2), 0, 0])
    nsec, ntwr = int(p["sector_map_size"]), int(p["sector_tower_map_size"])

    # enclosure centre: sPHENIX cylinder_place * (box_x_shift, 0, box_z_shift)
    bxs = R + T / 2 + P("enclosure_x_shift")
    bzs = (P("zmin") + P("zmax")) / 2
    _, t_encl = to_world(g, det + "_encl")
    print("enclosure centre  GEMC", t_encl, " sPHENIX", C_t + C_R @ np.array([bxs, 0, bzs]))

    # fibers
    first = {}
    dmax_c = dmax_u = 0.0
    nfib = 0
    for s in range(nsec):
        S = Rz(P("sector%d_rotation" % s))
        for row in ref:
            j, fid = int(row[0]), int(row[1])
            cen, vec = row[6:9], row[9:12]
            B_R = Rx(P("tower%d_pRotationAngleX" % j))
            B_t = np.array([P("tower%d_centralX" % j), P("tower%d_centralY" % j), P("tower%d_centralZ" % j)])
            wc = C_R @ (S @ (B_R @ cen + B_t)) + C_t
            wu = C_R @ S @ B_R @ (vec / np.linalg.norm(vec))
            name = "%s_CHb%d_%d_%d" % (det, s, j, fid)
            if name not in g:
                name = "%s_CHa%d" % (det, j)
                assert s == 0 and j not in first, name
                first[j] = fid
            Rw, tw = to_world(g, name)
            dmax_c = max(dmax_c, np.abs(tw - wc).max())
            dmax_u = max(dmax_u, np.abs(Rw @ np.array([0, 0, 1.0]) - wu).max())
            nfib += 1
            if len(sys.argv) > 3 and (s, j, fid) == tuple(int(x) for x in sys.argv[4:7]):
                L = row[12]
                start = wc - wu * (L / 2 + 30.0)   # 30 cm upstream of the fiber's upstream end, on its axis
                th = math.degrees(math.acos(wu[2]))
                ph = math.degrees(math.atan2(wu[1], wu[0]))
                print("geantino fiber s%d j%d fid%d: L=%.4f cm, centre %s, dir %s" % (s, j, fid, L, wc, wu))
                print('  <option name="BEAM_V" value="(%.6f, %.6f, %.6f)cm"/>' % tuple(start))
                print('  <option name="BEAM_P" value="geantino, 1*GeV, %.9f*deg, %.9f*deg"/>' % (th, ph))
                print("  expected flux id %d" % g[name]["ncopy"])
    print("fibers checked %d: max |centre diff| %.2e cm, max |axis diff| %.2e" % (nfib, dmax_c, dmax_u))


if __name__ == "__main__":
    main()
