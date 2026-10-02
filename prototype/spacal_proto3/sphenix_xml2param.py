#!/usr/bin/env python3
"""Convert an sPHENIX PdbParameterMap geometry XML into GEMC __parameters text files.

Usage: sphenix_xml2param.py <geo.xml> <detector_name>
Writes <detector_name>__parameters_{Original,nofiber,mini}.txt.

Names are flattened for Perl: sector_map[i].x -> sector<i>_x, sector_tower_map[j].x -> tower<j>_x.
Units as in sPHENIX: lengths cm, angles rad. String params (cparams) are dropped: GEMC's TEXT parameter
factory evaluates every value as a number. Materials are set in the Perl generators instead.
The "nofiber" variation is Original with fibers skipped by the generator (overlap check of the rest).
The "mini" variation keeps sector 0 and tower 0 only, with a 6x4 fiber lattice, for fast geometry tests.
"""
import re
import sys


def read_params(path):
    text = open(path).read()
    out = {}
    for sect in ("dparams", "iparams", "cparams"):
        m = re.search(r"<%s>(.*?)</%s>" % (sect, sect), text, re.S)
        if not m:
            continue
        toks = re.findall(r'<(?:string|Double_t|Int_t)\s+v="([^"]*)"', m.group(1))
        n = int(toks[0])  # first token is the entry count
        kv = toks[1:]
        assert len(kv) == 2 * n, (sect, len(kv), n)
        for i in range(0, len(kv), 2):
            out[kv[i]] = (sect, kv[i + 1])
    return out


def flat(name):
    name = re.sub(r"^sector_tower_map\[(\d+)\]\.", r"tower\1_", name)
    name = re.sub(r"^sector_map\[(\d+)\]\.", r"sector\1_", name)
    return name


def unit(name, sect):
    if sect == "iparams":
        return "counts"
    if re.search(r"(rotation|pTheta|pPhi|pAlp\d|pRotationAngleX|azimuthal_tilt)$", name):
        return "rad"
    if re.search(r"(TaperRatio|polar_taper_ratio)$", name):
        return "counts"   # dimensionless; GEMC's parameter factory evaluates value*unit
    if name.endswith("z_rotation_degree"):
        return "deg"
    return "cm"


def write(path, params, src):
    with open(path, "w") as f:
        for name, val, u, desc in MODEL:
            f.write("%-34s | %-24s | %-6s | %s | spacal_proto3 | - | - | - | - | -\n" % (name, val, u, desc))
        for name in sorted(params):
            sect, val = params[name]
            if sect == "cparams":
                continue   # strings (description, material names): GEMC parses every value as a number
            fname = flat(name)
            f.write("%-34s | %-24s | %-6s | %s | sPHENIX | - | %s | - | - | -\n"
                    % (fname, val, unit(name, sect), name, src))


# Parameters of the solid_spacal hit process (not in the sPHENIX geometry XML). Units as GEMC evaluates them:
# kB is a plain number in mm/MeV (GEMC internal units mm = MeV = 1).
MODEL = [
    ("spacal_birks_kB", "0.07943", "counts", "Birks kB in mm/MeV: Geant4 10.7 G4EmSaturation value for G4_POLYSTYRENE"),
    ("spacal_time_min", "0", "ns", "start of sPHENIX cell timing window (PHG4FullProjSpacalCellReco set_timing_window)"),
    ("spacal_time_max", "60", "ns", "end of sPHENIX cell timing window (Fun4All_G4_Prototype3.C)"),
]


def main():
    xml, det = sys.argv[1], sys.argv[2]
    params = read_params(xml)
    src = xml.split("/")[-1]
    write(det + "__parameters_Original.txt", params, src)
    write(det + "__parameters_nofiber.txt", params, src + " (nofiber: Original without fibers)")

    mini = {}
    for name, (sect, val) in params.items():
        m = re.match(r"^(sector_tower_map|sector_map)\[(\d+)\]\.", name)
        if m and m.group(2) != "0":
            continue
        mini[name] = (sect, val)
    mini["sector_map_size"] = ("iparams", "1")
    mini["sector_tower_map_size"] = ("iparams", "1")
    mini["sector_tower_map[0].NFiberX"] = ("iparams", "6")
    mini["sector_tower_map[0].NFiberY"] = ("iparams", "4")
    write(det + "__parameters_mini.txt", mini, src + " (mini: sector0, tower0, 6x4 fibers)")


if __name__ == "__main__":
    main()
