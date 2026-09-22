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
drv_zone = 12.0;   // свободная глубина за монитором под кабели
// Разъёмы монитора «10 inch portable display / Display-A» (по фото владельца и
// продавца, см. docs/components.md). Все на ПРАВОМ торце (вид спереди), по центру
// толщины. От НИЖНЕГО края монитора, точность ±3 мм:
//   Type-C (питание + тач) 25, mini HDMI 45, гнездо наушников 65.
// Сзади на панели сенсорные кнопки питание / + / − (в корпусе недоступны).
// Со стороны разъёмов вместо узкого канала — отсек шириной bay_w под угловые
// штекеры; на уровне монитора там нет стенки; ниже полки в стенке окно под кабели.
mon_conn_side = "right";    // "left" | "right" — сторона разъёмов, вид спереди
mon_conn_y    = [12, 80];   // окно под кабели в стенке ниже полки (от нижнего края монитора)
mon_hdmi_y    = 45;         // центр mini HDMI (макет)
mon_usbc_y    = 25;         // центр Type-C (макет)
mon_jack_y    = 65;         // гнездо наушников 3.5 мм (макет, не используется)
mon_wheel_y   = 0;          // у этого варианта колёсика нет
mon_conn_z    = 7.0;        // ось разъёмов от лицевого стекла (середина толщины)
wheel_slot    = false;      // прорезь под колёсико — у этого монитора не нужна
wheel_slot_l  = 22;
wheel_slot_h  = 8;
bay_w         = 18.0;       // от торца монитора до внутренней грани наружного борта
plug_len      = 13.0;       // выступ углового штекера от торца монитора (макет)
// полки под длинные края панели: сегменты [x_start, длина] от левого края панели
shelf_segs = [[0, 30], [mon_w/2 - 15, 30], [mon_w - 30, 30]];

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — Raspberry Pi 4B (официальный чертёж, datasheet rev 1.1)
// Pi лежит на задней стенке, компонентами к экрану, торцом USB/ETH к
// нижнему борту. Плата ПОЛНОСТЬЮ ВНУТРИ корпуса: наружу её порты не выходят,
// всё втыкается изнутри. Поэтому плата отодвинута вплотную к ВЕРХНЕМУ борту
// (со стороны microSD), а перед разъёмами USB/Ethernet освобождена вся
// оставшаяся высота полости — туда заходят вилки с кабелями.
// ---------------------------------------------------------------------
pi_l = 85.0;  pi_w = 56.0;  pi_pcb_t = 1.6;
pi_hole_dx = 58.0; pi_hole_dy = 49.0; pi_hole_off = 3.5;
pi_standoff_h = 6.0;  pi_standoff_d = 6.5;
pi_screw_d    = 2.2;   // саморез M2.5 в PETG (2.0 — под метчик M2.5)
pi_usb2_y = 9.0;  pi_usb3_y = 27.0;  pi_eth_y = 45.75;   // центры по короткой стороне
pi_usb_w  = 13.1; pi_usb_h = 16.0;   pi_eth_w = 16.0; pi_eth_h = 13.5;
pi_port_overhang = 2.5;   // выступ USB/ETH за край платы
pi_ports_window = false;  // true: порты Pi наружу через окно в борту; false: Pi полностью внутри
pi_far_gap  = 1.5;        // дальний край платы (microSD) до верхнего борта
pi_win_clr  = 1.5;        // зазор окна вокруг разъёмов Pi (только при pi_ports_window)

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — DC-DC 60V/3A buck (CR-6030L). Габарит платы — ОЦЕНКА по фото
// и листингу (~4x2 см). Поправь после замера.
// ---------------------------------------------------------------------
dcdc_l = 43.0;  dcdc_w = 21.0;  dcdc_pcb_t = 1.6;  dcdc_comp_h = 13.0;

// ---------------------------------------------------------------------
// ПАРАМЕТРЫ — RS485-TTL модуль (по фото продавца 34 x 18 x 9)
// ---------------------------------------------------------------------
rs_l = 34.0;  rs_w = 18.0;  rs_pcb_t = 1.6;  rs_comp_h = 8.0;

// Зазоры в держателях плат, отдельно для каждого.
// DC-DC оставлен как в первой версии — плата села хорошо, не трогать.
dcdc_gap_w = 0.35;  dcdc_gap_t = 0.35;  dcdc_lead = 0.0;
// RS485 входил туго, паз расширен и добавлена заходная фаска.
rs_gap_w   = 0.9;   rs_gap_t   = 0.40;  rs_lead   = 4.0;

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
bezel_rib_h = 2.5;     // ребро рамки, фиксирующее монитор по X со стороны отсека
vesa = 100;            // 0 = без VESA; 75 или 100
vesa_screw_d = 4.3;    // M4

// ---------------------------------------------------------------------
// ПРОИЗВОДНЫЕ РАЗМЕРЫ
// ---------------------------------------------------------------------
side_ch = ch_w + in_wall;              // обычный боковой канал + внутренняя стенка
side_bay = bay_w - clr;                // отсек под штекеры (монитор на clr от внутр. стенки)
side_l = (mon_conn_side == "left")  ? side_bay : side_ch;
side_r = (mon_conn_side == "right") ? side_bay : side_ch;
cav_w = mon_w + 2*clr;                 // полость под монитор (между внутр. стенками)
cav_h = mon_h + 2*clr;
W = cav_w + side_l + side_r + 2*wall;  // наружная ширина
H = cav_h + 2*wall;                    // наружная высота
pi_stack = pi_standoff_h + pi_pcb_t + pi_usb_h;                 // 23.6
D_in  = ceil(pi_stack + 2.0 + drv_zone + mon_t + 0.3);            // внутренняя глубина
Z_fr  = back_t + D_in;                 // плоскость прилегания рамки (верх бортов)
z_shelf = Z_fr - (mon_t + 0.3);        // плоскость полок под панель
D_total = Z_fr + bezel_t;
x_cav0 = wall + side_l;                // левая внутренняя стенка (грань полости)
x_cav1 = W - wall - side_r;
// верх внутренней стенки канала: со стороны отсека разъёмов — по плоскость полки
wall_top_l = (mon_conn_side == "left")  ? z_shelf : Z_fr;
wall_top_r = (mon_conn_side == "right") ? z_shelf : Z_fr;
// окно под кабели во внутренней стенке со стороны разъёмов (мировые Y)
conn_y0 = wall + clr + mon_conn_y[0];
conn_y1 = wall + clr + mon_conn_y[1];

echo(str("НАРУЖНЫЙ ГАБАРИТ: ", W, " x ", H, " x ", D_total, " мм (ШxВxГ), рамка ", bezel_t, " мм"));
echo(str("Полость под монитор: ", cav_w, " x ", cav_h, ", глубина коробки ", D_in));
echo(str("Pi ", pi_at_left ? "СЛЕВА, порты к верхнему борту" : "СПРАВА, порты к нижнему борту",
         "; окно в борту: ", pi_ports_window ? "ДА" : "нет",
         "; свободно перед разъёмами USB/ETH: ", pi_edge_gap - pi_port_overhang, " мм"));
echo(str("Держатели: просвет паза DC-DC ", dcdc_w + dcdc_gap_w, " x ", dcdc_pcb_t + dcdc_gap_t,
         ", RS485 ", rs_w + rs_gap_w, " x ", rs_pcb_t + rs_gap_t,
         "; центры DC-DC ", dcdc_pos, " RS485 ", rs_pos, " поворот ", dcdc_rot));
echo(str("Отсек разъёмов: свободно от торца монитора ", bay_w, " мм на высоту ", Z_fr - z_shelf, " мм"));

// бобышки: по 3 в каждом боковом канале
// Бобышки. Со стороны отсека разъёмов — только по углам, чтобы вдоль торца
// монитора ничто не мешало угловому штекеру. Промежуточные можно добавить
// в bay_boss_extra, когда будут известны координаты разъёмов монитора.
bay_boss_extra = [];                 // напр. [76.7]
boss_ys_ch  = [wall + ch_w/2, H/2, H - wall - ch_w/2];
boss_ys_bay = concat([wall + ch_w/2], bay_boss_extra, [H - wall - ch_w/2]);
boss_pts = concat(
  [for (y = (mon_conn_side == "left")  ? boss_ys_bay : boss_ys_ch) [wall + ch_w/2, y]],
  [for (y = (mon_conn_side == "right") ? boss_ys_bay : boss_ys_ch) [W - wall - ch_w/2, y]]);

// Raspberry Pi стоит у стороны, ПРОТИВОПОЛОЖНОЙ отсеку разъёмов монитора,
// так её длинный торец с USB-C/micro-HDMI/аудио всегда смотрит внутрь корпуса.
//   отсек слева  -> Pi справа, торец USB/ETH к нижнему борту (pi_rot = 0):
//                   мир_x = pi_x0 + py, мир_y = pi_y0 + (85 - px)
//   отсек справа -> Pi слева, торец USB/ETH к ВЕРХНЕМУ борту (pi_rot = 180):
//                   мир_x = pi_x0 + (56 - py), мир_y = pi_y0 + px
pi_at_left = (mon_conn_side == "right");
pi_rot = pi_at_left ? 180 : 0;
pi_x0 = pi_at_left ? x_cav0 + 2.0 : x_cav1 - 2.0 - pi_w;
// зазор перед разъёмами USB/ETH: вся высота полости, что осталась от платы
pi_edge_gap = pi_ports_window ? 1.0 : (cav_h - pi_l - pi_far_gap);
pi_y0 = pi_at_left ? wall + pi_far_gap : wall + pi_edge_gap;
function pi_pt(px, py) = (pi_rot == 0) ? [pi_x0 + py, pi_y0 + pi_l - px] : [pi_x0 + pi_w - py, pi_y0 + px];
pi_holes = [for (px=[pi_hole_off, pi_hole_off + pi_hole_dx], py=[pi_hole_off, pi_hole_off + pi_hole_dy]) pi_pt(px, py)];
pi_ports_y = (pi_rot == 0) ? pi_y0 - pi_port_overhang : pi_y0 + pi_l + pi_port_overhang;   // плоскость торцов USB/ETH

// разъёмы на нижнем борту: X центра, Z центра. При Pi слева сдвинуты правее,
// чтобы их тела внутри корпуса не попадали под плату Pi.
conn_z = back_t + 12.0;
conn_x0 = pi_at_left ? x_cav0 + 75.0 : x_cav0 + 18.0;
xt_x  = conn_x0;
bnc_x = conn_x0 + 38.0;
rj_x  = conn_x0 + 70.0;

// Держатели модулей на задней стенке (центр платы, поворот паза).
// При Pi слева оба стоят компактным блоком в правом нижнем углу, вплотную к
// нижнему борту, длинной стороной вдоль Y: платы вдвигаются СВЕРХУ (с +Y).
// Рядом вход питания XT60 и Type-C монитора в отсеке — короткие провода.
hold_gap   = 2.0;                                   // зазор между основаниями держателей
dcdc_hw    = (dcdc_w + dcdc_gap_w)/2 + 1.0;         // полуширина основания DC-DC
rs_hw      = (rs_w   + rs_gap_w)/2   + 1.0;         // полуширина основания RS485
dcdc_pos = pi_at_left ? [x_cav1 - 11.0 - dcdc_hw,                       wall + 1.0 + dcdc_l/2 + 4.0]
                      : [x_cav0 + 50.0, 46.0];
dcdc_rot = pi_at_left ? 90 : 0;
rs_pos   = pi_at_left ? [dcdc_pos[0] - dcdc_hw - hold_gap - rs_hw,      wall + 1.0 + rs_l/2 + 4.0]
                      : [x_cav0 + 50.0, 84.0];
rs_rot   = pi_at_left ? 90 : 0;

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
      // Внутренние стенки боковых каналов + полка с фаской.
      // Со стороны отсека разъёмов стенка поднимается ТОЛЬКО до плоскости полки:
      // выше неё пусто, и угловой штекер проходит вдоль всего торца монитора.
      // По X монитор с этой стороны держит ребро на лицевой рамке.
      translate([x_cav0 - in_wall, wall, back_t]) cube([in_wall, cav_h, wall_top_l - back_t]);
      translate([x_cav1,           wall, back_t]) cube([in_wall, cav_h, wall_top_r - back_t]);
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
      translate([dcdc_pos[0], dcdc_pos[1], back_t - eps]) rotate([0,0,dcdc_rot]) card_holder(dcdc_l, dcdc_w, dcdc_pcb_t, dcdc_gap_w, dcdc_gap_t, dcdc_lead);
      translate([rs_pos[0],   rs_pos[1],   back_t - eps]) rotate([0,0,rs_rot])   card_holder(rs_l,   rs_w,   rs_pcb_t,   rs_gap_w,   rs_gap_t,   rs_lead);
    }
    // окно во внутренней стенке и полке со стороны разъёмов: кабели из отсека к Pi
    conn_x = (mon_conn_side == "left") ? x_cav0 - in_wall - 1 : x_cav1 - shelf_w - 1;
    translate([conn_x, conn_y0, back_t]) cube([in_wall + shelf_w + 2, conn_y1 - conn_y0, Z_fr - back_t + 1]);
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
    for (i=[0:5]) back_slot(pi_x0 + 8 + i*6, pi_y0 + pi_l/2, 22);
    if (pi_at_left) { for (i=[0:2]) back_slot(rs_pos[0] - rs_hw - 14 - i*6, 30, 44); }   // слева от блока держателей
    else { for (i=[0:4]) back_slot(dcdc_pos[0] + dcdc_l/2 + 8 + i*6, dcdc_pos[1], 20);
           for (i=[0:2]) back_slot(dcdc_pos[0] - dcdc_l/2 - 8 - i*6, dcdc_pos[1], 20); }
    // прорезь под колёсико меню монитора в наружном борту со стороны отсека
    if (wheel_slot) {
      wx = (mon_conn_side == "left") ? -1 : W - wall - 1;
      wz = z_shelf + mon_t - mon_conn_z;
      translate([wx, wall + clr + mon_wheel_y, wz]) rotate([0, 90, 0]) linear_extrude(wall + 2)
        hull() for (s=[-1,1]) translate([0, s*(wheel_slot_l - wheel_slot_h)/2]) circle(d=wheel_slot_h);
    }
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
  xa = pi_pt(pi_l, pi_usb2_y - pi_usb_w/2)[0]; xb = pi_pt(pi_l, pi_eth_y + pi_eth_w/2)[0];
  x0 = min(xa, xb) - pi_win_clr; x1 = max(xa, xb) + pi_win_clr;
  z0 = back_t + pi_standoff_h - 1.0;
  z1 = back_t + pi_standoff_h + pi_pcb_t + pi_usb_h + pi_win_clr;
  yw = (pi_rot == 0) ? -1 : H - wall - 1;
  translate([x0, yw, z0]) cube([x1 - x0, wall + 2, z1 - z0]);
}

// Держатель платы-«карты»: две направляющие с пазом, торцевой упор, плата
// вдвигается с открытого конца (+X). Локально: длина по X, ширина по Y, Z вверх.
module card_holder(l, w, t, gap_w, gap_t, lead) {
  rail = 2.5; grip = 1.5; z_low = 2.0;
  ch = t + gap_t;                   // высота паза
  yw = w + gap_w;                   // просвет паза по ширине (грани на ±yw/2)
  hh = z_low + ch + 2.0;
  x_end = l/2 + 2;                  // открытый конец, сюда вдвигается плата
  for (s=[-1,1]) translate([0, s*(yw/2 - grip + rail/2), 0]) difference() {
    translate([-l/2 - 2, -rail/2, 0]) cube([l + 4, rail, hh]);
    y0 = (s > 0) ? -rail/2 - 1 : rail/2 - grip;
    translate([-l/2 - 3, y0, z_low]) cube([l + 6, grip + 1, ch]);
    // заходная фаска: к открытому концу паз раскрывается по высоте
    if (lead > 0) hull() {
      translate([x_end - lead, y0, z_low]) cube([eps, grip + 1, ch]);
      translate([x_end - eps, y0, z_low - lead/4]) cube([eps, grip + 1, ch + lead/2]);
    }
  }
  translate([-l/2 - 4, -yw/2 - 1, 0]) cube([2, yw + 2, hh]);           // торцевой упор
  translate([-l/2 - 4, -yw/2 - 1, 0]) cube([l + 8, yw + 2, 0.8]);      // основание
}

// =====================================================================
//  ЛИЦЕВАЯ РАМКА (в мировых координатах: Z_fr .. Z_fr + bezel_t)
// =====================================================================
module bezel_world() {
  difference() {
    union() {
      translate([0, 0, Z_fr]) rbox(W, H, bezel_t, corner_r);
      // Ребро вдоль торца монитора со стороны отсека разъёмов: держит монитор
      // по X вместо убранной стенки. Опускается всего bezel_rib_h от плоскости
      // рамки, то есть остаётся выше штекера и ему не мешает.
      translate([(mon_conn_side == "left") ? x_cav0 - in_wall : x_cav1,
                 wall + 0.5, Z_fr - bezel_rib_h])
        cube([in_wall, cav_h - 1.0, bezel_rib_h + eps]);
    }
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
  ghost_plugs();
  color([0.2,0.6,0.2,0.6]) translate([x_cav0 + mon_w/2 - 45, wall + clr + 8, z_shelf - drv_zone + 2]) cube([90, 40, drv_zone - 2]);
}
// угловые штекеры HDMI и Type-C, торчат из бокового торца монитора в отсек
module ghost_plugs() {
  px = (mon_conn_side == "left") ? x_cav0 + clr - plug_len : x_cav0 + clr + mon_w;
  zc = z_shelf + mon_t - mon_conn_z;
  color([0.85,0.15,0.15,0.95]) translate([px, wall + clr + mon_hdmi_y - 7, zc - 3.5]) cube([plug_len, 14, 7]);
  color([0.95,0.55,0.1,0.95]) translate([px, wall + clr + mon_usbc_y - 6, zc - 3]) cube([plug_len, 12, 6]);
  color([0.5,0.5,0.5,0.8]) translate([(mon_conn_side == "left") ? px + plug_len - 2 : px, wall + clr + mon_jack_y, zc]) rotate([0, 90, 0]) cylinder(d=6, h=2);   // гнездо наушников
}
module ghost_pi() {
  z_pcb = back_t + pi_standoff_h;
  color([0,0.5,0.2,0.8]) translate([pi_x0, pi_y0, z_pcb]) cube([pi_w, pi_l, pi_pcb_t]);
  color([0.8,0.8,0.8,0.8]) for (c = [[pi_usb2_y, pi_usb_w, 17.4, pi_usb_h], [pi_usb3_y, pi_usb_w, 17.4, pi_usb_h], [pi_eth_y, pi_eth_w, 21.4, pi_eth_h]]) {
    xc = pi_pt(pi_l, c[0])[0];
    yb = (pi_rot == 0) ? pi_y0 - pi_port_overhang : pi_y0 + pi_l + pi_port_overhang - c[2];
    translate([xc - c[1]/2, yb, z_pcb + pi_pcb_t]) cube([c[1], c[2], c[3]]);
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
