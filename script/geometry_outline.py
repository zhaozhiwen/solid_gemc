"""Hall-frame z and r extents of the root-level volumes of every TEXT detector in a gcard.
usage, from the dir gemc runs in (e.g. script/): python3 geometry_outline.py <gcard> [run dir, default .]"""
import math, re, sys, collections

gcard = sys.argv[1]
rundir = sys.argv[2] if len(sys.argv) > 2 else "."

def num(s):
    s = s.strip()
    m = re.match(r'^([-+0-9.eE]+)\*(cm|mm|m|deg|counts)$', s)
    if m:
        v = float(m.group(1)); u = m.group(2)
        return v * {'cm': 1, 'mm': 0.1, 'm': 100, 'deg': 1, 'counts': 1}[u]
    return float(s)

def extent(typ, dims, vols):
    """local (zmin, zmax, rmin, rmax) about the volume's own axis"""
    d = [num(x) for x in dims.split()] if typ not in ('Operation',) else []
    if typ == 'Tube':
        return -d[2], d[2], d[0], d[1]
    if typ == 'Cons':
        return -d[4], d[4], min(d[0], d[2]), max(d[1], d[3])
    if typ == 'Polycone':
        n = int(d[2]); rin, rout, z = d[3:3+n], d[3+n:3+2*n], d[3+2*n:3+3*n]
        return min(z), max(z), min(rin), max(rout)
    if typ == 'Pgon':  # radii are tangent distances; outer corner = r/cos(pi/nsides)
        ns, n = int(d[2]), int(d[3]); rin, rout, z = d[4:4+n], d[4+n:4+2*n], d[4+2*n:4+3*n]
        return min(z), max(z), min(rin), max(rout) / math.cos(math.pi / ns)
    if typ == 'Box':
        return -d[2], d[2], 0, math.hypot(d[0], d[1])
    raise ValueError(typ)

def solid_extent(name, vols):
    v = vols[name]
    t = v['type']
    if t.startswith('CopyOf'):
        return solid_extent(t.split()[1], vols)
    if t.startswith('Operation'):
        expr = t.split(':', 1)[1].replace('@', '').split()
        a, op, b = expr[0], expr[1], expr[2]
        za, zb, ra, rb = solid_extent(a, vols)
        if op == '-' and vols[b]['type'] == 'Tube':  # a tube-shaped hole sets the inner radius
            _, _, _, hole = solid_extent(b, vols)
            ra = max(ra, hole)
        return za, zb, ra, rb
    return extent(t, v['dims'], vols)

lines = open(gcard).read().split('</gcard>')[0]
dets = re.findall(r'<detector name="([^"]+)" factory="TEXT" variation="([^"]+)"', lines)
for path, var in dets:
    f = f"{rundir}/{path}__geometry_{var}.txt"
    vols = collections.OrderedDict()
    for row in open(f):
        c = [x.strip() for x in row.split('|')]
        vols[c[0]] = dict(mother=c[1], pos=c[3], rot=c[4], type=c[6], dims=c[7], mat=c[8], exist=c[12])
    print(f"## {path.split('/')[-1]} ({var})  [{path}]")
    groups = collections.OrderedDict()
    for n, v in vols.items():
        if v['mother'] != 'root' or v['mat'] == 'Component' or v['exist'] == '0':
            continue
        x, y, z = [num(s) for s in v['pos'].split()[:3]]
        rot = v['rot']
        rv = [num(s) for s in rot.replace('ordered:', '').split() if '*' in s]
        if any(abs(a) > 1e-9 for a in rv[:2]):
            print(f"   WARNING {n} rotated about x/y: {rot}")
        z0, z1, r0, r1 = solid_extent(n, vols)
        rc = math.hypot(x, y)
        if rc > 1e-6:  # off-axis volume: radial range of its body
            r0, r1 = max(0.0, rc - r1), rc + r1
        key = re.sub(r'\d+$', '#', n) if v['type'].startswith('CopyOf') or re.search(r'424$', n) else n
        key = re.sub(r'(prescin|prescint|showe|shower|suppor|support)\d*#?$', lambda m: m.group(1)[:6] + '*', key)
        g = groups.setdefault(key, [1e9, -1e9, 1e9, -1e9, 0, v['mat']])
        g[0] = min(g[0], z + z0); g[1] = max(g[1], z + z1); g[2] = min(g[2], r0); g[3] = max(g[3], r1); g[4] += 1
    for k, (z0, z1, r0, r1, cnt, mat) in groups.items():
        print(f"   {k:55s} n={cnt:<5d} z {z0:9.3f} .. {z1:9.3f}   r {r0:8.3f} .. {r1:8.3f}   {mat}")
