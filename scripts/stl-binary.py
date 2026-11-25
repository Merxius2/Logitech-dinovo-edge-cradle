#!/usr/bin/env python3
"""Weld an OpenSCAD ASCII STL and write a binary STL."""
import struct
import sys

def read_ascii(path):
    tris = []
    cur = []
    for line in open(path, "r", errors="replace"):
        line = line.strip()
        if line.startswith("vertex"):
            cur.append(tuple(float(v) for v in line.split()[1:4]))
            if len(cur) == 3:
                tris.append(cur)
                cur = []
    return tris

def weld(tris, tol=0.01):
    scale = 1.0 / tol
    index = {}
    verts = []

    def vid(p):
        key = tuple(int(round(c * scale)) for c in p)
        if key not in index:
            index[key] = len(verts)
            verts.append(p)
        return index[key]

    faces = []
    for tri in tris:
        ids = [vid(p) for p in tri]
        if len(set(ids)) == 3:
            faces.append(ids)
    return verts, faces

def write_binary(path, verts, faces):
    with open(path, "wb") as f:
        f.write(b"diNovo Edge cradle".ljust(80, b" "))
        f.write(struct.pack("<I", len(faces)))
        for a, b, c in faces:
            p, q, r = verts[a], verts[b], verts[c]
            ux, uy, uz = q[0] - p[0], q[1] - p[1], q[2] - p[2]
            vx, vy, vz = r[0] - p[0], r[1] - p[1], r[2] - p[2]
            nx = uy * vz - uz * vy
            ny = uz * vx - ux * vz
            nz = ux * vy - uy * vx
            length = (nx * nx + ny * ny + nz * nz) ** 0.5 or 1.0
            f.write(struct.pack(
                "<12fH",
                nx / length, ny / length, nz / length,
                *p, *q, *r, 0,
            ))

def main():
    src, dest = sys.argv[1], sys.argv[2]
    verts, faces = weld(read_ascii(src))
    write_binary(dest, verts, faces)
    print(f"  {dest}: {len(faces)} triangles")

if __name__ == "__main__":
    main()
