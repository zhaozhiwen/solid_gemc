#!/usr/bin/env python3
"""Phase 2 analysis of solid_spacal runs: sampling fractions, containment, sPHENIX-style digitization.

Per event (all fibers, 0-60 ns already applied in the hit process):
  sf_edep  = sum(edep)/E_beam,  sf_birks = sum(edepB)/E_beam,  sf_light = sum(light)/E_beam
sPHENIX comparison: Fun4All_G4_Prototype3.C uses sampling_fraction = 0.0190134 for the light yield
(RawTowerBuilder default kLightYield) and digitizes each sub-tower as
  N_pe = Poisson(light_GeV * 500 / sampling_fraction)    (photonelec_yield_visible_GeV)
so E_rec = sum(N_pe) / 500 GeV. We apply the same here (offline, Poisson only; no pedestal/ADC).

Usage: analyze_p2.py <tag> <run_dir> [<run_dir> ...]     (runs with the same beam are merged)
Writes plots/<tag>_*.png and prints a summary.
"""
import os
import re
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import uproot

SF_SPHENIX = 0.0190134
PE_PER_GEV = 500.0


def beam_energy(run):
    g = open(os.path.join(run, "gcard.gcard")).read()
    m = re.search(r'name="BEAM_P"\s+value="\s*[^,]+,\s*([0-9.]+)\*GeV', g)
    return float(m.group(1)) * 1000.0                    # MeV


def trimmed(x, nsig=2.5, it=5):
    m, s = x.mean(), x.std()
    for _ in range(it):
        y = x[np.abs(x - m) < nsig * s]
        m, s = y.mean(), y.std()
    return m, s, len(y)


def main():
    tag, runs = sys.argv[1], sys.argv[2:]
    E = {beam_energy(r) for r in runs}
    assert len(E) == 1, "runs have different beam energies: %s" % E
    E = E.pop()
    ev = dict(edep=[], edepB=[], light=[], core4=[], nhit=[])
    chans = {}
    for r in runs:
        a = uproot.open(os.path.join(r, "out.root"))["solid_spacal"].arrays(["id", "edep", "edepB", "light"], library="np")
        for k in range(len(a["id"])):
            ids = a["id"][k].astype(int)
            ev["edep"].append(a["edep"][k].sum())
            ev["edepB"].append(a["edepB"][k].sum())
            ev["light"].append(a["light"][k].sum())
            ev["nhit"].append(len(ids))
            u, inv = np.unique(ids, return_inverse=True)
            lc = np.bincount(inv, weights=a["light"][k])
            chans_ev = dict(zip(u, lc))
            chans.setdefault("events", []).append(chans_ev)
            ev["core4"].append(sum(v for c, v in chans_ev.items() if c // 100 == 111) / max(lc.sum(), 1e-30))
    for k in ev:
        ev[k] = np.array(ev[k])
    n = len(ev["edep"])

    # sPHENIX-style photo-electron digitization per channel
    rng = np.random.default_rng(12345)
    Erec = np.array([sum(rng.poisson(v / 1000.0 * PE_PER_GEV / SF_SPHENIX) for v in d.values()) / PE_PER_GEV
                     for d in chans["events"]]) * 1000.0  # MeV
    print("%s: E_beam %.0f MeV, %d events from %d run(s)" % (tag, E, n, len(runs)))
    for k, lab in (("edep", "sum edep"), ("edepB", "sum edepB (Birks)"), ("light", "sum light (Birks x maps)")):
        m, s, nn = trimmed(ev[k])
        print("  %-26s mean %8.2f MeV  sf = %.5f +- %.5f   rms/mean %.4f (trimmed 2.5 sigma: %.4f, %d ev)"
              % (lab, ev[k].mean(), ev[k].mean() / E, ev[k].std() / E / np.sqrt(n), ev[k].std() / ev[k].mean(), s / m, nn))
    print("  sPHENIX sampling_fraction (light) = %.5f; ratio ours/sPHENIX = %.3f" % (SF_SPHENIX, ev["light"].mean() / E / SF_SPHENIX))
    m, s, nn = trimmed(Erec)
    print("  E_rec (sPHENIX calibration, Poisson p.e.): mean %.1f MeV = %.3f E_beam, sigma/E %.4f (trimmed: %.4f)"
          % (Erec.mean(), Erec.mean() / E, Erec.std() / Erec.mean(), s / m))
    print("  light fraction in the 4 sub-towers of block s1 j1: mean %.3f; fiber hits/event %.0f" % (ev["core4"].mean(), ev["nhit"].mean()))

    os.makedirs("plots", exist_ok=True)
    fig, ax = plt.subplots(1, 2, figsize=(11, 4))
    for k, c in (("edep", "C0"), ("edepB", "C1"), ("light", "C2")):
        ax[0].hist(ev[k] / E, bins=40, histtype="step", color=c, label="%s: <sf> = %.4f" % (k, ev[k].mean() / E))
    ax[0].axvline(SF_SPHENIX, color="k", ls="--", label="sPHENIX light sf 0.0190")
    ax[0].set_xlabel("sum over fibers / E_beam"); ax[0].set_ylabel("events"); ax[0].legend(fontsize=8)
    ax[0].set_title("%s: %d events" % (tag, n))
    ax[1].hist(Erec / E, bins=40, color="C2", alpha=0.7)
    ax[1].set_xlabel("E_rec / E_beam (sPHENIX calibration, Poisson p.e.)"); ax[1].set_ylabel("events")
    ax[1].set_title("sigma/E = %.3f (trimmed %.3f)" % (Erec.std() / Erec.mean(), s / m))
    fig.tight_layout(); fig.savefig("plots/%s_sf.png" % tag, dpi=110)

    # 8x8 channel map of mean light: phi index = 2*s + (1 - subx) is not assumed; plot (sector, subx) x (tower, suby)
    grid = np.zeros((8, 8))
    for d in chans["events"]:
        for c, v in d.items():
            s, j, sx, sy = (c // 1000) % 10, (c // 100) % 10, (c // 10) % 10, c % 10
            grid[2 * j + sy, 2 * s + sx] += v / n
    fig, ax = plt.subplots(figsize=(5.2, 4.4))
    im = ax.imshow(grid, origin="lower", cmap="viridis")
    ax.set_xlabel("2*sector + subx"); ax.set_ylabel("2*tower + suby")
    ax.set_title("%s: mean light per channel [MeV]" % tag)
    fig.colorbar(im); fig.tight_layout(); fig.savefig("plots/%s_channels.png" % tag, dpi=110)
    print("  plots: plots/%s_sf.png, plots/%s_channels.png" % (tag, tag))


if __name__ == "__main__":
    main()
