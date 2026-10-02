# LVS Verification Record — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** Layout vs Schematic (LVS) Verification  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tools:** Magic VLSI 8.3, Netgen 1.5  
**PDK:** SKY130A

---

## 1. Objective

To verify that the physical layout of the CMOS inverter is functionally equivalent to its schematic:

- Match device count and types (NMOS / PMOS)
- Match net connectivity (4 nets)
- Match pin names and directions
- Confirm no shorts or opens in the layout

---

## 2. Test Setup

| Parameter | Value |
|---|---|
| Layout Tool | Magic VLSI |
| Netlist Extraction | `extract all` + `ext2spice lvs` |
| Comparison Tool | Netgen 1.5 |
| Setup File | `sky130A_setup.tcl` |
| Layout Cell | `inverter_layout` |
| Schematic Cell | `inverter_schematic` |

---

## 3. Files Involved

| File | Description |
|---|---|
| `inverter_schematic.mag` | Magic layout (top cell) |
| `inverter_schematic.ext` | Extracted view |
| `inverter_layout.spice` | Layout netlist |
| `inverter_schematic.spice` | Schematic netlist |
| `lvs_report.log` | Netgen comparison log |

---

## 4. LVS Command

```bash
netgen -batch lvs \
  "inverter_layout.spice inverter_layout" \
  "inverter_schematic.spice inverter_schematic" \
  /usr/local/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl \
  lvs_report.log
```

---

## 5. Layout Netlist (Extracted)

```spice
* NGSPICE file created from inverter_schematic.ext - technology: sky130A

.subckt sky130_fd_pr__nfet_01v8_34VMYE B D S G
X0 S G D B sky130_fd_pr__nfet_01v8 ad=0.29 pd=2.58 as=0.29 ps=2.58 w=1 l=0.15
.ends

.subckt sky130_fd_pr__pfet_01v8_VJT448 B D S G
X0 S G D B sky130_fd_pr__pfet_01v8 ad=0.58 pd=4.58 as=0.58 ps=4.58 w=2 l=0.15
.ends

.subckt inverter_schematic vout vin gnd vdd
XXM1 gnd vout gnd vin sky130_fd_pr__nfet_01v8_34VMYE
XXM2 vdd vout vdd vin sky130_fd_pr__pfet_01v8_VJT448
.ends
```

---

## 6. Schematic Netlist

```spice
.subckt inverter_schematic vout vin gnd vdd
XM1 vout vin gnd gnd sky130_fd_pr__nfet_01v8 L=0.15 W=1 nf=1
XM2 vout vin vdd vdd sky130_fd_pr__pfet_01v8 L=0.15 W=2 nf=1
.ends
```

---

## 7. LVS Comparison Results

### 7.1 Device Comparison

| Device Class | Circuit 1 (Layout) | Circuit 2 (Schematic) | Match |
|---|---|---|---|
| sky130_fd_pr__nfet_01v8 | 1 | 1 | ✅ |
| sky130_fd_pr__pfet_01v8 | 1 | 1 | ✅ |
| **Total Devices** | **2** | **2** | ✅ |

### 7.2 Net Comparison

| Circuit | Nets | Match |
|---|---|---|
| Layout | 4 | ✅ |
| Schematic | 4 | ✅ |

### 7.3 Pin Comparison

| Pin | Circuit 1 (Layout) | Circuit 2 (Schematic) | Match |
|---|---|---|---|
| vout | Present | Present | ✅ |
| vin | Present | Present | ✅ |
| gnd | Present | Present | ✅ |
| vdd | Present | Present | ✅ |

---

## 8. LVS Output (Log Summary)

```
Circuit inverter_layout contains 2 device instances.
  Class: sky130_fd_pr__pfet_01v8 instances:   1
  Class: sky130_fd_pr__nfet_01v8 instances:   1
Circuit contains 4 nets.

Circuit inverter_schematic contains 2 device instances.
  Class: sky130_fd_pr__pfet_01v8 instances:   1
  Class: sky130_fd_pr__nfet_01v8 instances:   1
Circuit contains 4 nets.

Circuit 1 contains 2 devices, Circuit 2 contains 2 devices.
Circuit 1 contains 4 nets,    Circuit 2 contains 4 nets.

Subcircuit summary:
Circuit 1: inverter_layout                 | Circuit 2: inverter_schematic
-------------------------------------------|-------------------------------
sky130_fd_pr__nfet_01v8 (1)                | sky130_fd_pr__nfet_01v8 (1)
sky130_fd_pr__pfet_01v8 (1)                | sky130_fd_pr__pfet_01v8 (1)
Number of devices: 2                       | Number of devices: 2
Number of nets: 4                          | Number of nets: 4

Netlists match uniquely.

Subcircuit pins:
Circuit 1: inverter_layout                 | Circuit 2: inverter_schematic
-------------------------------------------|-------------------------------
vout                                       | vout
vin                                        | vin
gnd                                        | gnd
vdd                                        | vdd

Cell pin lists are equivalent.
Device classes inverter_layout and inverter_schematic are equivalent.

Final result: Circuits match uniquely.
```

---

## 9. Warning Analysis

The following warnings appeared during LVS but are **non-critical**:

| Warning | Meaning | Impact |
|---|---|---|
| `Call to undefined subcircuit sky130_fd_pr__nfet_01v8` | Model library not loaded | None — placeholder created |
| `No property mult/sa/sb/sd/nf found` | Optional parameters missing | None — optional |
| `black boxes` | Model behavior not checked | Normal for LVS |

**These warnings do not affect LVS correctness.** LVS still confirms device-level equivalence.

---

## 10. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| Device count match | 2 = 2 | 2 = 2 | ✅ |
| Device type match | NMOS + PMOS | NMOS + PMOS | ✅ |
| Net count match | 4 = 4 | 4 = 4 | ✅ |
| Pin match | vout, vin, gnd, vdd | All matched | ✅ |
| Final result | Match | **Circuits match uniquely** | ✅ |

---

## 11. Conclusion

The LVS verification confirms that the physical layout of the CMOS inverter is functionally equivalent to its schematic:

- **2 devices** (1 NMOS + 1 PMOS) in both layout and schematic
- **4 nets** (vout, vin, gnd, vdd) matched
- **All pins** matched (vout, vin, gnd, vdd)
- Netgen output: **"Circuits match uniquely"**

**The layout passes LVS sign-off.** No shorts, opens, or missing connections were detected. The design is ready for parasitic extraction (PEX).

---

## 12. Files

| File | Description |
|---|---|
| `inverter_schematic.mag` | Magic layout file |
| `inverter_schematic.ext` | Extracted layout |
| `inverter_layout.spice` | Layout netlist |
| `inverter_schematic.spice` | Schematic netlist |
| `lvs_report.log` | Netgen comparison log |

---

**End of LVS Verification Record**

