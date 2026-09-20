// =====================================================================
//  SPRUT — корпус: 10.1" монитор + Raspberry Pi 4B + DC-DC 60V buck
//  + RS485-TTL + XT60E-M + RJ45 + BNC
//
//  Печать: Creality K2 Plus, PETG. Все размеры в мм.
//
//  Конструкция из двух деталей:
//    "box"   — коробка: задняя стенка + 4 борта, открыта СПЕРЕДИ. На задней
//              стенке стойки Pi и держатели модулей; в бортах вырезы под
//              разъёмы; по бокам два канала с бобышками под вставки M3.
//              Монитор укладывается спереди на полки, затем прикручивается
//              лицевая рамка. Печатать как смоделирована (задней стенкой вниз).
//    "bezel" — лицевая рамка с окном экрана, 6 винтов M3 с потаем.
//              В STL уже развёрнута лицевой стороной вниз.
//    "assembly" — сборка с макетами компонентов (только для просмотра).
//
//  Система координат: X — ширина, Y — высота (вид спереди), Z — от наружной
//  плоскости задней стенки (Z=0) к лицевой рамке.
// =====================================================================

part = "assembly";   // [box, bezel, assembly]

$fn = 48;
eps = 0.01;

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — печать / стенки
// ---------------------------------------------------------------------
wall     = 3.0;    // толщина бортов
back_t   = 3.0;    // толщина задней стенки
bezel_t  = 3.0;    // толщина лицевой рамки
corner_r = 5.0;    // радиус наружных углов (вид спереди)
clr      = 1.0;    // зазор монитор/стенки на сторону
ch_w     = 8.0;    // ширина боковых каналов под бобышки (= диаметр бобышки)
in_wall  = 2.0;    // толщина внутренней стенки канала
shelf_w  = 2.5;    // ширина полки под край монитора

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — монитор 10.1" 1024x600 (JRP1133 DCT)
// Габарит по замеру владельца: 237.2 x 145.4 x 14.5 мм (толщина полная,
// задняя сторона считается плоской — монитор лежит задней кромкой на полках).
// Активная область не замерялась: окно = типовые 222.7 x 125.3 + 1 мм,
// по центру. Если светящаяся область смещена — поправь view_dx / view_dy.
// ---------------------------------------------------------------------
mon_w   = 237.2;   // ширина монитора (габарит)
mon_h   = 145.4;   // высота
mon_t   = 14.5;    // полная толщина монитора
view_w  = 224.0;   // окно в рамке (активная область + ~1 мм)
view_h  = 126.5;
view_dx = 0.0;     // смещение окна от центра панели (+ вправо)
view_dy = 0.0;     // (+ вверх)
drv_zone = 12.0;   // свободная глубина за монитором под разъёмы HDMI/USB и кабели
// полки под длинные края панели: сегменты [x_start, длина] от левого края панели
shelf_segs = [[0, 30], [mon_w/2 - 15, 30], [mon_w - 30, 30]];

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — Raspberry Pi 4B (официальный чертёж, datasheet rev 1.1)
// Pi лежит на задней стенке, компонентами к экрану, торцом USB/ETH к
// нижнему борту. По умолчанию полностью внутри корпуса: USB и Ethernet
// подключаются внутри (патч-корд на панельный RJ45), окна в борту нет.
// ---------------------------------------------------------------------
pi_l = 85.0;  pi_w = 56.0;  pi_pcb_t = 1.6;
pi_hole_dx = 58.0; pi_hole_dy = 49.0; pi_hole_off = 3.5;
pi_standoff_h = 6.0;  pi_standoff_d = 6.5;
pi_screw_d    = 2.2;   // саморез M2.5 в PETG (2.0 — под метчик M2.5)
pi_usb2_y = 9.0;  pi_usb3_y = 27.0;  pi_eth_y = 45.75;   // центры по короткой стороне
pi_usb_w  = 13.1; pi_usb_h = 16.0;   pi_eth_w = 16.0; pi_eth_h = 13.5;
pi_port_overhang = 2.5;   // выступ USB/ETH за край платы
pi_ports_window = false;  // true: окно в нижнем борту под USB/ETH; false: Pi полностью внутри
pi_edge_gap = pi_ports_window ? 1.0 : 35.0;   // торец USB/ETH до борта: 1 мм (в окно) или 35 мм под кабели внутри

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — DC-DC 60V/3A buck (CR-6030L). Габарит платы — ОЦЕНКА по фото
// и листингу (~4x2 см). Поправь после замера.
// ---------------------------------------------------------------------
dcdc_l = 43.0;  dcdc_w = 21.0;  dcdc_pcb_t = 1.6;  dcdc_comp_h = 13.0;

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — RS485-TTL модуль (по фото продавца 34 x 18 x 9)
// ---------------------------------------------------------------------
rs_l = 34.0;  rs_w = 18.0;  rs_pcb_t = 1.6;  rs_comp_h = 8.0;

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — панельные разъёмы (нижний борт)
// ---------------------------------------------------------------------
// XT60E-M (даташит Amass): фланец 27.0 x 8.1, отв. Ø3.0 шаг 20.0,
// тело 15.5 x 8.1 (восьмиугольник), глубина за фланцем 9.5 + контакты 4.0
xt_body_l = 15.5; xt_body_w = 8.1; xt_hole_pitch = 20.0;
xt_cut_clr = 0.3;  xt_screw_d = 2.5;   // 2.5 — саморез M3 в пластик; 3.2 — под болт M3
// RJ45 гнездо на плату (8P8C, корпус 15.9 x 21.6 x 13.4)
rj_w = 16.0; rj_h = 13.5; rj_clr = 0.4;
// BNC панельный, резьба 3/8"-32: отверстие Ø9.6. bnc_flat>0 — D-образное
// отверстие с лыской (размер «по лыске»), 0 — круглое.
bnc_d = 9.6; bnc_flat = 0; bnc_clr = 0.15;

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — крепёж рамки, VESA
// ---------------------------------------------------------------------
insert_d = 4.0;        // отверстие под резьбовую вставку M3 (OD 4.5-4.6) в PETG
insert_depth = 8.0;
bz_screw_d = 3.4;      // сквозное под M3 в рамке
bz_csk_d = 6.4;        // потай
vesa = 100;            // 0 = без VESA; 75 или 100
vesa_screw_d = 4.3;    // M4

// ---------------------------------------------------------------------
// ПРОИЗВОДНЫЕ РАЗМЕРЫ
// ---------------------------------------------------------------------
side = ch_w + in_wall;                 // боковой канал + внутренняя стенка
cav_w = mon_w + 2*clr;                 // полость под монитор (между внутр. стенками)
cav_h = mon_h + 2*clr;
W = cav_w + 2*side + 2*wall;           // наружная ширина
H = cav_h + 2*wall;                    // наружная высота
pi_stack = pi_standoff_h + pi_pcb_t + pi_usb_h;                 // 23.6
D_in  = ceil(pi_stack + 2.0 + drv_zone + mon_t + 0.3);            // внутренняя глубина
Z_fr  = back_t + D_in;                 // плоскость прилегания рамки (верх бортов)
z_shelf = Z_fr - (mon_t + 0.3);        // плоскость полок под панель
D_total = Z_fr + bezel_t;
x_cav0 = wall + side;                  // левая внутренняя стенка (грань полости)
x_cav1 = W - wall - side;

echo(str("НАРУЖНЫЙ ГАБАРИТ: ", W, " x ", H, " x ", D_total, " мм (ШxВxГ), рамка ", bezel_t, " мм"));
echo(str("Полость под монитор: ", cav_w, " x ", cav_h, ", глубина коробки ", D_in));

// бобышки: по 3 в каждом боковом канале
boss_pts = [for (x = [wall + ch_w/2, W - wall - ch_w/2], y = [wall + ch_w/2, H/2, H - wall - ch_w/2]) [x, y]];

// Raspberry Pi: поворот -90°: мир_x = pi_x0 + py, мир_y = pi_y0 + (85 - px)
pi_x0 = x_cav1 - 2.0 - pi_w;
pi_y0 = wall + pi_edge_gap;
pi_holes = [for (px=[pi_hole_off, pi_hole_off + pi_hole_dx], py=[pi_hole_off, pi_hole_off + pi_hole_dy]) [pi_x0 + py, pi_y0 + pi_l - px]];

// разъёмы на нижнем борту: X центра, Z центра
conn_z = back_t + 12.0;
xt_x  = x_cav0 + 18.0;
bnc_x = x_cav0 + 56.0;
rj_x  = x_cav0 + 88.0;

// держатели модулей на задней стенке (центр платы, поворот)
dcdc_pos = [x_cav0 + 50.0, 46.0];  dcdc_rot = 0;
rs_pos   = [x_cav0 + 50.0, 84.0];  rs_rot   = 0;

// =====================================================================
//  ВСПОМОГАТЕЛЬНЫЕ
// =====================================================================
module rrect(w, h, r) { hull() for (x=[r, w-r], y=[r, h-r]) translate([x, y]) circle(r=r); }
module rbox(w, h, d, r) { linear_extrude(d) rrect(w, h, r); }

// ряд вертикальных щелей в борту, вырез вдоль Y; x0..x1 — по X, z0..z1 — по Z
module slot_row(x0, x1, z0, z1, pitch=8, sw=3) {
  n = floor((x1 - x0 - sw)/pitch);
  for (i=[0:n]) translate([x0 + i*pitch + sw/2, 0, 0]) hull() {
    translate([0, 0, z0 + sw/2]) rotate([-90,0,0]) cylinder(d=sw, h=wall + 2, center=true);
    translate([0, 0, z1 - sw/2]) rotate([-90,0,0]) cylinder(d=sw, h=wall + 2, center=true);
  }
}
// щель в задней стенке (вдоль Y), центр (x,y), длина len
module back_slot(x, y, len, sw=2.5) {
  translate([x, y, -1]) linear_extrude(back_t + 2) hull() for (s=[-1,1]) translate([0, s*(len - sw)/2]) circle(d=sw);
}
// полка с фаской 45°: лежит вдоль X, выступает от стенки на shelf_w в направлении dir (по Y)
module shelf(x0, len, y_wall, dir) {
  hull() {
    translate([x0, dir > 0 ? y_wall : y_wall - shelf_w, z_shelf - eps]) cube([len, shelf_w, eps]);
    translate([x0, dir > 0 ? y_wall : y_wall - eps, z_shelf - shelf_w]) cube([len, eps, eps]);
  }
}

// =====================================================================
//  КОРОБКА
// =====================================================================
module box() {
  difference() {
    union() {
      difference() {
        rbox(W, H, Z_fr, corner_r);
        translate([wall, wall, back_t]) rbox(W - 2*wall, H - 2*wall, D_in + 1, 2);
      }
      // внутренние стенки боковых каналов (на всю высоту: фиксируют монитор по X) + полка с фаской
      for (x = [x_cav0 - in_wall, x_cav1]) translate([x, wall, back_t]) cube([in_wall, cav_h, Z_fr - back_t]);
      hull() { translate([x_cav0 - eps, wall, z_shelf - eps]) cube([shelf_w + eps, cav_h, eps]);
               translate([x_cav0 - eps, wall, z_shelf - shelf_w]) cube([eps, cav_h, eps]); }
      hull() { translate([x_cav1 - shelf_w, wall, z_shelf - eps]) cube([shelf_w + eps, cav_h, eps]);
               translate([x_cav1, wall, z_shelf - shelf_w]) cube([eps, cav_h, eps]); }
      // полки по длинным краям панели (сегменты)
      for (s = shelf_segs) { shelf(x_cav0 + clr + s[0], s[1], wall, +1); shelf(x_cav0 + clr + s[0], s[1], H - wall, -1); }
      // бобышки под вставки M3 — в каналах, слиты с бортами
      for (p = boss_pts) translate([p[0], p[1], back_t - eps]) cylinder(d=ch_w + 0.4, h=Z_fr - back_t + eps);   // +0.4: врезка в стенки канала
      // стойки Raspberry Pi
      for (p = pi_holes) translate([p[0], p[1], back_t - eps]) cylinder(d=pi_standoff_d, h=pi_standoff_h + eps);
      // держатели модулей
      translate([dcdc_pos[0], dcdc_pos[1], back_t - eps]) rotate([0,0,dcdc_rot]) card_holder(dcdc_l, dcdc_w, dcdc_pcb_t);
      translate([rs_pos[0],   rs_pos[1],   back_t - eps]) rotate([0,0,rs_rot])   card_holder(rs_l,   rs_w,   rs_pcb_t);
    }
    // отверстия под вставки
    for (p = boss_pts) translate([p[0], p[1], Z_fr - insert_depth]) cylinder(d=insert_d, h=insert_depth + 1);
    // саморезы Pi
    for (p = pi_holes) translate([p[0], p[1], back_t + 0.6]) cylinder(d=pi_screw_d, h=pi_standoff_h);
    // разъёмы нижнего борта
    translate([xt_x, 0, conn_z]) xt60_cut();
    translate([bnc_x, 0, conn_z]) bnc_cut();
    translate([rj_x, 0, conn_z]) rj45_cut();
    // окно портов Pi в нижнем борту (опция) либо вентиляция под кабельной зоной Pi
    if (pi_ports_window) pi_port_window();
    else translate([0, wall - 1, 0]) slot_row(pi_x0 + 2, pi_x0 + pi_w - 2, back_t + 4, back_t + 18);
    // вентиляция: верхний борт
    translate([0, H - wall - 1, 0]) slot_row(x_cav0 + 10, x_cav1 - 10, back_t + 4, back_t + 18);
    // вентиляция: задняя стенка — под процессором Pi и рядом с DC-DC
    for (i=[0:5]) back_slot(pi_x0 + 8 + i*6, pi_y0 + pi_l - 40, 22);
    for (i=[0:4]) back_slot(dcdc_pos[0] + dcdc_l/2 + 8 + i*6, dcdc_pos[1], 20);
    for (i=[0:2]) back_slot(dcdc_pos[0] - dcdc_l/2 - 8 - i*6, dcdc_pos[1], 20);
    // VESA
    if (vesa > 0) for (sx=[-1,1], sy=[-1,1]) translate([W/2 + sx*vesa/2, H/2 + sy*vesa/2, -1]) cylinder(d=vesa_screw_d, h=back_t + 2);
  }
}

// --- вырезы под разъёмы (локально: X вдоль борта, Z глубина, вырез вдоль Y)
module xt60_cut() {
  l = xt_body_l + 2*xt_cut_clr; w = xt_body_w + 2*xt_cut_clr; c = 1.5;
  rotate([-90, 0, 0]) translate([0, 0, -1]) {
    linear_extrude(wall + 2) polygon([[-l/2+c, -w/2], [l/2-c, -w/2], [l/2, -w/2+c], [l/2, w/2-c],
                                      [l/2-c, w/2], [-l/2+c, w/2], [-l/2, w/2-c], [-l/2, -w/2+c]]);
    for (s=[-1,1]) translate([s*xt_hole_pitch/2, 0, 0]) cylinder(d=xt_screw_d, h=wall + 2);
  }
}
module bnc_cut() {
  d = bnc_d + 2*bnc_clr;
  rotate([-90, 0, 0]) translate([0, 0, -1]) intersection() {
    cylinder(d=d, h=wall + 2);
    if (bnc_flat > 0) translate([-d, d/2 - (bnc_flat + bnc_clr), 0]) cube([2*d, 2*d, wall + 2]);
    else cylinder(d=d + 1, h=wall + 2);
  }
}
module rj45_cut() {
  rotate([-90, 0, 0]) translate([0, 0, -1]) linear_extrude(wall + 2)
    offset(r=1) offset(delta=-1) square([rj_w + 2*rj_clr, rj_h + 2*rj_clr], center=true);
}
module pi_port_window() {
  x0 = pi_x0 + pi_usb2_y - pi_usb_w/2 - 1.5;
  x1 = pi_x0 + pi_eth_y + pi_eth_w/2 + 1.5;
  z0 = back_t + pi_standoff_h - 1.0;
  z1 = back_t + pi_standoff_h + pi_pcb_t + pi_usb_h + 1.5;
  translate([x0, -1, z0]) cube([x1 - x0, wall + 2, z1 - z0]);
}

// Держатель платы-«карты»: две направляющие с пазом, торцевой упор, плата
// вдвигается с открытого конца (+X). Локально: длина по X, ширина по Y, Z вверх.
module card_holder(l, w, t) {
  rail = 2.5; grip = 1.5; gap = 0.35; z_low = 2.0; hh = z_low + t + gap + 2.0;
  for (s=[-1,1]) translate([0, s*(w/2 - grip + rail/2), 0]) difference() {
    translate([-l/2 - 2, -rail/2, 0]) cube([l + 4, rail, hh]);
    translate([-l/2 - 3, s > 0 ? -rail/2 - 1 : rail/2 - grip - gap/2, z_low]) cube([l + 6, grip + 1 + gap/2, t + gap]);
  }
  translate([-l/2 - 4, -w/2 - 1, 0]) cube([2, w + 2, hh]);           // торцевой упор
  translate([-l/2 - 4, -w/2 - 1, 0]) cube([l + 8, w + 2, 0.8]);      // основание
}

// =====================================================================
//  ЛИЦЕВАЯ РАМКА (в мировых координатах: Z_fr .. Z_fr + bezel_t)
// =====================================================================
module bezel_world() {
  difference() {
    translate([0, 0, Z_fr]) rbox(W, H, bezel_t, corner_r);
    // окно с фаской 45° наружу
    translate([x_cav0 + clr + mon_w/2 + view_dx, H/2 + view_dy, Z_fr]) hull() {
      translate([0, 0, -eps]) linear_extrude(eps) square([view_w, view_h], center=true);
      translate([0, 0, bezel_t]) linear_extrude(eps) offset(delta=bezel_t) square([view_w, view_h], center=true);
    }
    // винты M3 с потаем (потай снаружи)
    for (p = boss_pts) translate([p[0], p[1], Z_fr - 1]) {
      cylinder(d=bz_screw_d, h=bezel_t + 2);
      translate([0, 0, 1 + bezel_t - (bz_csk_d - bz_screw_d)/2]) cylinder(d1=bz_screw_d, d2=bz_csk_d + 0.2, h=(bz_csk_d - bz_screw_d)/2 + 0.1);
    }
  }
}

// =====================================================================
//  МАКЕТЫ КОМПОНЕНТОВ (сборка)
// =====================================================================
module ghost_monitor() {
  color([0.05,0.05,0.05,0.7]) translate([x_cav0 + clr, wall + clr, z_shelf]) cube([mon_w, mon_h, mon_t]);
  color([0.2,0.6,0.2,0.6]) translate([x_cav0 + mon_w/2 - 45, wall + clr + 8, z_shelf - drv_zone + 2]) cube([90, 40, drv_zone - 2]);
}
module ghost_pi() {
  z_pcb = back_t + pi_standoff_h;
  color([0,0.5,0.2,0.8]) translate([pi_x0, pi_y0, z_pcb]) cube([pi_w, pi_l, pi_pcb_t]);
  color([0.8,0.8,0.8,0.8]) {
    for (x=[pi_usb2_y, pi_usb3_y]) translate([pi_x0 + x - pi_usb_w/2, pi_y0 - pi_port_overhang, z_pcb + pi_pcb_t]) cube([pi_usb_w, 17.4, pi_usb_h]);
    translate([pi_x0 + pi_eth_y - pi_eth_w/2, pi_y0 - pi_port_overhang, z_pcb + pi_pcb_t]) cube([pi_eth_w, 21.4, pi_eth_h]);
  }
}
module ghost_cards() {
  color([0.2,0.2,0.7,0.8]) translate([dcdc_pos[0], dcdc_pos[1], back_t + 2.0]) rotate([0,0,dcdc_rot]) translate([-dcdc_l/2, -dcdc_w/2, 0]) cube([dcdc_l, dcdc_w, dcdc_pcb_t + dcdc_comp_h]);
  color([0.2,0.2,0.7,0.8]) translate([rs_pos[0], rs_pos[1], back_t + 2.0]) rotate([0,0,rs_rot]) translate([-rs_l/2, -rs_w/2, 0]) cube([rs_l, rs_w, rs_pcb_t + rs_comp_h]);
}

// =====================================================================
//  ВЫВОД
// =====================================================================
section_y = -1;   // >= 0: показать разрез плоскостью Y = section_y (только для просмотра)

module output() {
  if (part == "box")   box();
  if (part == "bezel") translate([0, H, Z_fr + bezel_t]) rotate([180, 0, 0]) bezel_world();   // лицом на стол
  if (part == "assembly") { box(); color([0.85,0.85,0.85,0.3]) bezel_world(); ghost_monitor(); ghost_pi(); ghost_cards(); }
}
if (section_y >= 0) intersection() { output(); translate([-1, section_y, -1]) cube([W + 2, H + 2, 200]); }
else output();
