# PEX Extraction Record — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** Parasitic Extraction (PEX)  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tools:** Magic VLSI 8.3, ngspice 46  
**PDK:** SKY130A

---

## 1. Objective

To extract the parasitic resistances and capacitances from the physical layout of the CMOS inverter so that post-layout simulations include realistic routing and device parasitics.

Deliverables:

- PEX netlist with parasitic resistors (R) and capacitors (C)
- Accurate parasitic values for the output node (vout)
- ngspice-ready netlist for post-layout verification

---

## 2. Test Setup

| Parameter | Value |
|---|---|
| Layout Cell | `inverter_schematic` |
| Extraction Tool | Magic VLSI (`extract all`, `extresist`) |
| Netlist Generator | `ext2spice -R` |
| Resistance Tolerance | 10 Ω |
| Capacitance Threshold | 0.01 fF |
| PDK | SKY130A |

---

## 3. PEX Extraction Flow

### 3.1 Magic Commands

```
load inverter_schematic.mag
extract do resistance
extract all
extresist tolerance 10
extresist
ext2spice cthresh 0.01
ext2spice rthresh 0.1
ext2spice -p inverter_schematic -R -o inverter_pex_4.spice
```

**Note:** Magic appends `**FLOATING` inline comments to some capacitors. These are removed for ngspice compatibility using:

```bash
sed -i 's/ \*\*FLOATING//g' inverter_pex_4.spice
```

---

## 4. PEX Netlist Summary

### 4.1 Devices

| Device | Type | W × L (µm) | Model |
|---|---|---|---|
| `X0` | NMOS | 1.0 × 0.15 | sky130_fd_pr__nfet_01v8 |
| `X1` | PMOS | 2.0 × 0.15 | sky130_fd_pr__pfet_01v8 |

### 4.2 Parasitic Capacitors

| Cap | Node Pair | Value (fF) | Type |
|---|---|---|---|
| C0 | vdd ↔ vin | 0.797 | Coupling |
| C1 | vdd ↔ vout | 0.732 | Coupling |
| **C2** | **vin ↔ vout** | **0.342** | **Miller capacitance** |
| C15 | vdd ↔ gnd | 4.061 | Power rail |
| **C30** | **vout ↔ gnd** | **0.878** | **Output load** |
| C31 | vin ↔ gnd | 1.382 | Input cap |

**Total critical parasitic capacitance ≈ 8.19 fF**

Additional small capacitors (C3–C14, C16–C29, C32–C37) exist on internal nodes with values < 0.25 fF each. These contribute negligibly to overall circuit behavior.

### 4.3 Parasitic Resistors

- **107 parasitic resistors** extracted from layout
- **NMOS gate poly resistance:** 220.113 Ω (R4)
- **PMOS gate poly resistance:** 395.24 Ω (R26)
- Metal routing resistances: < 100 Ω

**Key resistor paths:**

| Path | Resistance (Ω) |
|---|---|
| NMOS gate poly (R4) | 220.113 |
| PMOS gate poly (R26) | 395.24 |
| NMOS drain via met1 (R2) | 61.667 |
| PMOS source via met1 (R22) | 97.500 |

---

## 5. Key Parasitics — Impact Analysis

### 5.1 Output Node (vout)

| Parasitic | Value | Impact |
|---|---|---|
| Cout (vout ↔ gnd) | 0.878 fF | Output pole — reduces BW |
| Cgd (vin ↔ vout) | 0.342 fF | Miller effect — increases Cin |

**Total output load ≈ 1.22 fF** (excluding external 10 fF test load)

### 5.2 Power Rail (vdd ↔ gnd)

| Parasitic | Value | Impact |
|---|---|---|
| Cvdd | 4.061 fF | Supply decoupling — positive effect |

### 5.3 Input Node (vin)

| Parasitic | Value | Impact |
|---|---|---|
| Cin (vin ↔ gnd) | 1.382 fF | Adds to input capacitance |
| Miller cap (vin ↔ vout) | 0.342 fF | Multiplied by gain at output |

---

## 6. PEX Netlist Snapshot

```spice
* SPICE3 file created from inverter_schematic.ext - technology: sky130A

X0 XM1/S.t0 XM1/G.t0 XM1/D.t0 XM1/B.t0 sky130_fd_pr__nfet_01v8 
+ ad=0.29 pd=2.58 as=0.29 ps=2.58 w=1 l=0.15

X1 XM2/S.t0 XM2/G.t0 XM2/D.t0 XM2/B.t0 sky130_fd_pr__pfet_01v8 
+ ad=0.58 pd=4.58 as=0.58 ps=4.58 w=2 l=0.15

* Parasitic capacitors (critical)
C0  vdd  vin   0.79714f
C1  vdd  vout  0.7316f
C2  vin  vout  0.34195f
C15 vdd  gnd   4.06141f
C30 vout gnd   0.87792f
C31 vin  gnd   1.38237f

* Parasitic resistors (sample)
R4  XM1/G.n0 XM1/G.t0 220.113
R26 XM2/G.n0 XM2/G.t0 395.24
R0  gnd     XM1/S.n0 61.6672
R2  vout    XM1/D.n0 61.6672
R22 vdd     XM2/S.n0 97.5005
R24 vout    XM2/D.n0 97.5005
... (107 resistors total)
```

**Note:** All `**FLOATING` comments removed. Netlist is directly simulation-ready in ngspice.

---

## 7. Summary Table

| Parameter | Value | Notes |
|---|---|---|
| Devices extracted | 2 | NMOS + PMOS |
| Parasitic capacitors | 37 (6 critical) | Total ~8.19 fF |
| Parasitic resistors | 107 | Dominated by gate poly |
| Output cap (vout) | 1.22 fF | Critical for BW |
| Miller cap | 0.342 fF | Multiplied by gain |
| Power decoupling cap | 4.061 fF | Positive effect |
| NMOS gate R | 220 Ω | Poly routing |
| PMOS gate R | 395 Ω | Poly routing |

---

## 8. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| PEX extraction successful | Yes | Done | ✅ |
| Devices match LVS | 2 = 2 | 2 = 2 | ✅ |
| Nets match LVS | 4 = 4 | 4 = 4 | ✅ |
| Output cap | < 5 fF | 1.22 fF | ✅ |
| Miller cap | < 1 fF | 0.342 fF | ✅ |
| Netlist simulation-ready | Yes | Yes | ✅ |

---

## 9. Conclusion

The PEX extraction successfully captured all relevant parasitics from the physical layout:

- **Devices:** 2 (NMOS + PMOS) matching schematic
- **Parasitic capacitances:** 6 critical caps, total ≈ 8.19 fF
- **Parasitic resistances:** 107 resistors, dominated by gate poly (220–395 Ω)
- **Output node load:** 1.22 fF (dominates post-layout BW)
- **Miller capacitance:** 0.342 fF

The PEX netlist is **ready for post-layout simulation**. Initial estimates suggest:

- Delay may increase by ~10–20% vs pre-layout
- Bandwidth may drop due to output node load
- Gain change is expected to be minimal (< 5%)

These are verified in the post-layout simulation records.

---

## 10. Files

| File | Description |
|---|---|
| `inverter_schematic.mag` | Layout (Magic) |
| `inverter_schematic.ext` | Extracted layout |
| `inverter_schematic.res.ext` | Resistance extract |
| `inverter_pex_4.spice` | **PEX netlist (clean, ngspice-ready)** |
| `sky130_fd_pr__nfet_01v8_34VMYE.ext` | NMOS extract |
| `sky130_fd_pr__pfet_01v8_VJT448.ext` | PMOS extract |
| `pex_extraction_log.txt` | Magic extraction log |

---

**End of PEX Extraction Record**


