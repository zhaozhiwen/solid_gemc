"""Draw the lite geometry boundaries (from solid_JPsi_LH2_lite_full.md) on the gemc side view.
The pixel scale below is fitted to solid_JPsi_LH2_lite_full.png; refit it for a new picture. Needs matplotlib and PIL.
usage, in this dir: python3 solid_JPsi_LH2_lite_full_outline.py solid_JPsi_LH2_lite_full.png solid_JPsi_LH2_lite_full_outline.png"""
import sys
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from PIL import Image

src, out = sys.argv[1], sys.argv[2]
im = Image.open(src).convert("RGB")
W, H = im.size
# pixel calibration from the yoke ends (z +-266.7 cm) and cryostat outer wall (r 176.59 cm) in the picture
sz, z0px = 1.0236, 405.0   # px per cm along z, pixel column of z=0
sr, r0px = 1.019, 472.0    # px per cm along y, pixel row of the beam axis
extent = [(0 - z0px) / sz, (W - z0px) / sz, (r0px - H) / sr, r0px / sr]

fig, ax = plt.subplots(figsize=(13, 12.3), dpi=100)
ax.imshow(im, extent=extent)
ax.set_xlabel("z (cm)"); ax.set_ylabel("y (cm)")
ax.set_xticks(range(-300, 600, 100)); ax.set_yticks(range(-400, 500, 100))
ax.grid(color="0.6", lw=0.4, ls=":")

# (label, z from, z to, r from, r to, color, label z, label r)
boxes = [
    ("GEM LA\nz -176 to -67\nr 43-132",      -176, -67.2,  43, 132,   "tab:red",    -330, 330),
    ("SPD LA + EC LA\nz -66 to -12\nr 78-143", -66.1, -12,  78, 142.6, "tab:orange", -175, 400),
    ("GEM FA\nz -1 to 181\nr 36-133",          -1, 180.8,  36, 133,   "tab:blue",     20, 400),
    ("cryostat\nz -189 to 189\nr 144-177",   -189, 189,   144, 176.59, "tab:green",  -330, 220),
    ("yoke (no endcap), octagon\nz -267 to 267\nr 144-279 (flat), 302 (corner)", -266.7, 266.7, 144, 278.832, "purple", 100, 330),
    ("SPD FA, MRPC\nz 428 to 436\nr 93-216",  427.65, 436.42, 93, 216,  "tab:brown",   380, -300),
    ("EC FA\nz 438 to 490\nr 89-226",          438, 490,   88.9, 226.2, "teal",        480, 330),
]
for text, za, zb, ra, rb, c, tz, tr in boxes:
    ax.add_patch(plt.Rectangle((za, ra), zb - za, rb - ra, fill=False, ec=c, lw=1.6))
    ax.annotate(text, xy=(za, rb if tr > 0 else ra), xytext=(tz, tr), color=c, fontsize=9,
                ha="left", va="center", arrowprops=dict(arrowstyle="-", color=c, lw=0.8),
                bbox=dict(fc="white", ec=c, lw=0.6, alpha=0.9))
    if tr < 0:  # mirror the box below the axis for labels placed there
        ax.add_patch(plt.Rectangle((za, -rb), zb - za, rb - ra, fill=False, ec=c, lw=1.6))
        ax.annotate("", xy=(za, -rb), xytext=(tz, tr), arrowprops=dict(arrowstyle="-", color=c, lw=0.8))

# light gas Cherenkov chamber polycone profile
hz = [205, 270, 316, 317, 317, 416, 426]
rmin = [60, 70, 77, 77, 77, 87, 225]
rmax = [140, 140, 187, 240, 240, 240, 240]
prof_z = hz + hz[::-1] + [hz[0]]
prof_r = rmax + rmin[::-1] + [rmax[0]]
ax.plot(prof_z, prof_r, color="goldenrod", lw=1.8)
ax.annotate("Cherenkov chamber\nz 205 to 426\nr 60-240", xy=(317, 240), xytext=(280, 420), color="goldenrod",
            fontsize=9, ha="left", va="center", arrowprops=dict(arrowstyle="-", color="goldenrod", lw=0.8),
            bbox=dict(fc="white", ec="goldenrod", lw=0.6, alpha=0.9))

# target and beam pipes
ax.add_patch(plt.Rectangle((-322.5, 0), 15, 2, fill=True, color="red"))
ax.annotate("LH2 target\nz -322.5 to -307.5", xy=(-315, 2), xytext=(-390, 120), color="red", fontsize=9,
            arrowprops=dict(arrowstyle="-", color="red", lw=0.8), bbox=dict(fc="white", ec="red", lw=0.6, alpha=0.9))
ax.plot([-302.5, 802.5], [1.8, 29], color="k", lw=1.0)
ax.annotate("exit beam pipe, r 1.8 to 29\nz -302.5 to 802.5", xy=(500, 1.8 + (29 - 1.8) * (802.5 / 1105)),
            xytext=(330, 90), fontsize=9, arrowprops=dict(arrowstyle="-", lw=0.8),
            bbox=dict(fc="white", ec="k", lw=0.6, alpha=0.9))

ax.set_xlim(extent[0], extent[1]); ax.set_ylim(extent[2], extent[3])
ax.set_title("solid_JPsi_LH2_lite_full: boundaries in cm (hall frame, upper half)", fontsize=11)
fig.tight_layout()
fig.savefig(out)
