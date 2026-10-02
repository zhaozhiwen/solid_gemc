#!/usr/bin/env python3
"""Independent check of the solid_spacal hit process against GEMC's integrated raw (true) info.

Needs a run with INTEGRATEDRAW=solid_spacal and evio2root -B=<det> -R=solid_spacal, so that the
solid_spacal tree carries the dgt variables (fiber, edep, edepB, light, id) and the raw ones
(totEdep, avg_x/y/z, avg_lx/ly/lz; mm, edep-weighted) row by row. Per fiber hit:
  1. edep == totEdep                       (differs only if steps fall outside the 0-60 ns window)
  2. id == channel computed here from the fiber code (sPHENIX sub-tower rule)
  3. the edep-weighted global position lies inside the core of the fiber named by the code
     (fiber axis from the geometry txt via the GEMC transform chain)
  4. avg_lz == projection of the global average on that fiber's axis (local frame = our fiber frame,
     z oriented from the light-guide end, as the transmission map assumes); |avg_lx|,|avg_ly| <= core radius
  5. light/edepB ~= LG efficiency(fiber) x transmission(avg_lz)   (exact up to transmission curvature and
     the clamp beyond |z| = 6.68 cm, and Birks- vs edep-weighting)
  6. edepB/edep in (0.5, 1]
Usage: check_hitprocess.py <run_dir> [det] [var]
"""
import sys

import numpy as np
import uproot

import geo_check as gc


def header_tables(path):
    txt = open(path).read()
    def arr(name):
        s = txt.index("const double %s[" % name)
        return np.array([float(v) for v in txt[txt.index("{", s) + 1: txt.index("}", s)].replace(",", " ").split()])
    def num(name):
        return float(txt.split(name + " =")[1].split(",")[0].split(";")[0])
    return dict(lg=arr("lg_eff"), tr=arr("tr_val"), nx=int(num("lg_nx")), ny=int(num("lg_ny")),
                trmin=num("tr_min"), trmax=num("tr_max"))


def trans(z_cm, T):
    n = len(T["tr"])
    c = T["trmin"] + (np.arange(n) + 0.5) * (T["trmax"] - T["trmin"]) / n
    return np.interp(z_cm, c, T["tr"])                  # clamps outside the centres, as TH1::Interpolate


def lg_eff(x, y, T):
    nx, ny = T["nx"], T["ny"]
    lg = T["lg"].reshape(ny, nx)
    cx, cy = (np.arange(nx) + 0.5) / nx, (np.arange(ny) + 0.5) / ny
    return np.interp(y, cy, [np.interp(x, cx, lg[j]) for j in range(ny)])   # bilinear, clamped edges


def main():
    run = sys.argv[1]
    det = sys.argv[2] if len(sys.argv) > 2 else "solid_spacal_proto3"
    var = sys.argv[3] if len(sys.argv) > 3 else "Original"
    p = gc.load_params("%s__parameters_%s.txt" % (det, var))
    g = gc.load_geo("%s__geometry_%s.txt" % (det, var))
    T = header_tables("../../source/2.9/hitprocess/solid_spacal_lightmaps.h")
    core_r = float(p["fiber_core_diameter"]) / 2 * 10                         # mm
    a = uproot.open(run + "/out.root")["solid_spacal"].arrays(library="np")
    cat = {k: np.concatenate(a[k]) for k in ("fiber", "id", "edep", "edepB", "light", "totEdep",
                                             "avg_x", "avg_y", "avg_z", "avg_lx", "avg_ly", "avg_lz")}
    n = len(cat["fiber"])
    d_edep, n_edep, n_id, d_rad, d_lz, d_lxy, rel = 0.0, 0, 0, -1e9, 0.0, -1e9, []
    axes = {}
    for k in range(n):
        code = int(cat["fiber"][k])
        s, j, fid = code // 100000 - 1, (code // 10000) % 10, code % 10000
        nfx, nfy = int(p["tower%d_NFiberX" % j]), int(p["tower%d_NFiberY" % j])
        nsx, nsy = int(p["tower%d_NSubtowerX" % j]), int(p["tower%d_NSubtowerY" % j])
        ix, iy = fid // nfy, fid % nfy
        ch = 10000 + 1000 * s + 100 * j + 10 * ((nsx - 1) - int(ix // (nfx / nsx))) + ((nsy - 1) - int(iy // (nfy / nsy)))
        n_id += int(ch != int(cat["id"][k]))
        de = abs(cat["edep"][k] - cat["totEdep"][k])
        d_edep, n_edep = max(d_edep, de), n_edep + int(de > 1e-9)
        if cat["totEdep"][k] <= 0:
            continue
        name = "%s_CHb%d_%d_%d" % (det, s, j, fid)
        if name not in g:
            name = "%s_CHa%d" % (det, j)
        if name not in axes:
            R, c = gc.to_world(g, name)
            axes[name] = (R @ np.array([0, 0, 1.0]), c * 10)                   # mm
        ax, c = axes[name]
        v = np.array([cat["avg_x"][k], cat["avg_y"][k], cat["avg_z"][k]]) - c
        z = v @ ax
        r = np.linalg.norm(v - z * ax)
        d_rad = max(d_rad, r - core_r)
        d_lz = max(d_lz, abs(z - cat["avg_lz"][k]))
        d_lxy = max(d_lxy, np.hypot(cat["avg_lx"][k], cat["avg_ly"][k]) - core_r)
        fx = (np.fmod(ix, nfx / nsx) + 0.5) / (nfx / nsx)
        fy = (np.fmod(iy, nfy / nsy) + 0.5) / (nfy / nsy)
        expect = lg_eff(fx, fy, T) * trans(cat["avg_lz"][k] / 10.0, T)
        rel.append(cat["light"][k] / cat["edepB"][k] / expect - 1)
    rel = np.abs(np.array(rel))
    ratio = cat["edepB"][cat["edep"] > 0] / cat["edep"][cat["edep"] > 0]
    print("fiber hits: %d" % n)
    print("1. edep vs totEdep: max diff %.3e MeV, %d hits differ (steps outside the time window)" % (d_edep, n_edep))
    print("2. channel id mismatches: %d" % n_id)
    print("3. max (distance of avg position from fiber axis - core radius): %.3e mm (<= 0 means inside)" % d_rad)
    print("4. max |avg_lz - projection on fiber axis|: %.3e mm; max (|avg_lxy| - core radius): %.3e mm" % (d_lz, d_lxy))
    print("5. |light/edepB / (LG eff x transmission(avg_lz)) - 1|: median %.1e, 99%% %.1e, max %.1e"
          % (np.median(rel), np.percentile(rel, 99), rel.max()))
    print("6. edepB/edep: min %.4f mean %.4f max %.4f" % (ratio.min(), ratio.mean(), ratio.max()))
    ok = n_id == 0 and d_rad < 1e-6 and d_lz < 1e-3 and d_lxy < 1e-6 and np.percentile(rel, 99) < 2e-3 \
        and ratio.min() > 0.5 and ratio.max() <= 1 + 1e-12
    print("ALL OK" if ok else "FAILURES")


if __name__ == "__main__":
    main()
