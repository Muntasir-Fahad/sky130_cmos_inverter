v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 600 -300 600 -220 {lab=vout}
N 560 -330 560 -190 {lab=vin}
N 600 -360 600 -330 {lab=vdd}
N 600 -400 600 -360 {lab=vdd}
N 600 -190 600 -160 {lab=gnd}
N 600 -160 600 -120 {lab=gnd}
N 500 -260 560 -260 {lab=vin}
N 600 -260 640 -260 {lab=vout}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Muntasir Fahad"}
C {sky130_fd_pr/nfet_01v8.sym} 580 -190 0 0 {name=M1
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
C {sky130_fd_pr/pfet_01v8.sym} 580 -330 0 0 {name=M2
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
C {iopin.sym} 600 -400 0 0 {name=p1 lab=vdd}
C {ipin.sym} 510 -260 0 0 {name=p2 lab=vin}
C {opin.sym} 640 -260 0 0 {name=p3 lab=vout}
C {iopin.sym} 600 -120 0 0 {name=p4 lab=gnd}
