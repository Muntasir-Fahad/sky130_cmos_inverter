Transient Analysis  — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** Transient (Propagation Delay)  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tool:** ngspice 46  
**PDK:** SKY130A (TT corner, 27°C)

---

## 1. Objective

To measure the propagation delay and rise/fall times of the CMOS inverter using a pulse input stimulus.

- Propagation delay high-to-low (tpHL)
- Propagation delay low-to-high (tpLH)
- Rise time (10%–90%)
- Fall time (90%–10%)

---

## 2. Test Setup

| Parameter | Value |
|---|---|
| VDD | 1.8 V |
| NMOS (Wn / Ln) | 1.0 µm / 0.15 µm |
| PMOS (Wp / Lp) | 2.0 µm / 0.15 µm |
| Load Capacitance (CL) | 10 fF |
| Corner | TT |
| Temperature | 27°C |
| Input Stimulus | PULSE (0 → 1.8 V) |
| Rise/Fall Time (input) | 10 ps |
| Pulse Width | 5 ns |
| Period | 10 ns |
| Simulation Time | 20 ns |
| Time Step | 1 ps |

---

## 3. Simulation Netlist

```spice
XM1 vout vin 0 0 sky130_fd_pr__nfet_01v8 L=0.15 W=1 nf=1 
+ ad=0.29 as=0.29 pd=2.58 ps=2.58 nrd=0.29 nrs=0.29

XM2 vout vin vdd vdd sky130_fd_pr__pfet_01v8 L=0.15 W=2 nf=1 
+ ad=0.58 as=0.58 pd=4.58 ps=4.58 nrd=0.145 nrs=0.145

V1 vdd 0 1.8
V2 vin 0 PULSE(0 1.8 1n 10p 10p 5n 10n)
C1 vout 0 10f

.lib /usr/local/share/pdk/sky130A/libs.tech/combined/sky130.lib.spice tt

.control
tran 1p 20n
plot v(vin) v(vout)

meas tran tphl trig v(vin) val=0.9 rise=1 targ v(vout) val=0.9 fall=1
meas tran tplh trig v(vin) val=0.9 fall=1 targ v(vout) val=0.9 rise=1
meas tran trise trig v(vout) val=0.18 rise=1 targ v(vout) val=1.62 rise=1
meas tran tfall trig v(vout) val=1.62 fall=1 targ v(vout) val=0.18 fall=1
.endc
.end
```

---

## 4. Results

### 4.1 Extracted Timing Parameters

| Parameter | Symbol | Value |
|---|---|---|
| Propagation Delay (High → Low) | tpHL | **32.18 ps** |
| Propagation Delay (Low → High) | tpLH | **42.44 ps** |
| Average Propagation Delay | tpd | **37.31 ps** |
| Rise Time (10%–90%) | trise | **78.04 ps** |
| Fall Time (90%–10%) | tfall | **46.98 ps** |
| Skew \|tpHL − tpLH\| | — | **10.26 ps** |
| Skew % | — | **27.5%** |
| Max Operating Frequency | fmax | **~13.4 GHz** |

---

### 4.2 Waveform

![Transient Response](07_images/inverter_transient_analysis.png)

**Figure 1:** Input (vin) and output (vout) waveforms of the CMOS inverter. Input is a 0 → 1.8 V pulse train; output is the inverted rail-to-rail response.

**Observations:**
- Output swing: 0 V → 1.8 V (full rail-to-rail)
- Sharp transitions with minimal overshoot
- Asymmetry: tpLH > tpHL (PMOS weaker than NMOS)
- Clean digital waveform

---

## 5. Summary Table

| Parameter | Value | Target | Status |
|---|---|---|---|
| tpHL | 32.18 ps | < 50 ps | ✅ |
| tpLH | 42.44 ps | < 50 ps | ✅ |
| tpd (avg) | 37.31 ps | < 50 ps | ✅ |
| trise | 78.04 ps | < 100 ps | ✅ |
| tfall | 46.98 ps | < 100 ps | ✅ |
| Skew | 27.5% | < 10% | ⚠️ |
| Rail-to-rail swing | 1.8 V | 1.8 V | ✅ |

---

## 6. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| tpHL | < 50 ps | 32.18 ps | ✅ |
| tpLH | < 50 ps | 42.44 ps | ✅ |
| Average delay | < 50 ps | 37.31 ps | ✅ |
| Rise time | < 100 ps | 78.04 ps | ✅ |
| Fall time | < 100 ps | 46.98 ps | ✅ |
| Skew | < 10% | 27.5% | ⚠️ |
| Full swing | 1.8 V | 1.8 V | ✅ |

---

## 7. Conclusion

The transient analysis confirms that the CMOS inverter operates at high speed:

- **tpHL = 32.18 ps, tpLH = 42.44 ps** — both well below the 50 ps target
- **Average propagation delay = 37.31 ps** — excellent switching speed
- **Rise and fall times < 80 ps** — meet the 100 ps target
- **Full rail-to-rail output swing** — 0 V to 1.8 V
- **Skew = 27.5%** — above the 10% target; results from PMOS mobility being lower than NMOS

The delay asymmetry can be reduced by further increasing Wp, at the cost of larger layout area.

---

## 8. Files

| File | Description |
|---|---|
| `inverter_tran.spice` | Transient analysis netlist |
| `inverter_transient_analysis.png` | Waveform plot (Figure 1) |
| `data/transient_analysis_log.txt` | Full simulation log |

---

## 9. Image Reference

| Figure | Image File | Path in Repo |
|---|---|---|
| Figure 1 | inverter_transient_analysis.png | `07_images/inverter_transient_analysis.png` |

---

**End of Transient Analysis 

