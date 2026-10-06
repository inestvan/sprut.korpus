import os
DOCS=os.path.join(os.path.dirname(os.path.abspath(__file__)),"..","..","docs")
# Схема 1: что куда встаёт (вид со стороны экрана, монитор и рамка сняты)
W,H,wall = 272.2,153.4,3.0
xc0, xc1 = 13.0, 252.2          # грани полости под монитор
sc = 5.0; ox, oy = 70, 150
def X(x): return ox + x*sc
def Y(y): return oy + (H-y)*sc
out=[]
def rect(x,y,w,h,fill,st="#2c3e50",sw=1.2,dash=None,op=1,rx=0):
    d=f' stroke-dasharray="{dash}"' if dash else ''
    out.append(f'<rect x="{X(x):.1f}" y="{Y(y+h):.1f}" width="{w*sc:.1f}" height="{h*sc:.1f}" rx="{rx}" fill="{fill}" stroke="{st}" stroke-width="{sw}"{d} opacity="{op}"/>')
def circ(x,y,r,fill,st="#455a64",sw=1.2,dash=None):
    d=f' stroke-dasharray="{dash}"' if dash else ''
    out.append(f'<circle cx="{X(x):.1f}" cy="{Y(y):.1f}" r="{r*sc:.1f}" fill="{fill}" stroke="{st}" stroke-width="{sw}"{d}/>')
def txt(x,y,t,s=14,f="#111",anc="middle",w="normal",rot=None,px=False):
    xx,yy=(x,y) if px else (X(x),Y(y))
    tr=f' transform="rotate({rot} {xx:.1f} {yy:.1f})"' if rot else ''
    out.append(f'<text x="{xx:.1f}" y="{yy:.1f}" font-size="{s}" fill="{f}" text-anchor="{anc}" font-weight="{w}"{tr}>{t}</text>')
def callout(n,x,y,bx,by,col="#c0392b"):
    # (x,y) точка на детали в мм, (bx,by) центр кружка в мм
    out.append(f'<line x1="{X(x):.1f}" y1="{Y(y):.1f}" x2="{X(bx):.1f}" y2="{Y(by):.1f}" stroke="{col}" stroke-width="2"/>')
    out.append(f'<circle cx="{X(x):.1f}" cy="{Y(y):.1f}" r="3.5" fill="{col}"/>')
    out.append(f'<circle cx="{X(bx):.1f}" cy="{Y(by):.1f}" r="17" fill="{col}" stroke="#fff" stroke-width="2.5"/>')
    out.append(f'<text x="{X(bx):.1f}" y="{Y(by)+6:.1f}" font-size="17" font-weight="bold" fill="#fff" text-anchor="middle">{n}</text>')

# --- корпус
rect(0,0,W,H,"#cfd8e3","#2c3e50",2,rx=5*sc)
rect(wall,wall,W-2*wall,H-2*wall,"#ffffff","#2c3e50",1.4)
for x0 in range(45,240,10): rect(x0,H-wall,3,wall,"#90a4ae","none",0)          # щели верхнего борта
rect(xc0-2,wall,2,H-2*wall,"#cfd8e3","#546e7a",1)                              # левая внутр. стенка
# --- отсек разъёмов монитора справа
rect(xc1,wall,W-wall-xc1,H-2*wall,"#eef8ef","#2e7d32",1.2,"6 4")
rect(xc1,9,2,75,"#fff8e1","#b8860b",1.6,"5 3")                                 # окно в стенке ниже полки
# --- бобышки M3
for x,ys in ((7,(7,76.7,146.4)),(265.2,(7,146.4))):
    for y in ys: circ(x,y,4.2,"#b0bec5"); circ(x,y,2,"#ffffff")
# --- контур монитора
rect(xc0+1,wall+1,237.2,145.4,"none","#7f8c8d",1.4,"10 6")
txt(60,146,"контур монитора — ложится сверху на полки",12,"#7f8c8d","start")
# --- кнопки монитора (на его задней панели)
for y,s in ((52,"−"),(70,"+"),(88,"⏻")): circ(23,y,3,"none","#9e9e9e",1.2,"3 2"); txt(23,y-1.4,s,12,"#757575")
# --- VESA
for x,y in ((70.1,26.7),(70.1,126.7),(170.1,26.7),(170.1,126.7)): circ(x,y,2.15,"#ffffff","#607d8b",1.5)
# --- зоны, которые нельзя занимать
rect(178.2,94.5,56,55.9,"#e8f5e9","#2e7d32",1.6,"7 5")
txt(206.2,128,"A",22,"#2e7d32",w="bold"); txt(206.2,120,"вилки USB / Ethernet",12,"#2e7d32"); txt(206.2,113,"55.9 мм",12,"#2e7d32")
rect(234.2,9,35,75,"#e8f5e9","#2e7d32",1.6,"7 5",op=0.85)
txt(244,72,"B",22,"#2e7d32",w="bold"); txt(244,64,"35 мм",12,"#2e7d32")
for y,col in ((29,"#f39c12"),(49,"#e74c3c"),(69,"#7f8c8d")): rect(251.2,y-3.5,4.5,7,col,"#5d4037",1.2)
txt(262.5,29,"Type-C",11,"#5d4037","middle",rot=-90); txt(262.5,49,"mini HDMI",11,"#5d4037","middle",rot=-90); txt(262.5,69,"наушн.",11,"#5d4037","middle",rot=-90)
txt(262.5,110,"разъёмы монитора",11,"#5d4037","middle",rot=-90)
rect(118.7,55,46.2,42,"#e8f5e9","#2e7d32",1.6,"7 5")
for x in (124.15,134.15,147.3,153.3,159.3): rect(x-1.1,60,2.2,26,"#eceff1","none",0)
txt(141.8,90.5,"C   сюда вдвигаются платы",13,"#2e7d32",w="bold")
# --- Raspberry Pi
px0,py0=178.2,7.0
rect(px0,py0,56,85,"#2e7d32","#1b5e20",1.6,rx=3*sc)
for x,y in ((181.7,10.5),(181.7,68.5),(230.7,10.5),(230.7,68.5)): circ(x,y,3.25,"#a5d6a7","#1b5e20",1); circ(x,y,1.2,"#1b5e20","none",0)
rect(179.4,14,4.8,51,"#212121","#000",1)                                       # GPIO 2x20
txt(186.5,40,"GPIO",11,"#e8f5e9","start",rot=-90)
txt(186.5,15.5,"пин 1",10,"#e8f5e9","start")
for y,lab,col in ((18.2,"USB-C","#f39c12"),(33,"µHDMI 0","#e74c3c"),(46.5,"µHDMI 1","#e74c3c"),(61,"аудио","#7f8c8d")):
    rect(231.7,y-3.5,4,7,col,"#333",1); txt(230.5,y-1.6,lab,11,"#ffffff","end")
for cx,w_,lab in ((225.2,13.1,"USB"),(207.2,13.1,"USB"),(188.45,16,"ETH")):
    rect(cx-w_/2,90,w_,4.5,"#cfd8dc","#37474f",1); txt(cx,97.5,lab,11,"#37474f")
rect(194,5.2,12,2.2,"#9e9e9e","#424242",0.8)                                   # microSD
txt(200,10,"microSD ↓",10,"#e8f5e9")
txt(206.2,80,"Raspberry Pi 4B",15,"#ffffff",w="bold")
# --- держатели
rect(141.6,4,23.3,49,"#c5cae9","#3949ab",1.2); rect(142.8,8,21,43,"#283593","#1a237e",1.2)
txt(153.3,47,"OUT",11,"#ffeb3b",w="bold"); txt(153.3,11,"IN",11,"#ffeb3b",w="bold")
txt(153.3,29,"DC-DC",13,"#ffffff",w="bold",rot=-90)
rect(118.7,4,21,40,"#c5cae9","#3949ab",1.2); rect(120.2,8,18,34,"#283593","#1a237e",1.2)
txt(129.2,38.5,"A B ⏚",10,"#ffeb3b",w="bold"); txt(129.2,11,"TTL",10,"#ffeb3b",w="bold")
txt(129.2,25,"RS485",13,"#ffffff",w="bold",rot=-90)
# --- панельные разъёмы нижнего борта и их тела внутри
rect(31-8.05,0,16.1,wall,"#ef6c00","#bf360c",1.2); rect(31-8.05,wall,16.1,13.5,"#ffe0b2","#e65100",1,"4 3")
rect(69-4.95,0,9.9,wall,"#ef6c00","#bf360c",1.2); rect(69-6,wall,12,17,"#ffe0b2","#e65100",1,"4 3")
rect(101-8.4,0,16.8,wall,"#ef6c00","#bf360c",1.2); rect(101-8,wall,16,21.6,"#ffe0b2","#e65100",1,"4 3")
for x,l in ((31,"XT60"),(69,"BNC"),(101,"RJ45")): txt(x,-6,l,14,"#bf360c",w="bold")
# --- выноски
callout(1,200,55,  171,76)
callout(2,158,34,  171.5,46)
callout(3,129.2,20, 108,62)
callout(4,31,10,    31,36)
callout(5,69,12,    58,40)
callout(6,101,14,   92,44)
callout(7,30,140,   30,118)
callout(8,256,49,   247,118)
callout(9,253.2,30, 244,100)
callout(10,7,76.7,  22,100)
callout(11,70.1,126.7, 86,110)
callout(12,23,70,   46,88)
# --- заголовок
out.insert(0,f'<text x="{ox}" y="48" font-size="30" font-weight="bold" fill="#111">Что куда встаёт</text>')
out.insert(1,f'<text x="{ox}" y="82" font-size="17" fill="#555">Вид со стороны экрана: монитор и лицевая рамка сняты, видна задняя стенка коробки. Корпус 272 x 153 x 59 мм.</text>')
out.insert(2,f'<text x="{ox}" y="108" font-size="17" fill="#555">Цифры — детали (расшифровка ниже), буквы A B C — зоны, которые должны остаться пустыми.</text>')
# --- легенда
items=[
 (1,"Raspberry Pi 4B","на 4 стойки, саморезы M2.5x6. USB и Ethernet смотрят вверх, micro-HDMI и USB-C — вправо, к отсеку монитора"),
 (2,"DC-DC 60V → 5V","вдвигается в паз сверху. IN внизу, OUT вверху. Провода припаять до установки, выставить 5.1 В"),
 (3,"RS485-TTL","вдвигается в паз сверху. Клеммы A / B вверху, пины TTL внизу. Провода к TTL припаять заранее"),
 (4,"XT60E-M — вход питания","вставить снаружи в нижний борт, 2 самореза M3x8. Внутри занимает 13.5 мм"),
 (5,"BNC","вставить снаружи в нижний борт, гайка с шайбой изнутри"),
 (6,"RJ45","гнездо на своей платке, прижать изнутри к окну в борту, закрепить термоклеем или планкой"),
 (7,"Монитор","экраном наружу, разъёмами вправо, на полки. По периметру вспененный скотч 0.5–1 мм"),
 (8,"Отсек 18 мм","здесь разъёмы монитора: Type-C, mini HDMI, наушники. Только угловые штекеры или плоские шлейфы"),
 (9,"Окно под кабели","ниже полки, через него кабели монитора уходят к Pi, а штекеры Pi — в отсек"),
 (10,"Бобышки M3, 5 шт","резьбовые вставки паяльником. Лицевая рамка — 5 потайных винтов M3x8"),
 (11,"VESA 100","4 отверстия M4 в задней стенке, если нужно крепление на кронштейн"),
 (12,"Кнопки монитора","сенсорные, на его задней панели. После сборки недоступны — яркость выставить заранее"),
 ("A","Зона вилок USB / Ethernet","55.9 мм над Pi — сюда заходят штекеры с кабелями"),
 ("B","Зона штекеров HDMI / USB-C Pi","35 мм от платы до наружного борта, сквозь окно в отсек"),
 ("C","Зона вдвигания плат","над держателями, иначе DC-DC и RS485 не вставить"),
]
y0 = Y(0)+60; colw=700; rowh=74
for i,(n,t,d) in enumerate(items):
    c=i%2; r=i//2; x=ox+c*colw; y=y0+r*rowh
    col="#2e7d32" if isinstance(n,str) else "#c0392b"
    out.append(f'<circle cx="{x+17}" cy="{y}" r="17" fill="{col}"/>')
    out.append(f'<text x="{x+17}" y="{y+6}" font-size="17" font-weight="bold" fill="#fff" text-anchor="middle">{n}</text>')
    out.append(f'<text x="{x+46}" y="{y-2}" font-size="17" font-weight="bold" fill="#111">{t}</text>')
    # перенос описания
    words=d.split(); lines=[""]
    for wd in words:
        if len(lines[-1])+len(wd)+1>72: lines.append(wd)
        else: lines[-1]=(lines[-1]+" "+wd).strip()
    for k,l in enumerate(lines): out.append(f'<text x="{x+46}" y="{y+20+k*19}" font-size="15" fill="#444">{l}</text>')
Wpx=ox*2+int(W*sc)+40; Hpx=int(y0+((len(items)+1)//2)*rowh+20)
svg=(f'<svg xmlns="http://www.w3.org/2000/svg" width="{Wpx}" height="{Hpx}" viewBox="0 0 {Wpx} {Hpx}" font-family="Arial, Liberation Sans, sans-serif">'
     f'<rect width="100%" height="100%" fill="#ffffff"/>'+"".join(out)+'</svg>')
open(os.path.join(DOCS,"scheme_placement.svg"),"w").write(svg); print("placement", Wpx, Hpx)
