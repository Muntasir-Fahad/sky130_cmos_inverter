v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 630 -340 630 -260 {lab=vout}
N 590 -370 590 -230 {lab=vin}
N 630 -400 630 -370 {lab=vdd}
N 630 -440 630 -400 {lab=vdd}
N 630 -230 630 -200 {lab=0}
N 530 -300 590 -300 {lab=vin}
N 630 -300 670 -300 {lab=vout}
N 350 -140 470 -140 {lab=0}
N 410 -140 410 -120 {lab=0}
N 350 -240 350 -200 {lab=vdd}
N 470 -240 470 -200 {lab=vin}
N 630 -200 630 -150 {lab=0}
N 670 -300 780 -300 {lab=vout}
N 720 -240 720 -210 {lab=0}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Muntasir Fahad"}
C {sky130_fd_pr/nfet_01v8.sym} 610 -230 0 0 {name=M1
W=1
L=0.15
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 610 -370 0 0 {name=M2
W=2
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {opin.sym} 780 -300 0 0 {name=p3 lab=vout}
C {vsource.sym} 350 -170 0 0 {name=V1 value=1.8 savecurrent=false}
C {gnd.sym} 410 -120 0 0 {name=l2 lab=0}
C {sky130_fd_pr/corner.sym} 390 -480 0 0 {name=CORNER only_toplevel=false corner=tt}
C {vsource.sym} 470 -170 0 0 {name=V2 value=1.8 savecurrent=false}
C {gnd.sym} 630 -150 0 0 {name=l3 lab=0}
C {lab_pin.sym} 350 -220 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 470 -220 0 0 {name=p2 sig_type=std_logic lab=vin}
C {lab_pin.sym} 630 -430 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 530 -300 0 0 {name=p5 sig_type=std_logic lab=vin}
C {code_shown.sym} 836.0992574932653 -520 0 0 {name=s1 only_toplevel=false value="
.control
dc V2 0 1.8 0.01
plot v(vout) vs v(vin)

* Vm at vout = VDD/2
meas dc vm when v(vout)=0.9

* Gain = dVout/dVin
let gain = deriv(v(vout))

* Absolute gain for max
let gain_abs = abs(gain)
meas dc gain_max max gain_abs

* VIL: where gain = -1 on falling side (vin < Vm)
* VIH: where gain = -1 on rising side (vin > Vm)
meas dc vil when gain=-1 from=0 to=0.9
meas dc vih when gain=-1 from=0.9 to=1.8

* Noise margins
let voh = 1.8
let vol = 0
let nmh = voh - vih
let nml = vil - vol
print nmh nml
.endc
"}
C {capa-2.sym} 720 -270 0 0 {name=C1
m=1
value=10f
footprint=1206
device=polarized_capacitor}
C {gnd.sym} 720 -210 0 0 {name=l4 lab=0}
