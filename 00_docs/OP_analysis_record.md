OP Analysis — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** DC Operating Point (OP)  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tool:** ngspice 46  
**PDK:** SKY130A (TT corner, 27°C)

---

## 1. Objective

To verify the DC operating point of the CMOS inverter under three input conditions:
- Vin = 0 V (input LOW)
- Vin = 0.9 V (mid-point)
- Vin = 1.8 V (input HIGH)

The analysis confirms transistor operating regions, leakage current, static power, and full rail-to-rail output swing.

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
| Simulation Command | `.op` |

---

## 3. Simulation Netlist

```spice
XM1 vout vin 0 0 sky130_fd_pr__nfet_01v8 L=0.15 W=1 nf=1 
+ ad=0.29 as=0.29 pd=2.58 ps=2.58 nrd=0.29 nrs=0.29

XM2 vout vin vdd vdd sky130_fd_pr__pfet_01v8 L=0.15 W=2 nf=1 
+ ad=0.58 as=0.58 pd=4.58 ps=4.58 nrd=0.145 nrs=0.145

V1 vdd 0 1.8
V2 vin 0 <0 | 0.9 | 1.8>
C1 vout 0 10f

.lib /usr/local/share/pdk/sky130A/libs.tech/combined/sky130.lib.spice tt

.control
op
print v(vout) v(vin)
print v1#branch
print @m.xm1.msky130_fd_pr__nfet_01v8[id]
print @m.xm2.msky130_fd_pr__pfet_01v8[id]
print @m.xm1.msky130_fd_pr__nfet_01v8[vgs]
print @m.xm1.msky130_fd_pr__nfet_01v8[vds]
print @m.xm1.msky130_fd_pr__nfet_01v8[vth]
print @m.xm2.msky130_fd_pr__pfet_01v8[vgs]
print @m.xm2.msky130_fd_pr__pfet_01v8[vds]
print @m.xm2.msky130_fd_pr__pfet_01v8[vth]
.endc
.end
```

---

## 4. Results

### 4.1 Case A: Vin = 0 V (Input LOW)

| Parameter | Value |
|---|---|
| v(vout) | **1.800 V** |
| v(vin) | 0 V |
| i(VDD) | **−2.037 pA** |
| NMOS id | 236.0 fA |
| PMOS id | 1.928 pA |
| NMOS vgs | −3.65 × 10⁻¹¹ V (≈0) |
| NMOS vds | 1.800 V |
| NMOS vth | 0.769 V |
| PMOS vgs | 1.800 V |
| PMOS vds | 2.87 × 10⁻⁹ V (≈0) |
| PMOS vth | 0.777 V |
| **NMOS Region** | **Cutoff** |
| **PMOS Region** | **Linear (Triode)** |

**Observation:** Output pulled HIGH (1.8 V). Only leakage current flows (pA range).


### 4.2 Case B: Vin = 0.9 V (Mid-point)

| Parameter | Value |
|---|---|
| v(vout) | **0.5514 V** |
| v(vin) | 0.900 V |
| i(VDD) | **−26.65 µA** |
| NMOS id | 26.648 µA |
| PMOS id | 26.648 µA |
| NMOS vgs | 0.896 V |
| NMOS vds | 0.543 V |
| NMOS vth | 0.770 V |
| PMOS vgs | 0.894 V |
| PMOS vds | 1.236 V |
| PMOS vth | 0.619 V |
| **NMOS Region** | **Saturation** |
| **PMOS Region** | **Saturation** |

**Observation:** Both transistors are in saturation. Short-circuit current = 26.65 µA. Output is below mid-rail (0.55 V), indicating VM < 0.9 V.



### 4.3 Case C: Vin = 1.8 V (Input HIGH)

| Parameter | Value |
|---|---|
| v(vout) | **4.14 × 10⁻⁷ V** (≈0) |
| v(vin) | 1.800 V |
| i(VDD) | **−424.6 pA** |
| NMOS id | 424.6 pA |
| PMOS id | 421.5 pA |
| NMOS vgs | 1.800 V |
| NMOS vds | 2.83 × 10⁻⁷ V (≈0) |
| NMOS vth | 0.770 V |
| PMOS vgs | −1.02 × 10⁻⁷ V (≈0) |
| PMOS vds | 1.800 V |
| PMOS vth | 0.544 V |
| **NMOS Region** | **Linear (Triode)** |
| **PMOS Region** | **Cutoff** |

**Observation:** Output pulled LOW (≈0 V). Only leakage current flows (pA range).

---

## 5. Summary Table

| Vin (V) | v(vout) (V) | i(VDD) (A) | Static Power (W) | NMOS State | PMOS State |
|---|---|---|---|---|---|
| 0.0 | 1.800 | −2.04 p | 3.67 p | Cutoff | Linear |
| 0.9 | 0.551 | −26.65 µ | 47.97 µ | Saturation | Saturation |
| 1.8 | ≈0 | −424.6 p | 0.76 n | Linear | Cutoff |

---

## 6. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| Vout @ Vin = 0 V | ≈ VDD (1.8 V) | 1.800 V | ✅ |
| Vout @ Vin = 1.8 V | ≈ 0 V | 4.14 × 10⁻⁷ V | ✅ |
| Full rail-to-rail swing | 1.8 V | 1.8 V | ✅ |
| Static power @ Vin = 0 V | < 1 nW | 3.67 pW | ✅ |
| Static power @ Vin = 1.8 V | < 1 nW | 0.76 nW | ✅ |
| Correct logic behavior | Required | Confirmed | ✅ |

---

## 7. Conclusion

The OP analysis confirms that the CMOS inverter operates correctly at all three input conditions:

- **Vin = 0 V:** NMOS cutoff, PMOS linear → output HIGH (1.8 V)
- **Vin = 0.9 V:** Both transistors in saturation → short-circuit current (26.65 µA)
- **Vin = 1.8 V:** NMOS linear, PMOS cutoff → output LOW (≈0 V)

Static power consumption is well below the 1 nW target in both stable states. Full rail-to-rail output swing is achieved.

---

## 8. Files

| File | Description |
|---|---|
| `inverter_op_vin_0V.spice` | OP analysis @ Vin = 0 V |
| `inverter_op_vin_0.9V.spice` | OP analysis @ Vin = 0.9 V |
| `inverter_op_vin_1.8V.spice` | OP analysis @ Vin = 1.8 V |


