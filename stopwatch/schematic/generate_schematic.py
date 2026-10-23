"""Generate self-contained KiCad RTL documentation from the current Verilog/XDC."""
from pathlib import Path
import json
import re
import uuid

OUT = Path(__file__).resolve().parent
ROOT = OUT.parent
PROJECT = "stopwatch_rtl"
def uid(): return str(uuid.uuid4())
def q(s): return json.dumps(str(s), ensure_ascii=False)
def effects(size=1.27, justify=""):
    return f'(effects (font (size {size} {size})) {"(justify " + justify + ")" if justify else ""})'

class Page:
    def __init__(self, name, title, page):
        self.name, self.title, self.page = name, title, page
        self.id = uid()
        self.libs, self.items = {}, []
    def text(self, x, y, value, size=1.5):
        self.items.append(f'(text {q(value)} (at {x} {y} 0) {effects(size, "left top")} (uuid {q(uid())}))')
    def wire(self, *pts):
        for (x,y),(xx,yy) in zip(pts,pts[1:]):
            self.items.append(f'(wire (pts (xy {x} {y}) (xy {xx} {yy})) (stroke (width 0) (type default)) (uuid {q(uid())}))')
    def label(self, x,y,name):
        self.items.append(f'(label {q(name)} (at {x} {y} 0) {effects(1.27,"left bottom")} (uuid {q(uid())}))')
    def stub(self, pin, name, side="L", length=20):
        x,y = pin
        xx = x-length if side=="L" else x+length
        self.wire((x,y),(xx,y))
        self.label(xx if side=="L" else x+1.27,y,name)
    def block(self, name, ref, value, x,y,w,h, left, right):
        # Each port tuple is (name, vertical offset from top of symbol center, type, number).
        lib = "RTL:"+name
        props = f'''(property "Reference" "U" (at 0 {h/2+5} 0) {effects()})
          (property "Value" {q(value)} (at 0 {h/2+2.5} 0) {effects()})'''
        drawing = f'''(symbol {q(name+"_0_1")}
          (rectangle (start {-w/2} {h/2}) (end {w/2} {-h/2})
          (stroke (width 0.254) (type default)) (fill (type background))))'''
        pins, locations = [], {}
        for side, ports in [("L",left),("R",right)]:
            for pname, dy, typ, num in ports:
                px = -w/2-5 if side=="L" else w/2+5
                angle = 0 if side=="L" else 180
                pins.append(f'''(pin {typ} line (at {px} {-dy} {angle}) (length 5)
                  (name {q(pname)} {effects(1.05)}) (number {q(num)} {effects(0.9)}))''')
                locations[pname] = (x+px,y+dy)
        self.libs[lib] = f'''(symbol {q(lib)} (pin_names (offset 1))
          (exclude_from_sim no) (in_bom no) (on_board no) {props} {drawing}
          (symbol {q(name+"_1_1")} {" ".join(pins)}))'''
        ident=uid()
        self.items.append(f'''(symbol (lib_id {q(lib)}) (at {x} {y} 0) (unit 1)
          (exclude_from_sim no) (in_bom no) (on_board no) (dnp no) (uuid {q(ident)})
          (property "Reference" {q(ref)} (at {x} {y-h/2-5} 0) {effects()})
          (property "Value" {q(value)} (at {x} {y-h/2-2.5} 0) {effects()})
          {" ".join(f'(pin {q(p[3])} (uuid {q(uid())}))' for p in left+right)}
          (instances (project {q(PROJECT)} (path {q('/'+root.id if self is root else '/'+root.id+'/'+self.sheetid)}
            (reference {q(ref)}) (unit 1)))))''')
        return locations
    def detail(self, child, x,y,w=72,h=16):
        child.sheetid=uid()
        self.items.append(f'''(sheet (at {x} {y}) (size {w} {h})
          (stroke (width 0.254) (type default)) (fill (color 0 0 0 0)) (uuid {q(child.sheetid)})
          (property "Sheetname" {q(child.title)} (at {x} {y-1.5} 0) {effects(1.27,"left bottom")})
          (property "Sheetfile" {q(child.name+".kicad_sch")} (at {x} {y+h+1.5} 0) {effects(1.05,"left top")}))''')
    def save(self):
        item_text = '\n'.join(self.items)
        content=f'''(kicad_sch (version 20250114) (generator "eeschema")
          (uuid {q(self.id)}) (paper "A3")
          (title_block (title {q(self.title)}) (date "2026-10-22") (rev "1.0")
            (company "Basys3 / XC7A35T-CPG236")
            (comment 1 "Verilog RTL documentation - not a PCB manufacturing schematic"))
          (lib_symbols {" ".join(self.libs.values())})
          {item_text}
          {f'(sheet_instances (path "/" (page "1")))' if self is root else ''}
          (embedded_fonts no))'''
        (OUT/(self.name+".kicad_sch")).write_text(content,encoding="utf-8")

def ports(names, types=None, step=10):
    return [(n,(i-(len(names)-1)/2)*step,(types or ["input"]*len(names))[i],str(i+1)) for i,n in enumerate(names)]
def outputs(names, start=10, step=10):
    return [(n,(i-(len(names)-1)/2)*step,"output",str(start+i)) for i,n in enumerate(names)]

root=Page(PROJECT,"Stopwatch / top_stopwatch RTL",1)
fnd=Page("fnd_detail","fnd_controller detail",2)
deb=Page("debounce_detail","btn_debouncer detail",3)
pinmap=Page("fpga_pinmap","XDC FPGA pin assignment",4)
main=Page("main_detail","main_controller behavior",5)
root.text(20,18,"STOPWATCH - RTL MODULE CONNECTIONS",2.8)
root.text(20,26,"100 MHz input | 1 kHz tick | 4-digit active-low seven-segment output",1.6)

a=root.block("btn_debouncer","U1","btn_debouncer",75,67,50,40,
    ports(["clk","rst","btn[3:0]"]),outputs(["clean_btn[3:0]"]))
b=root.block("tick_generator","U2","tick_generator",75,140,50,34,
    ports(["clk","rst"]),outputs(["tick"]))
c=root.block("main_controller","U3","main_controller",195,97,60,60,
    [("tick",-20,"input","1"),("rst",-10,"input","2"),("clean_btn[3:0]",0,"input","3"),("sw[7:0]",10,"input","4")],
    [("seg_data[13:0]",-10,"output","10"),("led[15:0]",10,"output","11")])
d=root.block("fnd_controller","U4","fnd_controller",320,97,60,60,
    [("clk",-20,"input","1"),("rst",-10,"input","2"),("tick",0,"input","3"),("in_data[13:0]",10,"input","4")],
    [("an[3:0]",-10,"output","10"),("seg[7:0]",10,"output","11")])
for block in [a,b,d]:
    for name in ["clk","rst"]: root.stub(block[name],name.upper())
root.stub(a["btn[3:0]"],"BTN[3..0]")
root.wire(a["clean_btn[3:0]"],(135,67),(135,97),c["clean_btn[3:0]"])
root.label(107,67,"CLEAN_BTN[3..0]")
root.stub(b["tick"],"TICK_1KHZ","R")
root.stub(c["tick"],"TICK_1KHZ",length=30)
root.stub(c["rst"],"RST",length=20)
root.stub(c["sw[7:0]"],"SW[7..0]",length=25)
root.stub(d["tick"],"TICK_1KHZ",length=30)
root.wire(c["seg_data[13:0]"],(260,87),(260,107),d["in_data[13:0]"])
root.label(232,87,"SEG_DATA[13..0]")
root.stub(c["led[15:0]"],"LED[15..0]","R")
root.stub(d["an[3:0]"],"AN[3..0]","R")
root.stub(d["seg[7:0]"],"SEG[7..0]","R")
root.text(45,165,"INPUT_FREQ = 100,000,000\nTICK_CNT = 100,000\nTick pulse: one CLK cycle per 1 ms",1.4)
root.text(155,146,"Main logic is clocked by posedge TICK.\nRST is asynchronous, active high.\nSW[7:0] is connected but unused in RTL.",1.4)
root.text(280,146,"AN and SEG are active low.\nSEG[0..6] = a,b,c,d,e,f,g; SEG[7] = dp.\nDigit scan advances every 1 ms.",1.4)
root.text(20,192,"DETAIL PAGES (documentation views of the blocks above)",1.8)
root.detail(fnd,20,210,82)
root.detail(deb,120,210,82)
root.detail(pinmap,220,210,82)
root.detail(main,320,210,82)
root.text(20,250,"Bus-width ports are shown as grouped RTL signals. They do not represent individual physical device pins.\nOnly the XDC pin-assignment page uses actual FPGA package pin numbers. No external board circuitry is inferred.",1.4)

# Display submodules and exact data/control connections.
fnd.text(20,18,"FND CONTROLLER - INTERNAL RTL",2.8)
fnd.text(20,27,"A detail view of U4 on page 1; repeated interfaces use local net labels.",1.5)
sel=fnd.block("fnd_digit_select","U5","fnd_digit_select",85,72,60,42,
    ports(["clk","rst","tick"]),outputs(["sel[1:0]"]))
bcd=fnd.block("bin2bcd_4digit","U6","bin2bcd_4digit",85,158,60,54,
    ports(["in_data[13:0]"]),outputs(["d1[3:0]","d10[3:0]","d100[3:0]","d1000[3:0]"],step=10))
dis=fnd.block("fnd_digit_display","U7","fnd_digit_display",280,115,80,94,
    ports(["tick","rst","sel[1:0]","d1[3:0]","d10[3:0]","d100[3:0]","d1000[3:0]"],step=10),
    outputs(["an[3:0]","seg[7:0]"],step=20))
for n,net in [("clk","CLK"),("rst","RST"),("tick","TICK_1KHZ")]: fnd.stub(sel[n],net, length=25)
fnd.stub(bcd["in_data[13:0]"],"SEG_DATA[13..0]",length=32)
fnd.stub(sel["sel[1:0]"],"SEL[1..0]","R")
for n in ["d1","d10","d100","d1000"]:
    fnd.stub(bcd[n+"[3:0]"],n.upper()+"[3..0]","R")
    fnd.stub(dis[n+"[3:0]"],n.upper()+"[3..0]",length=35)
for n,net in [("tick","TICK_1KHZ"),("rst","RST"),("sel[1:0]","SEL[1..0]")]: fnd.stub(dis[n],net,length=35)
fnd.stub(dis["an[3:0]"],"AN[3..0]","R")
fnd.stub(dis["seg[7:0]"],"SEG[7..0]","R")
fnd.text(25,210,"DECIMAL CONVERSION\nd1 = in_data % 10\nd10 = (in_data / 10) % 10\nd100 = (in_data / 100) % 10\nd1000 = (in_data / 1000) % 10",1.6)
fnd.text(150,210,"DIGIT MULTIPLEXER\nsel=0: d1, AN=1110\nsel=1: d10, AN=1101\nsel=2: d100, AN=1011\nsel=3: d1000, AN=0111",1.6)
fnd.text(275,210,"DECIMAL POINT\nBlink toggles every 500 ticks (0.5 s).\nSEG[7] = blink only at sel=2.\nThe clk port in fnd_digit_select is unused.\nDigit select is clocked by posedge tick.",1.5)

# Exact four independent debouncer instances; internals documented without inventing gates.
deb.text(20,18,"BUTTON DEBOUNCER - FOUR CHANNELS",2.8)
deb.text(20,27,"Instance names below are preserved from btn_debounce10ms.v. Physical button meaning follows XDC and main_controller.",1.4)
inst=["u_btnL_debouncer","u_btnU_debouncer","u_btnC_debouncer","u_btnD_debouncer"]
meaning=["LEFT / select stopwatch", "RIGHT / select clock", "UP / start or resume", "DOWN / stop"]
for i in range(4):
    x=100 if i%2==0 else 285
    y=75 if i<2 else 155
    p=deb.block("debouncer","U"+str(8+i),"debouncer",x,y,65,42,
        ports(["clk","rst","btn"]),outputs(["clean_btn"]))
    for n,net in [("clk","CLK"),("rst","RST"),("btn",f"BTN[{i}]")]: deb.stub(p[n],net,length=25)
    deb.stub(p["clean_btn"],f"CLEAN_BTN[{i}]","R",length=28)
    deb.text(x-38,y+27,inst[i]+"\n"+meaning[i],1.4)
deb.text(25,220,"EACH CHANNEL\nBTN -> r_sync1 -> r_sync2 -> stable-state counter -> CLEAN_BTN\nTwo flip-flop synchronizer, then DEBOUNCE_LIMIT = 999,999 (approximately 10 ms at 100 MHz).\nAsynchronous active-high reset clears synchronizer, counter, stored state, and output.",1.7)
deb.text(25,254,"The four clean_btn bits feed main_controller, where rising edges are detected using r_prev_btn.\nThe reset input is SW15 (R2), as constrained by the current project; it is not the center button.",1.4)

# Extract all active PACKAGE_PIN assignments (do not use commented Basys3 defaults).
xdc=ROOT/'stopwatch.srcs/constrs_1/imports/digilent-xdc-master/Basys3-Master_orginal.xdc'
mapping={}
for line in xdc.read_text(encoding='utf-8-sig').splitlines():
    if line.lstrip().startswith('#'): continue
    m=re.search(r'PACKAGE_PIN\s+(\w+).*?\[get_ports\s+\{?\s*([\w]+(?:\[\d+\])?)',line)
    if m: mapping[m[2]]=m[1]
assert len(mapping)==42, mapping
pinmap.text(20,18,"BASYS3 - TOP-LEVEL FPGA PIN MAP",2.8)
pinmap.text(20,27,"XC7A35T-CPG236-1 | all ports: LVCMOS33 | package pins extracted from the active XDC assignments",1.5)
leftnames=['clk','rst']+[f'btn[{i}]' for i in range(4)]+[f'sw[{i}]' for i in range(8)]
rightnames=[f'an[{i}]' for i in range(4)]+[f'seg[{i}]' for i in range(8)]+[f'led[{i}]' for i in range(16)]
physical=pinmap.block("FPGA_IO","U12","top_stopwatch / FPGA I/O view",205,151,95,176,
    [(n,-65+i*7.5,'input',mapping[n]) for i,n in enumerate(leftnames)],
    [(n,-81+i*6,'output',mapping[n]) for i,n in enumerate(rightnames)])
for n in leftnames: pinmap.stub(physical[n],n,length=32)
for n in rightnames: pinmap.stub(physical[n],n,"R",length=25)
pinmap.text(25,60,"INPUTS\nclk: W5, 100 MHz\nrst: R2, SW15 (active high)\nbtn[0]: W19, LEFT\nbtn[1]: T17, RIGHT\nbtn[2]: T18, UP\nbtn[3]: U17, DOWN\nsw[7:0]: SW7..SW0 (unused in RTL)",1.5)
pinmap.text(305,60,"DISPLAY\nan[0..3]: digit enables\nseg[0..6]: a,b,c,d,e,f,g\nseg[7]: decimal point\nBoth outputs are active low.",1.5)
pinmap.text(305,120,"LED OUTPUTS\nled[15:13]: mode code\nCLOCK=000, STOP_WATCH=001\nSTART=010, STOP=100, IDLE=111\nled[12:0]: as assigned in RTL",1.5)
pinmap.text(25,250,"This is an I/O assignment view of the implemented RTL, not a complete FPGA device symbol.\nPower, configuration, decoupling, board switches, LED resistors and display drivers belong to the existing Basys3 board.\nThe FPGA package pin numbers shown at the symbol are taken directly from the project XDC.",1.4)

main.text(20,18,"MAIN CONTROLLER - BEHAVIORAL LOGIC",2.8)
main.text(20,27,"Functional groups inside U3 (not additional Verilog module instances). All registers use posedge tick / asynchronous reset.",1.4)
edge=main.block("ButtonEdge","U13","button edge / mode register",100,75,74,46,
    ports(["tick","rst","clean_btn[3:0]"]),outputs(["r_mode[2:0]"]))
clock=main.block("ClockCounters","U14","clock counters",100,159,74,42,
    ports(["tick","rst"]),outputs(["r_min_cnt[6:0]","r_sec_cnt[5:0]"]))
watch=main.block("StopwatchCounters","U15","stopwatch counters",270,75,80,46,
    ports(["tick","rst","r_mode[2:0]"]),outputs(["r_stopwatch_sec_cnt[6:0]","r_stopwatch_ms_cnt[9:0]"]))
mux=main.block("DisplayExpression","U16","display arithmetic / mux",270,168,80,66,
    ports(["r_mode[2:0]","r_min_cnt[6:0]","r_sec_cnt[5:0]","watch_sec[6:0]","watch_ms[9:0]"]),outputs(["seg_data[13:0]"]))
for p in [edge,clock,watch]:
    main.stub(p['tick'],'TICK_1KHZ',length=30)
    main.stub(p['rst'],'RST',length=30)
main.stub(edge['clean_btn[3:0]'],'CLEAN_BTN[3..0]',length=33)
main.stub(edge['r_mode[2:0]'],'MODE[2..0]','R')
main.stub(watch['r_mode[2:0]'],'MODE[2..0]',length=30)
for n,net in [('r_min_cnt[6:0]','MIN[6..0]'),('r_sec_cnt[5:0]','SEC[5..0]')]: main.stub(clock[n],net,'R')
for n,net in [('r_stopwatch_sec_cnt[6:0]','WATCH_SEC[6..0]'),('r_stopwatch_ms_cnt[9:0]','WATCH_MS[9..0]')]: main.stub(watch[n],net,'R')
for n,net in [('r_mode[2:0]','MODE[2..0]'),('r_min_cnt[6:0]','MIN[6..0]'),('r_sec_cnt[5:0]','SEC[5..0]'),('watch_sec[6:0]','WATCH_SEC[6..0]'),('watch_ms[9:0]','WATCH_MS[9..0]')]: main.stub(mux[n],net,length=38)
main.stub(mux['seg_data[13:0]'],'SEG_DATA[13..0]','R')
main.text(20,216,"MODE / BUTTON PRIORITY\nReset -> CLOCK (000). Rising edges: LEFT -> STOP_WATCH (001); RIGHT -> CLOCK.\nUP -> START (010) if mode != CLOCK. DOWN -> STOP (100) only from START.\nIDLE (111) and DELAY_CNT=5000 are declared but no transition/delay logic uses them.",1.4)
main.text(20,244,"COUNTERS / DISPLAY\nClock counters advance regardless of mode: MS_CNT=1000, SEC_CNT=60, MIN_CNT=100.\nSTOP_WATCH clears watch counters; START updates them; STOP holds them. Limits: watch_ms=1000, watch_sec=100.\nseg_data = CLOCK ? (min * 100 + sec) : (watch_sec * 100 + watch_ms / 10).",1.4)
main.text(210,106,"LED[15:13] = mode code.\nCLOCK: LED[12:6] = minutes, LED[5:0] = seconds.\nSTART: LED[7:0] = watch_ms / 100.\nOther unassigned LED bits retain their RTL behavior.",1.35)
main.text(20,272,"Existing RTL assignments are preserved; this drawing does not assert corrected counter rollover or reset behavior.",1.3)

for page in [root,fnd,deb,pinmap,main]: page.save()
(OUT/'fpga_pinmap.csv').write_text('port,package_pin,iostandard\n'+''.join(f'{n},{p},LVCMOS33\n' for n,p in mapping.items()),encoding='utf-8-sig')
(OUT/'README.md').write_text('''# Stopwatch KiCad RTL schematic

Open **stopwatch_rtl.kicad_sch** in KiCad 9 or later (validated with KiCad 10).
All symbols are embedded; no external symbol library is required. Keep all five schematic files together.

1. Top-level RTL module connections.
2. fnd_controller internal module connections.
3. Four independent button debouncers.
4. Exact FPGA I/O pin assignments extracted from the active XDC.
5. main_controller behavioral groups, mode transitions, counters, display selection and LED assignments.

This is a functional RTL schematic for the current source, not a gate-level synthesis netlist or a PCB-ready Basys3 reproduction.
Grouped vector pins on the RTL pages represent complete signal vectors. Detail sheets are documentation views of the same instances,
not additional hardware. Net labels are local to each page. The FPGA I/O page uses actual package pin numbers.

## Source details

- FPGA: xc7a35tcpg236-1, Basys3.
- Clock: 100 MHz at W5; tick: 1 kHz, one 100 MHz clock cycle wide.
- Reset: active high, constrained to R2 / SW15.
- Buttons: btn[0]=left, btn[1]=right, btn[2]=up, btn[3]=down.
- The debouncer's internal instance names do not consistently match physical button names; connections follow indices and XDC.
- sw[7:0] and fnd_digit_select.clk are declared and connected but unused in their module logic.
- main_controller and display scan logic use posedge tick as their clock, exactly as in the source.
- Display outputs are active low; decimal point is seg[7].
- No behavioral corrections were made to the Verilog. The drawing documents existing code, including its current counter/state assignments.

Regenerate with `python generate_schematic.py`. The script reads the project's active XDC for the pin map;
the RTL module definitions and layout are explicitly described in the script.
''',encoding='utf-8')
print('Generated five KiCad schematic pages and',len(mapping),'FPGA pin assignments in',OUT)
