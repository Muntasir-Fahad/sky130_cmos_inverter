AC Analysis Record — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** AC (Small-Signal Frequency Response)  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tool:** ngspice 46  
**PDK:** SKY130A (TT corner, 27°C)


1. Objective

To characterize the small-signal AC response of the CMOS inverter biased at its switching threshold (VM):

- Midband gain
- −3 dB bandwidth (f3dB)
- Unity-gain frequency (UGF)
- Gain-Bandwidth Product (GBW)
- Phase margin
- Input capacitance (Cin)

---

2. Test Setup

| Parameter | Value |
|-----------|-------|
|    VDD    | 1.8 V |
| DC Bias (Vin) | 0.869 V (at VM) |
| AC Magnitude | 1 V |
| NMOS (Wn / Ln) | 1.0 µm / 0.15 µm |
| PMOS (Wp / Lp) | 2.0 µm / 0.15 µm |
| Load Capacitance (CL) | 10 fF |
| Corner | TT |
| Temperature | 27°C |
| Frequency Sweep | 1 Hz → 10 GHz |
| Points per Decade | 100 |

---

3. Simulation Netlist

```spice
XM1 vout vin 0 0 sky130_fd_pr__nfet_01v8 L=0.15 W=1 nf=1 
+ ad=0.29 as=0.29 pd=2.58 ps=2.58 nrd=0.29 nrs=0.29

XM2 vout vin vdd vdd sky130_fd_pr__pfet_01v8 L=0.15 W=2 nf=1 
+ ad=0.58 as=0.58 pd=4.58 ps=4.58 nrd=0.145 nrs=0.145

V1 vdd 0 1.8
V2 vin 0 DC 0.869 AC 1
C1 vout 0 10f

.lib /usr/local/share/pdk/sky130A/libs.tech/combined/sky130.lib.spice tt

.control
ac dec 100 1 10G

let gain_db   = db(vout)
let gain_lin  = mag(vout)
let phase_deg = ph(vout) * 180 / 3.14159
let cin_eff   = abs(imag(v2#branch)) / (2 * 3.14159 * frequency)

meas ac gain_midband find gain_db at=1
meas ac gain_lin_dc  find gain_lin at=1
meas ac ugf          when gain_db=0 fall=1
meas ac cin_at_1g    find cin_eff at=1G

meas ac gain_midband max gain_db
let gain_3db = gain_midband - 3
meas ac high_cutoff_frequency when gain_db = gain_3db fall=1
let bandwidth = high_cutoff_frequency - 0
print bandwidth
let gain_linear = 10^(gain_midband/20)
let gain_bandwidth_product = gain_linear * high_cutoff_frequency

let phase_deg = ph(vout)*180/pi
meas ac phase_at_unity find phase_deg when gain_db=0 fall=1
let phase_corrected = phase_deg - 180
meas ac phase_at_unity find phase_corrected when gain_db=0 fall=1
let phase_margin = 180 + phase_at_unity

print phase_margin
plot phase_deg
plot gain_db
print gain_3db
plot phase_deg
print gain_bandwidth_product
plot cin_eff

.endc

.end
```

---

## 4. Results

### 4.1 Extracted AC Parameters

| Parameter | Symbol | Value |
|---|---|---|
| Midband Gain | Gain | **21.37 dB** |
| Midband Gain (linear) | Gain | **11.71 V/V** |
| −3 dB Bandwidth | f3dB | **446.4 MHz** |
| Unity-Gain Frequency | UGF | **5.246 GHz** |
| Gain-Bandwidth Product | GBW | **5.23 GHz** |
| Phase at UGF | φ | **88.58°** |
| Phase Margin | PM | **88.58°** |
| Input Capacitance | Cin | **3.87 fF** |

---

### 4.2 Gain vs Frequency

![Gain Curve](07_images/plot_gain_db.png)

**Figure 1:** Gain (dB) vs frequency. Flat midband gain of 21.37 dB, rolling off at −20 dB/decade above 446 MHz.

**Observations:**
- Flat response from 1 Hz to ~100 MHz
- −3 dB point at 446 MHz
- Unity-gain crossing at 5.25 GHz
- Single-pole roll-off (−20 dB/decade)

---

### 4.3 Phase Response

![Phase Curve](07_images/plot_phase_degree.png)

**Figure 2:** Phase (degrees) vs frequency. Phase shifts from 180° (DC) to 88.58° at unity-gain frequency.

**Observations:**
- DC phase = 180° (inverting amplifier)
- Phase at UGF = 88.58°
- Phase margin = 88.58° — excellent stability
- No oscillation risk

---

### 4.4 Input Capacitance vs Frequency

![Cin Curve](07_images/plot_cin.png)

**Figure 3:** Effective input capacitance vs frequency. Cin = 6.5 fF at DC, rolling off to 3.87 fF at 1 GHz.

**Observations:**
- Cin at DC: ~6.5 fF
- Cin at 1 GHz: 3.87 fF
- Frequency-dependent due to Miller effect and junction caps

---

## 5. Summary Table

| Parameter | Value | Target | Status |
|---|---|---|---|
| Midband gain | 21.37 dB | > 20 dB | ✅ |
| Gain (linear) | 11.71 V/V | > 10 | ✅ |
| −3 dB bandwidth | 446.4 MHz | — | — |
| UGF | 5.246 GHz | 1–10 GHz | ✅ |
| GBW | 5.23 GHz | — | — |
| Phase margin | 88.58° | > 45° | ✅ |
| Cin @ 1 GHz | 3.87 fF | 1–3 fF | ⚠️ |

---

## 6. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| Midband gain | > 20 dB | 21.37 dB | ✅ |
| Gain (linear) | > 10 V/V | 11.71 V/V | ✅ |
| UGF | 1–10 GHz | 5.25 GHz | ✅ |
| Phase margin | > 45° | 88.58° | ✅ |
| Cin | 1–3 fF | 3.87 fF | ⚠️ |
| Stability | No oscillation | Stable | ✅ |

---

## 7. Conclusion

The AC analysis confirms excellent small-signal performance of the CMOS inverter:

- **Midband gain = 21.37 dB** — exceeds the 20 dB target
- **Unity-gain frequency = 5.25 GHz** — within the 1–10 GHz target
- **Phase margin = 88.58°** — well above the 45° minimum; excellent stability
- **−3 dB bandwidth = 446 MHz** — sufficient for high-speed digital applications
- **Cin = 3.87 fF at 1 GHz** — slightly above target (dominated by Miller capacitance)

The inverter is stable and well-suited for both digital and small-signal analog applications.

---

## 8. Files

File				Description
inverter_ac.spice		AC analysis netlist
plot db(vout).png		Gain (dB) vs freq (Figure 1)
plot gain_lin.png		Gain (linear) vs freq (Figure 2)
plot phase degree.png		Phase (deg) vs freq (Figure 3)
plot ph(vout).png		Phase (rad) vs freq (Figure 4)
plot vp(vout).png		Voltage phase (rad) vs freq (Figure 5)
plot gain_3db.png		Gain − 3dB threshold (Figure 6)
plot cin_eff.png		Input cap vs freq (Figure 7)
data/ac_analysis_log.txt	Full simulation log

---

## 9. Image Reference

Figure	Image File	Path in Repo
Figure 1	plot db(vout).png	07_images/plot db(vout).png
Figure 2	plot gain_lin.png	07_images/plot gain_lin.png
Figure 3	plot phase degree.png	07_images/plot phase degree.png
Figure 4	plot ph(vout).png	07_images/plot ph(vout).png
Figure 5	plot vp(vout).png	07_images/plot vp(vout).png
Figure 6	plot gain_3db.png	07_images/plot gain_3db.png
Figure 7	plot cin_eff.png	07_images/plot cin_eff.png

---

End of AC Analysis 

