# Проверка размеров STL сечениями (trimesh + shapely). Запуск из корня репозитория:
#   pip install trimesh shapely scipy rtree networkx && python3 tools/verify_stl.py
# Внимание: to_2D() центрирует координаты сечения; абсолютные X/Y в выводе Z-сечений смещены,
# относительные размеры (шаги, ширины, диаметры) верны. Вырезы бортов пересчитаны в мировые координаты.
import trimesh, numpy as np, warnings
warnings.filterwarnings("ignore")
from shapely.geometry import Polygon
box = trimesh.load('stl/sprut_box.stl', force='mesh')
bz  = trimesh.load('stl/sprut_bezel.stl', force='mesh')
def slice_polys(mesh, origin, normal):
    s = mesh.section(plane_origin=origin, plane_normal=normal); p2, T = s.to_2D(); return p2, T
def report(title, val, expect, tol=0.05):
    print(f"{'OK ' if abs(val-expect) <= tol else '!! '} {title}: {val:.2f}  (ожид. {expect:.2f})")

print("=== ПРОЁМ ПОД МОНИТОР (сечение Z=50, над полками) ===")
p2, T = slice_polys(box, [0,0,50], [0,0,1])
outer = max(p2.polygons_full, key=lambda p: p.area)
holes = sorted(outer.interiors, key=lambda r: Polygon(r).area, reverse=True)
minx,miny,maxx,maxy = Polygon(holes[0]).bounds
report("проём ширина (между внутр. стенками)", maxx-minx, 239.2); report("проём высота", maxy-miny, 147.4)
report("проём левый край X", minx, 13.0); report("проём нижний край Y", miny, 3.0)
print("   монитор 237.2 x 145.4 -> зазор по бокам %.2f, сверху/снизу %.2f" % (((maxx-minx)-237.2)/2, ((maxy-miny)-145.4)/2))

print("\n=== ПОЛКИ ===")
def opening(z):
    p2,_ = slice_polys(box, [0,0,z], [0,0,1]); outer = max(p2.polygons_full, key=lambda p:p.area)
    return Polygon(max(outer.interiors, key=lambda r: Polygon(r).area)).bounds
for z in [41.3, 41.1, 39.0]:
    bb = opening(z); print(f"   Z={z}: проём X {bb[0]:.2f}..{bb[2]:.2f} (шир {bb[2]-bb[0]:.2f}), Y {bb[1]:.2f}..{bb[3]:.2f} (выс {bb[3]-bb[1]:.2f})")
print("   ожидание: при Z<41.2 проём уже на 2x2.5 по X (боковые полки) и по Y (сегменты полок)")

print("\n=== СТОЙКИ RASPBERRY PI (сечение Z=5) ===")
p2,_ = slice_polys(box, [0,0,5], [0,0,1])
circles = [p for p in p2.polygons_full if 20 < p.area < 40]
cent = sorted([(round(p.centroid.x,2), round(p.centroid.y,2), round(2*np.sqrt(p.area/np.pi),2)) for p in circles])
for c in cent: print("   стойка центр", c[:2], "Ø", c[2])
xs = sorted(set(c[0] for c in cent)); ys = sorted(set(c[1] for c in cent))
if len(xs)==2 and len(ys)==2:
    report("шаг стоек по X (49, короткая сторона Pi)", xs[1]-xs[0], 49.0); report("шаг стоек по Y (58, длинная сторона)", ys[1]-ys[0], 58.0)
    report("край платы Pi до правой внутр. стенки", 252.2 - (xs[1] + 3.5), 2.0)
    report("торец USB платы Pi до нижнего борта", (ys[0] - 3.5) - 3.0, 1.0)
p2,_ = slice_polys(box, [0,0,7], [0,0,1])
for p in p2.polygons_full:
    if 20 < p.area < 40 and len(p.interiors)==1:
        report("отверстие в стойке Ø (саморез M2.5)", 2*np.sqrt(Polygon(p.interiors[0]).area/np.pi), 2.2, 0.1); break

print("\n=== ВЫРЕЗЫ В НИЖНЕМ БОРТУ (сечение Y=1.5) ===")
p2, T = slice_polys(box, [0,1.5,0], [0,1,0])
outer = max(p2.polygons_full, key=lambda p:p.area)
def to_world(pt): return (T @ np.array([pt[0], pt[1], 0, 1.0]))[:3]
rows=[]
for r in outer.interiors:
    pg = Polygon(r); (a,b,c,d) = pg.bounds; w0 = to_world((a,b)); w1 = to_world((c,d))
    xs_ = sorted([w0[0], w1[0]]); zs_ = sorted([w0[2], w1[2]]); rows.append((np.mean(xs_), xs_, zs_))
for cx, xs_, zs_ in sorted(rows):
    print(f"   вырез X {xs_[0]:.2f}..{xs_[1]:.2f} (ш {xs_[1]-xs_[0]:.2f}, центр {cx:.2f})  Z {zs_[0]:.2f}..{zs_[1]:.2f} (в {zs_[1]-zs_[0]:.2f}, центр {np.mean(zs_):.2f})")
print("   ожидание: XT60 винты Ø2.5 @X=21 и 41, Z=15 | XT60 тело 16.1x8.7 @X=31 | BNC Ø9.9 @X=69 | RJ45 16.8x14.3 @X=101 | окно Pi X 195.15..249.45, Z 8..28.1")

print("\n=== РАМКА ===")
for z, tag, exp in [(0.2, "окно у наружной стороны (фаска)", (230.0-0.4, 132.5-0.4)), (2.8, "окно у внутренней стороны", (224.0, 126.5))]:
    p2,_ = slice_polys(bz, [0,0,z], [0,0,1]); outer = max(p2.polygons_full, key=lambda p:p.area)
    ints = sorted(outer.interiors, key=lambda r: Polygon(r).area, reverse=True)
    (a,b,c,d) = Polygon(ints[0]).bounds
    report(f"{tag} ширина", c-a, exp[0], 0.2); report(f"{tag} высота", d-b, exp[1], 0.2)
    print(f"      центр окна X={np.mean([a,c]):.2f} (центр монитора {13+1+237.2/2:.2f}), Y={np.mean([b,d]):.2f} (H/2={153.4/2:.2f})")
    if z == 2.8:
        hs = [Polygon(r) for r in ints[1:]]
        print("      отверстия под винты (x, y, Ø):", sorted([(round(h.centroid.x,1), round(h.centroid.y,1), round(2*np.sqrt(h.area/np.pi),2)) for h in hs]))
p2,_ = slice_polys(box, [0,0,52], [0,0,1]); outer = max(p2.polygons_full, key=lambda p:p.area)
ins = [Polygon(r) for r in outer.interiors if 10 < Polygon(r).area < 15]
print("   отверстия под вставки M3 в коробке (x, y, Ø):", sorted([(round(h.centroid.x,1), round(h.centroid.y,1), round(2*np.sqrt(h.area/np.pi),2)) for h in ins]))
print("   ожидание: X=7 и 258.2; Y=7, 76.7, 146.4; Ø4.0")

print("\n=== ДЕРЖАТЕЛИ DC-DC / RS485 (сечение Z=3, внутри паза) ===")
p2,_ = slice_polys(box, [0,0,3.0], [0,0,1])
rails = [p for p in p2.polygons_full if 20 < p.area < 200 and p.bounds[0] < 120]
for p in sorted(rails, key=lambda p:(round(p.centroid.y), p.centroid.x)):
    (a,b,c,d)=p.bounds; print(f"   элемент X {a:.2f}..{c:.2f} (дл {c-a:.2f})  Y {b:.2f}..{d:.2f} (ш {d-b:.2f})")
print("   ожидание DC-DC 43x21 @ (63,46): паз между Y=35.33 и 56.67 (=21+0.35)")
print("   ожидание RS485 34x18 @ (63,84): паз между Y=74.83 и 93.17 (=18+0.35)")

print("\n=== ГЛУБИНЫ ===")
print("   задняя стенка 3 + стойка 6 + плата 1.6 + USB 16 = 26.6 -> верх полок 41.2: запас над Pi %.1f мм" % (41.2-26.6))
print("   DC-DC: 3 + 2 + 1.6 + 13 = 19.6 -> запас до монитора %.1f мм" % (41.2-19.6))
print("   XT60 тело внутрь: борт 3 + 9.5 + 4 = до Y=16.5; держатель DC-DC начинается с Y=%.1f" % (46-10.5-1))
