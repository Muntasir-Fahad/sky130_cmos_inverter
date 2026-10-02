
# DC Analysis Record — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** DC Sweep (Voltage Transfer Characteristic)  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tool:** ngspice 46  
**PDK:** SKY130A (TT corner, 27°C)

---

## 1. Objective

To characterize the DC voltage transfer characteristic (VTC) of the CMOS inverter and extract:

- Switching threshold voltage (VM)
- Maximum gain at transition
- Input Low voltage (VIL)
- Input High voltage (VIH)
- Noise margins (NMH, NML)

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
| Sweep Range | 0 → 1.8 V |
| Sweep Step | 0.01 V |
| Data Points | 181 |

---

## 3. Simulation Netlist

```spice
XM1 vout vin 0 0 sky130_fd_pr__nfet_01v8 L=0.15 W=1 nf=1 
+ ad=0.29 as=0.29 pd=2.58 ps=2.58 nrd=0.29 nrs=0.29

XM2 vout vin vdd vdd sky130_fd_pr__pfet_01v8 L=0.15 W=2 nf=1 
+ ad=0.58 as=0.58 pd=4.58 ps=4.58 nrd=0.145 nrs=0.145

V1 vdd 0 1.8
V2 vin 0 1.8
C1 vout 0 10f

.lib /usr/local/share/pdk/sky130A/libs.tech/combined/sky130.lib.spice tt

.control
dc V2 0 1.8 0.01
plot v(vout) vs v(vin)

meas dc vm when v(vout)=0.9
let gain = deriv(v(vout))
let gain_abs = abs(gain)
meas dc gain_max max gain_abs
meas dc vil when gain=-1 from=0 to=0.9
meas dc vih when gain=-1 from=0.9 to=1.8

let voh = 1.8
let vol = 0
let nmh = voh - vih
let nml = vil - vol
print nmh nml
.endc
.end
```

---

## 4. Results

### 4.1 Extracted DC Parameters

| Parameter | Symbol | Value |
|---|---|---|
| Switching Threshold | VM | **0.8695 V** |
| Maximum Gain | Gain_max | **11.85 V/V** |
| Gain Peak Location | Vin | 0.85 V |
| Input Low Voltage | VIL | **0.7409 V** |
| Input High Voltage | VIH | **0.9891 V** |
| Noise Margin High | NMH | **0.811 V** |
| Noise Margin Low | NML | **0.741 V** |
| Output High Voltage | VOH | 1.800 V |
| Output Low Voltage | VOL | 0 V |

---

### 4.2 Voltage Transfer Characteristic (VTC)

![VTC Curve](07_images/dc_analysis_vout_vs_vin_plot.png)

**Figure 1:** VTC of the CMOS inverter. Sharp transition from 1.8 V (HIGH) to 0 V (LOW) at approximately Vin = 0.87 V.

**Observations:**
- Output HIGH (1.8 V) for Vin < 0.7 V
- Sharp transition between Vin = 0.7 V and 1.0 V
- Output LOW (0 V) for Vin > 1.0 V
- Full rail-to-rail swing achieved

---

### 4.3 Gain Curve

![Gain Curve](07_images/dc_analysis_gain_plot.png)

**Figure 2:** DC gain (dVout/dVin) vs input voltage. Peak gain = 11.85 V/V at Vin = 0.85 V.

**Observations:**
- Peak gain = 11.85 V/V near switching threshold
- Sharp transition confirms good inverter action
- VIL and VIH extracted at unity gain points

---

## 5. Summary Table

| Parameter | Value | Target | Status |
|---|---|---|---|
| VM | 0.8695 V | 0.9 V ± 5% | ✅ |
| Gain_max | 11.85 V/V | > 10 V/V | ✅ |
| VIL | 0.7409 V | — | — |
| VIH | 0.9891 V | — | — |
| NMH | 0.811 V | > 0.4 V | ✅ |
| NML | 0.741 V | > 0.4 V | ✅ |
| VOH | 1.800 V | ≈ VDD | ✅ |
| VOL | 0 V | ≈ 0 V | ✅ |

---

## 6. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| Switching threshold | 0.9 V ± 5% | 0.8695 V | ✅ |
| Maximum gain | > 10 V/V | 11.85 V/V | ✅ |
| Noise margin high | > 0.4 V | 0.811 V | ✅ |
| Noise margin low | > 0.4 V | 0.741 V | ✅ |
| Rail-to-rail swing | 1.8 V | 1.8 V | ✅ |
| Symmetric VTC | VM ≈ VDD/2 | VM = 0.483 × VDD | ✅ |

---

## 7. Conclusion

The DC sweep analysis confirms excellent inverter performance:

- **VM = 0.8695 V** — 3.4% below ideal VDD/2
- **Gain_max = 11.85 V/V** — exceeds the 10 V/V target
- **Noise margins** (NMH = 0.811 V, NML = 0.741 V) — well above 0.4 V minimum
- **Full rail-to-rail output swing** (0 V to 1.8 V)
- **Sharp transition** confirms correct CMOS inverter behavior

The final sizing (Wn = 1.0 µm, Wp = 2.0 µm) produces a well-balanced, robust inverter with excellent noise immunity.

---

## 8. Files

| File | Description |
|---|---|
| `inverter_dc.spice` | DC sweep netlist |
| `dc_analysis_vout_vs_vin_plot.png` | VTC curve (Figure 1) |
| `dc_analysis_gain_plot.png` | Gain curve (Figure 2) |
| `dc_analysis_schematic.png` | Schematic snapshot |

---

## 9. Image Reference for GitHub

| Figure | Image File | Path in Repo |
|---|---|---|
| Figure 1 | dc_analysis_vout_vs_vin_plot.png | `07_images/dc_analysis_vout_vs_vin_plot.png` |
| Figure 2 | dc_analysis_gain_plot.png | `07_images/dc_analysis_gain_plot.png` |




**End of DC Analysis 


