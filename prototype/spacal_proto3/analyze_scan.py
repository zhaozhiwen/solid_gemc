#!/usr/bin/env python3
"""Energy-scan analysis: linearity and resolution of the SPACAL prototype (runs/scan-e<E>GeV-c<k>).

Per event: L = sum(light), B = sum(edepB) over all fibers (MeV). Three energy estimators:
  birks : E_birks = B / sf_sPHENIX                                   (sampling + Birks; no light maps)
  light : E_light = L / sf_sPHENIX                                   (+ fiber transmission and light-guide maps)
  pe    : E_pe    = sum_channels Poisson(L_ch[GeV] * 500/sf_sPHENIX) / 500  (sPHENIX digitization: + photo-statistics)
Peak: iterative +-2 sigma window; sigma corrected for the truncation of a Gaussian (std inside +-2 sigma = 0.8796 sigma).
Errors: 300 bootstrap resamples. Resolution fit: (sigma/E)^2 = a^2/E + b^2 (weighted linear least squares in 1/E).
Usage: analyze_scan.py   -> prints a table, writes plots/scan_resolution.png, plots/scan_peaks.png
"""
import glob
import os
import re
from math import erf, exp, pi, sqrt

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import uproot

SF = 0.0190134
PE_PER_GEV = 500.0
K = 2.0
TRUNC = sqrt(1 - 2 * K * exp(-K * K / 2) / sqrt(2 * pi) / erf(K / sqrt(2)))   # 0.8796 for K = 2


def peak(x, it=20):
    m, s = np.median(x), x.std()
    for _ in range(it):
        w = x[np.abs(x - m) < K * s]
        m_new, s_new = w.mean(), w.std() / TRUNC
        if abs(m_new - m) < 1e-9 * abs(m) and abs(s_new - s) < 1e-9 * s:
            break
        m, s = m_new, s_new
    return m, s


def boot(x, rng, n=300):
    r = np.array([peak(rng.choice(x, len(x))) for _ in range(n)])
    return r[:, 0].std(), r[:, 1].std()


def load(E):
    L, B, Lch = [], [], []
    for r in sorted(glob.glob("runs/scan-e%dGeV-c*" % E)):
        a = uproot.open(os.path.join(r, "out.root"))["solid_spacal"].arrays(["id", "light", "edepB"], library="np")
        for k in range(len(a["id"])):
            L.append(a["light"][k].sum())
            B.append(a["edepB"][k].sum())
            u, inv = np.unique(a["id"][k].astype(int), return_inverse=True)
            Lch.append(np.bincount(inv, weights=a["light"][k]))
    return np.array(L), np.array(B), Lch


def fit_res(E, r, dr):
    """(r)^2 = a^2/E + b^2, weights 1/var(r^2)."""
    y, dy = r ** 2, 2 * r * dr
    A = np.stack([1 / E, np.ones_like(E)], axis=1) / dy[:, None]
    coef, *_ = np.linalg.lstsq(A, y / dy, rcond=None)
    cov = np.linalg.inv(A.T @ A)
    a2, b2 = coef
    a, b = sqrt(max(a2, 0)), sqrt(max(b2, 0))
    da = sqrt(cov[0, 0]) / (2 * a) if a > 0 else float("nan")
    db = sqrt(cov[1, 1]) / (2 * b) if b > 0 else float("nan")
    chi2 = float(((A @ coef - y / dy) ** 2).sum())
    return a, da, b, db, chi2, len(E) - 2


def main():
    energies = sorted({int(re.search(r"scan-e(\d+)GeV", d).group(1)) for d in glob.glob("runs/scan-e*GeV-c*")})
    rng = np.random.default_rng(2026)
    rows = {"birks": [], "light": [], "pe": []}
    peaks = {}
    for E in energies:
        L, B, Lch = load(E)
        est = {"birks": B / SF / 1000.0,
               "light": L / SF / 1000.0,
               "pe": np.array([rng.poisson(l / 1000.0 * PE_PER_GEV / SF).sum() for l in Lch]) / PE_PER_GEV}
        for k, x in est.items():
            m, s = peak(x)
            dm, ds = boot(x, rng)
            rows[k].append((E, len(x), m / E, dm / E, s / m, ds / m))
        peaks[E] = est["pe"]
    print("E[GeV]  N    | birks: mean/E  sigma/E      | light: mean/E  sigma/E      | p.e.: mean/E   sigma/E")
    for rb, rl, rp in zip(rows["birks"], rows["light"], rows["pe"]):
        print("%5d  %4d  | %.4f  %.4f+-%.4f | %.4f  %.4f+-%.4f | %.4f  %.4f+-%.4f"
              % (rb[0], rb[1], rb[2], rb[4], rb[5], rl[2], rl[4], rl[5], rp[2], rp[4], rp[5]))
    fits = {}
    for k in rows:
        R = np.array(rows[k])
        fits[k] = fit_res(R[:, 0], R[:, 4], R[:, 5])
        a, da, b, db, chi2, ndf = fits[k]
        print("%-5s fit: sigma/E = (%.2f +- %.2f)%%/sqrt(E) (+) (%.2f +- %.2f)%%   chi2/ndf = %.1f/%d"
              % (k, 100 * a, 100 * da, 100 * b, 100 * db, chi2, ndf))

    os.makedirs("plots", exist_ok=True)
    fig, ax = plt.subplots(1, 2, figsize=(11, 4.2))
    Ef = np.linspace(min(energies) * 0.9, max(energies) * 1.05, 200)
    for k, c, lab in (("birks", "C2", "sampling + Birks (no light maps)"), ("light", "C0", "+ light maps"),
                      ("pe", "C3", "+ photo-statistics (sPHENIX p.e.)")):
        R = np.array(rows[k]); a, da, b, db, _, _ = fits[k]
        ax[0].errorbar(R[:, 0], 100 * R[:, 4], yerr=100 * R[:, 5], fmt="o", color=c,
                       label="%s: %.1f%%/$\\sqrt{E}$ $\\oplus$ %.1f%%" % (lab, 100 * a, 100 * b))
        ax[0].plot(Ef, 100 * np.sqrt(a * a / Ef + b * b), color=c, lw=1)
        ax[1].errorbar(R[:, 0], R[:, 2], yerr=R[:, 3], fmt="o", color=c, label=lab)
    ax[0].set_xlabel("E beam [GeV]"); ax[0].set_ylabel("sigma/E [%]"); ax[0].legend(fontsize=8)
    ax[0].set_title("SPACAL proto3, e- at block s1 j1 centre, 0.7 cm spot")
    ax[1].set_xlabel("E beam [GeV]"); ax[1].set_ylabel("E_rec / E beam (sPHENIX sf 0.0190)"); ax[1].legend(fontsize=8)
    ax[1].set_title("linearity")
    fig.tight_layout(); fig.savefig("plots/scan_resolution.png", dpi=110)

    fig, axs = plt.subplots(2, 4, figsize=(13, 5.5))
    for axx, E in zip(axs.flat, energies):
        x = peaks[E] / E
        m, s = peak(x)
        axx.hist(x, bins=40, color="C3", alpha=0.6)
        g = np.linspace(m - 3 * s, m + 3 * s, 100)
        w = (x.max() - x.min()) / 40
        axx.plot(g, len(x) * w / (s * sqrt(2 * pi)) * np.exp(-0.5 * ((g - m) / s) ** 2), "k", lw=1)
        axx.set_title("%d GeV: sigma/E %.2f%%" % (E, 100 * s / m), fontsize=9)
    fig.supxlabel("E_rec / E beam (p.e.)"); fig.tight_layout(); fig.savefig("plots/scan_peaks.png", dpi=110)
    print("plots: plots/scan_resolution.png, plots/scan_peaks.png")


if __name__ == "__main__":
    main()
