import os
DOCS=os.path.join(os.path.dirname(os.path.abspath(__file__)),"..","..","docs")
o=[]
def rect(x,y,w,h,fill,st="#2c3e50",sw=1.5,rx=4,dash=None,op=1):
    d=f' stroke-dasharray="{dash}"' if dash else ''
    o.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" fill-opacity="{op}" stroke="{st}" stroke-width="{sw}"{d}/>')
def t(x,y,s,size=14,f="#111",anc="start",w="normal",rot=None):
    tr=f' transform="rotate({rot} {x} {y})"' if rot else ''
    o.append(f'<text x="{x}" y="{y}" font-size="{size}" fill="{f}" text-anchor="{anc}" font-weight="{w}"{tr}>{s}</text>')
def line(pts,col,w=2,dash=None):
    d=f' stroke-dasharray="{dash}"' if dash else ''
    p=" ".join(f"{x},{y}" for x,y in pts)
    o.append(f'<polyline points="{p}" fill="none" stroke="{col}" stroke-width="{w}" stroke-linejoin="round" stroke-linecap="round"{d}/>')
def circ(x,y,r,fill,st="#111",sw=1.5): o.append(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{st}" stroke-width="{sw}"/>')
def num(x,y,n):
    circ(x,y,12,"#d84315","#fff",2); t(x,y+5,str(n),13,"#fff","middle","bold")
def dim_h(x1,x2,y,label):
    line([(x1,y),(x2,y)],"#546e7a",1.2); line([(x1,y-6),(x1,y+6)],"#546e7a",1.2); line([(x2,y-6),(x2,y+6)],"#546e7a",1.2)
    rect((x1+x2)/2-70,y-11,140,20,"#fff","none",0); t((x1+x2)/2,y+5,label,13,"#37474f","middle","bold")
def dim_v(x,y1,y2,label):
    line([(x,y1),(x,y2)],"#546e7a",1.2); line([(x-6,y1),(x+6,y1)],"#546e7a",1.2); line([(x-6,y2),(x+6,y2)],"#546e7a",1.2)
    t(x-8,(y1+y2)/2,label,13,"#37474f","middle","bold",rot=-90)

W,H=1540,1120
t(40,46,"SPRUT в кейсе Mavic 3T — как я это вижу",30,"#111",w="bold")
t(40,78,"Нижняя половина: панель управления вровень с краем. Крышка: аналоговый монитор. Размеры кейса оценочные — уточнить замером.",16,"#555")

# ================= ВИД СВЕРХУ =================
S=2.0; X0,Y0=80,235          # мм -> px
def P(x,y): return X0+x*S, Y0+y*S
IW,IH=390,290
t(X0-20,128,"Вид сверху: крышка открыта, смотрим на нижнюю половину",17,"#263238",w="bold")
# кейс снаружи
rect(X0-26,Y0-26,IW*S+52,IH*S+52,"#37474f","#212121",2,rx=22)
for hx in (70,320):   # петли
    rect(*P(hx-20,-20),80,14,"#263238","#111",1,rx=3)
for lx in (60,330):   # замки
    rect(*P(lx-14,IH+3),56,26,"#263238","#111",1,rx=4)
rect(*P(150,IH+8),180,22,"#212121","#111",1,rx=10); t(P(195,0)[0],P(0,IH+19)[1]+4,"ручка",12,"#b0bec5","middle")
t(P(195,0)[0],Y0-45,"петли крышки (сзади)",12,"#b0bec5","middle")
# панель
rect(*P(0,0),IW*S,IH*S,"#eceff1","#90a4ae",2,rx=10)
# шов
SEAM=276
line([P(SEAM,2),P(SEAM,IH-2)],"#78909c",2,"10 6")
# экран-модуль
rect(*P(12,14),258*S,166*S,"#263238","#111",2,rx=8)
ax,ay=12+(258-222.7)/2,14+(166-125.3)/2-3
o.append(f'<defs><linearGradient id="scr" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#4fc3f7"/><stop offset="1" stop-color="#1565c0"/></linearGradient></defs>')
rect(*P(ax,ay),222.7*S,125.3*S,"url(#scr)","#0d47a1",1.5,rx=2)
t(P(95,0)[0],P(0,ay+50)[1],"Тачскрин 10.1″",22,"#fff","middle","bold")
t(P(95,0)[0],P(0,ay+63)[1],"интерфейс управления",15,"#e3f2fd","middle")
# под панелью — пунктир
rect(*P(176,44),85*S,56*S,"#2e7d32","#1b5e20",2,dash="7 5",op=0.18); t(P(218,0)[0],P(0,76)[1],"Pi 4B (под панелью)",12,"#1b5e20","middle","bold")
rect(*P(30,110),36*S,62*S,"#283593","#1a237e",2,dash="7 5",op=0.15); t(P(48,0)[0],P(0,145)[1],"DC-DC",11,"#1a237e","middle","bold")
rect(*P(74,118),26*S,46*S,"#283593","#1a237e",2,dash="7 5",op=0.15); t(P(87,0)[0],P(0,145)[1],"RS485",11,"#1a237e","middle","bold")
# правая полоса: разъёмы
cx=333
rect(*P(cx-17,20),34*S,17*S,"#f9a825","#e65100",1.5,rx=3); t(*P(cx,32),"XT60",12,"#3e2723","middle","bold")
t(*P(cx,47),"питание",11,"#455a64","middle")
circ(*P(cx,66),11*S,"#bdbdbd","#424242",2); circ(*P(cx,66),4*S,"#fafafa","#424242",1.5)
t(*P(cx,87),"BNC",12,"#263238","middle","bold")
rect(*P(cx-9,98),18*S,15*S,"#cfd8dc","#37474f",1.5,rx=2); rect(*P(cx-5,107),10*S,6*S,"#455a64","#37474f",1,rx=1)
t(*P(cx,124),"RJ45 · RS485",11,"#263238","middle","bold")
rect(*P(cx-12,134),24*S,12*S,"#212121","#000",1.5,rx=3); rect(*P(cx-10,136),10*S,8*S,"#e53935","#000",1,rx=2)
t(*P(cx,157),"выключатель",11,"#263238","middle")
for i in range(9): rect(*P(cx-32,172+i*9),64*S,4*S,"#90a4ae","#78909c",1,rx=3)
t(*P(cx,262),"вентиляция",11,"#455a64","middle")
t(*P(cx,272),"(вентилятор 5 В снизу)",10,"#455a64","middle")
# передняя полоса: ниша
rect(*P(22,196),170*S,80*S,"#cfd8dc","#78909c",2,rx=8)
t(*P(107,232),"ниша под кабели",14,"#37474f","middle","bold")
t(*P(107,248),"патч-корд, шнур питания, переходники",11,"#455a64","middle")
rect(*P(205,214),60*S,44*S,"#e0e0e0","#9e9e9e",1.5,rx=6); t(*P(235,234),"шильдик",11,"#616161","middle"); t(*P(235,247),"SPRUT",13,"#424242","middle","bold")
for fx in (4,IW-14):  # выемки под пальцы
    rect(*P(fx,120),10*S,40*S,"#b0bec5","#78909c",1.2,rx=8)
# номера
num(*P(20,22),1); num(*P(cx+24,20),2); num(*P(cx+24,58),3); num(*P(cx+24,100),4); num(*P(cx+24,134),5); num(*P(cx+36,180),6)
num(*P(30,204),7); num(*P(9,108),8); num(*P(SEAM,8),9)
# размеры
dim_h(*[P(0,0)[0],P(IW,0)[0]],Y0-72,"≈390 мм внутри*")
dim_v(X0-44,P(0,0)[1],P(0,IH)[1],"≈290 мм*")
# легенда под видом сверху
items=[("1","Тачскрин 10.1″ в рамке, стекло вровень с панелью"),("2","XT60 — вход питания 7–60 В"),("3","BNC"),
       ("4","RJ45 — линия RS485"),("5","Выключатель питания (по желанию)"),("6","Решётка, под ней вентилятор 5 В"),
       ("7","Ниша под кабели"),("8","Выемки под пальцы: панель вынимается целиком"),("9","Шов: панель из двух частей (стол 350×350)")]
ly=Y0+IH*S+70
for i,(n,s) in enumerate(items):
    c,r=i%2,i//2; x=50+c*440; y=ly+r*32
    num(x+12,y,int(n)); t(x+32,y+5,s,14,"#263238")
t(50,ly+170,"Пунктир — то, что висит на нижней стороне панели: Pi, DC-DC, RS485.",14,"#455a64"); t(50,ly+192,"Вся станция — один блок, вынимается из кейса целиком.",14,"#455a64")

# ================= РАЗРЕЗ =================
s2=1.5; FX,BY=965,830       # перед кейса (x), низ (y)
BD,LD,DW=110,50,290          # глубина низа, крышки, длина спереди-назад
def Q(y,z): return FX+y*s2, BY-z*s2   # y: от переда, z: вверх от дна
t(FX-15,128,"Разрез спереди назад",17,"#263238",w="bold")
# корпус низа
bx,by=Q(0,BD); rect(bx-6,by,DW*s2+12,BD*s2+6,"none","#37474f",6,rx=10)
rect(bx,by,DW*s2,BD*s2,"#fafafa","none",0,rx=6)
# крышка (открыта ~100°, стоит вертикально)
hx,hy=Q(DW,BD)
rect(hx-LD*s2-6,hy-DW*s2-6,LD*s2+12,DW*s2+6,"#fafafa","#37474f",6,rx=10)
t(hx+22,hy-DW*s2/2,"крышка открыта ~100°",13,"#455a64","middle",rot=90)
# поролон-яйца в крышке
for i in range(14):
    yy=hy-DW*s2+10+i*30
    o.append(f'<path d="M{hx-2},{yy} q-12,7 0,15 q-12,7 0,15" fill="none" stroke="#9e9e9e" stroke-width="1.5"/>')
# аналоговый монитор
mx0=hx-LD*s2+2
rect(mx0,hy-DW*s2+70,38,190,"#37474f","#111",2,rx=4); rect(mx0,hy-DW*s2+78,6,174,"#64b5f6","#1565c0",1,rx=1)
rect(mx0+38,hy-DW*s2+60,8,210,"#bcaaa4","#6d4c41",1.2,rx=2)
t(mx0-14,hy-DW*s2+165,"аналоговый монитор",14,"#263238","middle","bold",rot=-90)
# кабель монитора с петлёй
line([(mx0+20,hy-DW*s2+260),(mx0+20,hy-40),(mx0+10,hy-18),(mx0+34,hy-4),(hx-14,hy+2),(hx-14,hy+30)],"#6a1b9a",3)
t(mx0-18,hy-60,"петля кабеля",12,"#6a1b9a","end","bold"); t(mx0-18,hy-46,"у петель",12,"#6a1b9a","end","bold")
# панель
px0,py0=Q(1,BD); rect(px0,py0,(DW-2)*s2,6,"#90a4ae","#546e7a",1.5,rx=1)
# экран в панели (14..180 мм от задней стенки)
sx0=Q(DW-180,0)[0]; sx1=Q(DW-14,0)[0]
rect(sx0,py0,sx1-sx0,26,"#263238","#111",1.5,rx=2); rect(sx0+8,py0,sx1-sx0-16,3,"#4fc3f7","#0288d1",0.8,rx=0)
t((sx0+sx1)/2,py0-10,"тачскрин",13,"#0d47a1","middle","bold")
# ниша спереди
nx0=Q(DW-276,0)[0]; nx1=Q(DW-196,0)[0]
rect(nx0,py0,nx1-nx0,62,"#cfd8dc","#78909c",1.5,rx=4); t((nx0+nx1)/2,py0-10,"ниша",13,"#37474f","middle","bold")
# Pi и платы под панелью
pix0=Q(DW-100,0)[0]
for x in (pix0+8,pix0+112): line([(x,py0+26),(x,py0+48)],"#616161",3)
rect(pix0,py0+48,128,9,"#2e7d32","#1b5e20",1.5,rx=1); rect(pix0+20,py0+57,30,14,"#cfd8dc","#455a64",1,rx=1); rect(pix0+70,py0+57,30,14,"#cfd8dc","#455a64",1,rx=1)
t(pix0+64,py0+92,"Pi 4B",13,"#1b5e20","middle","bold")
dx0=nx1+20
rect(dx0,py0+6,14,58,"#283593","#1a237e",1.2,rx=1); rect(dx0+24,py0+6,14,44,"#283593","#1a237e",1.2,rx=1)
t(dx0+20,py0+82,"DC-DC, RS485",12,"#1a237e","middle","bold")
# рама до дна
for y in (6,DW-6):
    x=Q(y,0)[0]; rect(x-5,py0+6,10,BD*s2-12,"#b0bec5","#78909c",1.2,rx=2)
t(*Q(140,22),"свободно ~60 мм: АКБ, запас кабеля",13,"#78909c","middle")
t(Q(6,0)[0]+12,Q(0,40)[1],"рама",12,"#546e7a")
# оператор
t(FX-40,hy-DW*s2+120,"оператор",14,"#263238","middle","bold",rot=-90)
line([(FX-20,hy-DW*s2+165),(mx0-40,hy-DW*s2+165)],"#263238",2,"6 5"); o.append(f'<path d="M{mx0-40},{hy-DW*s2+159} l12,6 l-12,6 z" fill="#263238"/>')
line([(FX-20,hy-DW*s2+250),(sx0-10,py0-26)],"#263238",2,"6 5"); o.append(f'<path d="M{sx0-10},{py0-26} l-13,-4 l6,-9 z" fill="#263238"/>')
# размеры разреза
dim_v(Q(DW,0)[0]+40,Q(0,BD)[1],Q(0,0)[1],"≈110*")
dim_h(hx-LD*s2,hx,hy-DW*s2-28,"≈50*")
t(FX+5,BY+32,"перед (ручка)",12,"#546e7a"); t(Q(DW,0)[0],BY+32,"зад (петли)",12,"#546e7a","end")

# сноска
t(FX-20,BY+75,"* Оценка по фото и похожим кейсам. Замерить:",14,"#bf360c","start","bold")
for i,s in enumerate(["внутр. длина и ширина по краю и по дну","глубина низа и крышки","где выступают петли, замки, клапан","размер аналогового монитора"]):
    t(FX,BY+104+i*21,"— "+s,13,"#455a64")

svg=f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" font-family="DejaVu Sans, Arial, sans-serif"><rect width="{W}" height="{H}" fill="#fff"/>'+"".join(o)+'</svg>'
open(os.path.join(DOCS,"case_mavic3t_concept.svg"),"w").write(svg); print("ok")
