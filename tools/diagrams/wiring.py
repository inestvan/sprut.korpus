import os
DOCS=os.path.join(os.path.dirname(os.path.abspath(__file__)),"..","..","docs")
o=[]
def rect(x,y,w,h,fill,st="#2c3e50",sw=1.5,rx=6,dash=None):
    d=f' stroke-dasharray="{dash}"' if dash else ''
    o.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{st}" stroke-width="{sw}"{d}/>')
def t(x,y,s,size=15,f="#111",anc="start",w="normal",rot=None):
    tr=f' transform="rotate({rot} {x} {y})"' if rot else ''
    o.append(f'<text x="{x}" y="{y}" font-size="{size}" fill="{f}" text-anchor="{anc}" font-weight="{w}"{tr}>{s}</text>')
def wire(pts,col,w=4,dash=None):
    d=f' stroke-dasharray="{dash}"' if dash else ''
    p=" ".join(f"{x},{y}" for x,y in pts)
    o.append(f'<polyline points="{p}" fill="none" stroke="{col}" stroke-width="{w}" stroke-linejoin="round" stroke-linecap="round"{d}/>')
def dot(x,y,col="#111",r=5): o.append(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{col}" stroke="#fff" stroke-width="1.5"/>')
def pad(x,y,label,col="#555",anc="start",dx=10):
    dot(x,y,col,6); t(x+(dx if anc=="start" else -dx),y+5,label,13,"#222",anc)

RED,BLK,ORG,PUR,GRN,TEAL,BLU,VIO,YEL="#e53935","#212121","#fb8c00","#8e24aa","#2e7d32","#00897b","#1e88e5","#6a1b9a","#f9a825"
t(40,46,"Как всё соединить",30,"#111",w="bold")
t(40,80,"Схема проводки. Блоки стоят так же, как в корпусе: вид со стороны экрана. Длины проводов — по месту.",17,"#555")
# корпус
rect(30,110,1480,700,"#fafafa","#90a4ae",2,rx=14)
o.append('<line x1="30" y1="760" x2="1510" y2="760" stroke="#90a4ae" stroke-width="2"/>'); t(1500,790,"нижний борт",13,"#78909c","end")
# --- XT60, BNC, RJ45 на нижнем борту
rect(100,700,130,90,"#ffe0b2","#e65100"); t(165,730,"XT60",17,"#bf360c","middle","bold"); t(165,750,"вход 7–60 В",12,"#bf360c","middle")
pad(130,705,"+",RED,"start",8); pad(200,705,"−",BLK,"start",8)
rect(300,710,110,80,"#ffe0b2","#e65100"); t(355,745,"BNC",17,"#bf360c","middle","bold"); t(355,765,"по назначению",12,"#bf360c","middle")
rect(470,700,130,90,"#ffe0b2","#e65100"); t(535,735,"RJ45",17,"#bf360c","middle","bold"); t(535,755,"линия RS485",12,"#bf360c","middle")
pad(500,705,"",BLK); pad(535,705,"",YEL); pad(570,705,"",YEL)
# --- RS485
rect(640,380,130,250,"#283593","#1a237e"); t(705,510,"RS485-TTL",16,"#fff","middle","bold",rot=-90)
pad(670,395,"",YEL); pad(705,395,"",YEL); pad(740,395,"",BLK)
for x,l in ((670,"A"),(705,"B"),(740,"⏚")): t(x,420,l,12,"#ffeb3b","middle","bold")
for x,c in ((655,PUR),(685,GRN),(715,TEAL),(745,BLK)): pad(x,615,"",c)
for x,l in ((655,"VCC"),(685,"TX"),(715,"RX"),(745,"GND")): t(x,598,l,11,"#ffeb3b","middle","bold")
# --- DC-DC
rect(820,330,140,300,"#283593","#1a237e"); t(890,500,"DC-DC 60V → 5V",16,"#fff","middle","bold",rot=-90)
pad(855,345,"",ORG); pad(925,345,"",BLK); t(855,372,"OUT+",11,"#ffeb3b","middle","bold"); t(925,372,"OUT−",11,"#ffeb3b","middle","bold")
t(890,398,"выставить 5.1 В",12,"#ffeb3b","middle","bold")
pad(855,615,"",RED); pad(925,615,"",BLK); t(855,598,"IN+",11,"#ffeb3b","middle","bold"); t(925,598,"IN−",11,"#ffeb3b","middle","bold")
# --- Raspberry Pi
rect(1010,190,300,470,"#2e7d32","#1b5e20",2,rx=12); t(1160,240,"Raspberry Pi 4B",20,"#fff","middle","bold")
for x,l in ((1050,"ETH"),(1150,"USB 3"),(1250,"USB 2")): rect(x-28,175,56,26,"#cfd8dc","#37474f",1.2,3); t(x,168,l,12,"#37474f","middle")
for y,l,c in ((610,"USB-C",ORG),(500,"µHDMI 0",RED),(420,"µHDMI 1",RED),(330,"аудио","#7f8c8d")): rect(1298,y-14,22,28,c,"#333",1.2,3); t(1288,y+5,l,13,"#fff","end")
# логическая колонка используемых пинов GPIO (порядок выбран так, чтобы провода не пересекались)
col_x=1040
rows=[(450,2,"5V",ORG),(478,6,"GND",BLK),(506,9,"GND",BLK),(534,10,"RXD",TEAL),(562,8,"TXD",GRN),(590,1,"3.3V",PUR)]
rect(1024,428,98,184,"#1b5e20","#a5d6a7",1.2,6)
t(1073,422,"GPIO",13,"#e8f5e9","middle","bold")
for y,n,l,c in rows:
    o.append(f'<circle cx="{col_x}" cy="{y}" r="9" fill="#cfa94a" stroke="{c}" stroke-width="3"/>')
    t(col_x,y+4,str(n),10,"#000","middle","bold"); t(col_x+16,y+5,l,13,"#e8f5e9","start","bold")
# врезка: реальное положение пинов на гребёнке 2x20 (вид спереди, пин 1 внизу, чётные — снаружи слева)
ix_even,ix_odd,iy1,st=1170,1186,612,13
t(1178,446,"где эти пины",11,"#c8e6c9","middle"); t(1178,459,"на гребёнке",11,"#c8e6c9","middle")
rect(1160,463,36,158,"#212121","#000",1,3)
used={2:ORG,6:BLK,9:BLK,10:TEAL,8:GRN,1:PUR}
for n in range(1,25):
    row=(n+1)//2; y=iy1-(row-1)*st; x=ix_odd if n%2 else ix_even
    if y<468: continue
    c=used.get(n,"#757575"); r=5 if n in used else 3.5
    o.append(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{c}" stroke="#cfa94a" stroke-width="1"/>')
    if n in used: t(x-10 if n%2==0 else x+10, y+4, str(n), 10, "#ffffff", "end" if n%2==0 else "start", "bold")
t(1178,640,"пин 1 — к microSD",11,"#c8e6c9","middle")
# --- Монитор (торец)
rect(1360,250,130,420,"#37474f","#263238",2,rx=10); t(1425,280,"Монитор",16,"#fff","middle","bold"); t(1425,298,"правый торец",12,"#cfd8dc","middle")
for y,l,c in ((340,"наушники","#7f8c8d"),(460,"mini HDMI",RED),(560,"Type-C",ORG)): rect(1350,y-14,24,28,c,"#111",1.2,3); t(1384,y+5,l,13,"#fff")
# ====== ПРОВОДА
# вход питания: нижний канал над разъёмами
wire([(130,705),(130,695),(855,695),(855,615)],RED,6)
wire([(200,705),(200,685),(925,685),(925,615)],BLK,6)
# DC-DC -> GPIO: верхние ряды, верхний ряд — внутренняя вертикаль
wire([(855,345),(855,300),(1000,300),(1000,450),(col_x,450)],ORG,5)
wire([(925,345),(925,318),(985,318),(985,478),(col_x,478)],BLK,4)
# RS485 TTL -> GPIO: нижний канал под блоками; левый пад — самый нижний канал и самая внутренняя вертикаль
wire([(655,615),(655,672),(1000,672),(1000,590),(col_x,590)],PUR,3.5)   # VCC -> пин 1
wire([(685,615),(685,662),(990,662),(990,562),(col_x,562)],GRN,3.5)    # TX  -> пин 8
wire([(715,615),(715,652),(980,652),(980,534),(col_x,534)],TEAL,3.5)   # RX  -> пин 10
wire([(745,615),(745,642),(970,642),(970,506),(col_x,506)],BLK,3)      # GND -> пин 9
# RS485 A/B/⏚ -> RJ45
wire([(670,395),(670,352),(570,352),(570,705)],YEL,3.5)          # A
wire([(705,395),(705,342),(535,342),(535,705)],YEL,3.5,"8 5")    # B
wire([(740,395),(740,332),(500,332),(500,705)],BLK,2.2)          # ⏚
# HDMI Pi -> монитор
wire([(1320,500),(1335,500),(1335,460),(1350,460)],BLU,7)
# USB Pi -> Type-C монитора (между Pi и монитором)
wire([(1250,175),(1250,140),(1342,140),(1342,560),(1350,560)],VIO,4)
# Ethernet — вариант
wire([(1050,175),(1050,152),(450,152),(450,700)],"#90a4ae",2.5,"4 6")
t(460,145,"или: Ethernet от Pi патч-кордом, если RJ45 под сеть, а не RS485",12,"#78909c")
# подписи
t(240,680,"питание 7–60 В",13,RED,"start","bold")
t(845,292,"5.1 В → пин 2,  GND → пин 6",13,ORG,"end","bold")
t(1236,134,"USB 2 → Type-C монитора (питание + тач)",13,VIO,"end","bold")
t(495,326,"A / B / ⏚ → RJ45",12,"#8d6e00","end","bold")
t(820,700+0,"",1)
t(1010,732,"RS485: TX → TXD (пин 8), RX → RXD (пин 10), VCC → 3.3 В (пин 1), GND → пин 9",13,"#455a64","middle","bold")
# легенда цветов
lg=[(RED,"вход 7–60 В +"),(BLK,"минус / GND"),(ORG,"+5.1 В"),(PUR,"+3.3 В на RS485"),(GRN,"TX"),(TEAL,"RX"),(YEL,"RS485 A / B"),(BLU,"HDMI"),(VIO,"USB")]
for i,(c,l) in enumerate(lg):
    x=60+i*160 if i<9 else 0
    o.append(f'<line x1="{x}" y1="840" x2="{x+34}" y2="840" stroke="{c}" stroke-width="6" stroke-linecap="round"/>'); t(x+42,845,l,13,"#333")
# ====== ВАЖНО
y=900
t(40,y,"Важно",22,"#c62828","start","bold")
notes=[
 "Выставь на DC-DC 5.1 В мультиметром ДО подключения к Pi. Питание через пины GPIO идёт в обход предохранителя Pi.",
 "RS485 питай от 3.3 В (пин 1), не от 5 В. Иначе его выход RX подаст на Pi 5 В и может сжечь порт.",
 "TX и RX: у части модулей подписи с точки зрения модуля. Если обмена нет — поменяй эти два провода местами.",
 "UART в Raspberry Pi OS: в config.txt добавить enable_uart=1 и dtoverlay=disable-bt, порт — /dev/serial0.",
 "Ток: DC-DC на 3 А. Pi 4 берёт до 2.5–3 А пиково, монитор ещё 0.6–1 А через её USB. Если Pi перезагружается — DC-DC на 5 А.",
 "HDMI: плоский шлейф micro HDMI → mini HDMI 15–20 см, угловой со стороны монитора. Монитор — в µHDMI 0 (ближний к USB-C).",
]
for i,n in enumerate(notes): t(60,y+34+i*28,"•  "+n,15,"#333")
# ====== ПОРЯДОК СБОРКИ
y2=y+34+len(notes)*28+30
t(40,y2,"Порядок сборки",22,"#111","start","bold")
steps=[
 "Паяльником вплавить 5 резьбовых вставок M3 в бобышки коробки.",
 "XT60 и BNC вставить снаружи в нижний борт. RJ45 на своей платке прижать изнутри к окну и закрепить.",
 "Raspberry Pi на 4 стойки, саморезы M2.5x6. USB вверх, micro-HDMI вправо.",
 "Припаять провода к DC-DC (IN, OUT) и к RS485 (TTL), выставить 5.1 В, вдвинуть обе платы в пазы сверху.",
 "Развести провода по схеме. Проверить полярность XT60 и 5 В до первого включения.",
 "На монитор надеть угловые mini HDMI и Type-C, кабели пропустить через окно к Pi. Выставить яркость.",
 "Монитор экраном наружу, разъёмами вправо, на полки. По периметру вспененный скотч 0.5–1 мм.",
 "Лицевая рамка, 5 потайных винтов M3x8.",
]
for i,s_ in enumerate(steps):
    yy=y2+36+i*30
    o.append(f'<circle cx="72" cy="{yy-5}" r="12" fill="#37474f"/>'); t(72,yy,str(i+1),13,"#fff","middle","bold"); t(96,yy,s_,15,"#333")
Hpx=y2+36+len(steps)*30+20; Wpx=1540
open(os.path.join(DOCS,"scheme_wiring.svg"),"w").write(f'<svg xmlns="http://www.w3.org/2000/svg" width="{Wpx}" height="{Hpx}" viewBox="0 0 {Wpx} {Hpx}" font-family="Arial, Liberation Sans, sans-serif"><rect width="100%" height="100%" fill="#fff"/>'+"".join(o)+'</svg>')
print("wiring", Wpx, Hpx)
