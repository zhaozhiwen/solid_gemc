#!/usr/bin/env python3
"""Analytic overlap check for the fibers (Geant4 CheckOverlaps is too slow for 2444 siblings per tower).

Uses the oracle fibers (ref_fibers_<var>.txt, tower frame, cm) and the tower G4Trap with the planar pDx4
used by solid_spacal_geometry.pl.
1. Fiber-fiber: minimum axis-to-axis distance between lattice neighbours, sampled along the fiber, vs 2*r_out.
2. Fiber-tower: rim points of both end discs (radius r_out) must be inside all 6 trap faces.
Usage: fiber_clearance.py <det> <var>
"""
import sys

import numpy as np


def load_params(path):
    p = {}
    for line in open(path):
        f = [s.strip() for s in line.split("|")]
        if len(f) >= 2 and f[0]:
            p[f[0]] = f[1]
    return p


def trap_planes(t):
    """Inward normals n and offsets d (inside: n.x + d >= 0) for theta = phi = alpha = 0 G4Trap."""
    dz, dy1, dx1, dx2, dy2, dx3, dx4 = t
    v = {  # vertices as in G4Trap: (x, y, z)
        "a": (-dx1, -dy1, -dz), "b": (dx1, -dy1, -dz), "c": (-dx2, dy1, -dz), "d": (dx2, dy1, -dz),
        "e": (-dx3, -dy2, dz), "f": (dx3, -dy2, dz), "g": (-dx4, dy2, dz), "h": (dx4, dy2, dz)}
    faces = [("a", "c", "e"), ("b", "f", "d"), ("a", "e", "b"), ("c", "d", "g")]  # -X, +X, -Y, +Y
    centre = np.zeros(3)
    planes = []
    for f in faces:
        p0, p1, p2 = (np.array(v[k]) for k in f)
        n = np.cross(p1 - p0, p2 - p0)
        n /= np.linalg.norm(n)
        if np.dot(n, centre - p0) < 0:
            n = -n
        planes.append((n, -np.dot(n, p0)))
    planes.append((np.array([0, 0, 1.0]), dz))    # -Z face
    planes.append((np.array([0, 0, -1.0]), dz))   # +Z face
    return planes


def main():
    det, var = sys.argv[1], sys.argv[2]
    p = load_params("%s__parameters_%s.txt" % (det, var))
    ref = np.loadtxt("ref_fibers_%s.txt" % var, ndmin=2)
    r_out = float(p["fiber_clading_thickness"]) + float(p["fiber_core_diameter"]) / 2
    ok = True
    for j in sorted(set(ref[:, 0].astype(int))):
        g = lambda k: float(p["tower%d_%s" % (j, k)])
        r = ref[ref[:, 0] == j]
        idx = {(int(a), int(b)): k for k, (a, b) in enumerate(r[:, 2:4])}
        cen, vec = r[:, 6:9], r[:, 9:12]
        ts = np.linspace(-0.5, 0.5, 21)
        pts = cen[None, :, :] + ts[:, None, None] * vec[None, :, :]       # (nt, nfib, 3)
        dmin = np.inf
        for (ix, iy), k in idx.items():
            for dx, dy in ((1, 1), (1, -1), (2, 0), (0, 2)):
                m = idx.get((ix + dx, iy + dy))
                if m is not None:
                    dmin = min(dmin, np.linalg.norm(pts[:, k] - pts[:, m], axis=1).min())
        pdx4 = g("pDx3") + (g("pDx2") - g("pDx1")) * g("pDy2") / g("pDy1")
        planes = trap_planes((g("pDz"), g("pDy1"), g("pDx1"), g("pDx2"), g("pDy2"), g("pDx3"), pdx4))
        # rim points of both end discs
        u = vec / np.linalg.norm(vec, axis=1)[:, None]
        e1 = np.cross(u, [1.0, 0, 0]); e1 /= np.linalg.norm(e1, axis=1)[:, None]
        e2 = np.cross(u, e1)
        margin = np.inf
        for end in (-0.5, 0.5):
            c = cen + end * vec
            for phi in np.linspace(0, 2 * np.pi, 16, endpoint=False):
                q = c + r_out * (np.cos(phi) * e1 + np.sin(phi) * e2)
                for n, d in planes:
                    margin = min(margin, (q @ n + d).min())
        good = dmin > 2 * r_out and margin > 0
        ok &= good
        print("tower %d: %d fibers, min neighbour axis distance %.5f cm (2 r_out = %.5f, clearance %.5f cm), "
              "min fiber-to-tower-face margin %.5f cm  %s"
              % (j, len(r), dmin, 2 * r_out, dmin - 2 * r_out, margin, "OK" if good else "FAIL"))
    print("ALL OK" if ok else "FAILURES")


if __name__ == "__main__":
    main()
