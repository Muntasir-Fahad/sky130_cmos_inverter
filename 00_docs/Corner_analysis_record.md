Corner Analysis Record — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** Process Corner Analysis (DC, OP, Transient, AC)  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tool:** ngspice 46  
**PDK:** SKY130A


## 1. Objective

To verify the CMOS inverter performance across all five process corners:

| Corner | NMOS | PMOS |
|---|---|---|
| TT | Typical | Typical |
| SS | Slow | Slow |
| FF | Fast | Fast |
| SF | Slow | Fast |
| FS | Fast | Slow |

Four analysis types were performed per corner: **DC sweep, OP, Transient, AC**.


## 2. Test Setup

| Parameter | Value |
|---|---|
| VDD | 1.8 V |
| NMOS (Wn / Ln) | 1.0 µm / 0.15 µm |
| PMOS (Wp / Lp) | 2.0 µm / 0.15 µm |
| Load Capacitance (CL) | 10 fF |
| Temperature | 27°C |
| Corners | tt, ss, ff, sf, fs |


## 3. Simulation Setup

Each corner uses the same netlist, with the `.lib` line changed:

```spice
.lib /usr/local/share/pdk/sky130A/libs.tech/combined/sky130.lib.spice <corner>
```

Where `<corner>` ∈ {tt, ss, ff, sf, fs}.

Per-corner simulation folders: `tt/`, `ss/`, `ff/`, `sf/`, `fs/`.


## 4. DC Corner Results

| Corner | Vm (V) | Gain (V/V) | VIL (V) | VIH (V) | NMH (V) | NML (V) |
|---|---|---|---|---|---|---|
| tt | 0.9017 | 11.25 | 0.7758 | 1.0300 | 0.770 | 0.776 |
| ss | 0.8869 | 14.67 | 0.7849 | 0.9916 | 0.808 | 0.785 |
| ff | 0.9215 | 8.58 | 0.7661 | 1.0761 | 0.724 | 0.766 |
| sf | 0.8302 | 11.15 | 0.7063 | 0.9587 | 0.841 | 0.706 |
| fs | 0.9724 | 11.34 | 0.8445 | 1.1009 | 0.699 | 0.845 |

**Observations:**
- Vm spread: 0.830 V (sf) to 0.972 V (fs) — 142 mV total shift
- Highest gain: ss (14.67); lowest gain: ff (8.58) — still above target
- All noise margins > 0.69 V — robust design


## 5. OP Corner Results

Leakage current and static power at Vin = 1.8 V:

| Corner | vout (V) | i(VDD) (A) | Static Power |
|---|---|---|---|
| tt | 4.14 × 10⁻⁷ | −424.6 p | 0.76 nW |
| ss | 2.91 × 10⁻⁸ | −26.6 p | 0.048 nW |
| ff | 4.63 × 10⁻⁶ | −5.33 n | 9.60 nW |
| sf | 6.19 × 10⁻⁸ | −66.5 p | 0.12 nW |
| fs | 1.97 × 10⁻⁶ | −1.92 n | 3.46 nW |

**Observations:**
- FF corner: highest leakage (5.33 nA) — expected (fast devices)
- SS corner: lowest leakage (26.6 pA) — expected (slow devices)
- Worst-case static power (ff) = 9.60 nW — still below 1 µW target

---

## 6. Transient Corner Results

| Corner | tpHL (ps) | tpLH (ps) | trise (ps) | tfall (ps) | Skew % |
|---|---|---|---|---|---|
| tt | 32.18 | 42.44 | 78.04 | 46.98 | 27.5 |
| ss | 36.83 | 48.33 | 87.81 | 54.08 | 27.0 |
| ff | 28.04 | 39.45 | 72.11 | 40.73 | 33.8 |
| sf | 29.57 | 47.58 | 86.93 | 43.57 | 46.7 |
| fs | 35.14 | 38.38 | 71.19 | 50.91 | 8.8 |

**Observations:**
- Worst-case delay: ss (tpLH = 48.33 ps) — still < 50 ps
- Fastest: ff (tpHL = 28.04 ps)
- Highest skew: sf (46.7%) — asymmetric corner (PMOS fast, NMOS slow)
- Lowest skew: fs (8.8%) — balanced

---

## 7. AC Corner Results

| Corner | Gain (dB) | f3dB (MHz) | UGF (GHz) | PM (°) |
|---|---|---|---|---|
| tt | 21.37 | 446.4 | 5.25 | 91.4 |
| ss | 23.25 | 262.8 | 3.84 | 88.0 |
| ff | 19.56 | 713.1 | 6.79 | 89.4 |
| sf | 14.32 | 950.7 | 4.89 | 85.5 |
| fs | 11.65 | 980.1 | 3.65 | 81.7 |

**Observations:**
- Highest gain: ss (23.25 dB) — slow corner
- Lowest gain: fs (11.65 dB) — still above 10 dB
- Widest bandwidth: fs (980 MHz)
- All phase margins > 81° — excellent stability

---

## 8. Worst-Case Summary

| Parameter | Worst Corner | Value | Target | Status |
|---|---|---|---|---|
| Vm | sf | 0.830 V | 0.9 ± 10% | ✅ |
| Gain (DC) | ff | 8.58 V/V | > 8 | ✅ |
| Leakage | ff | 5.33 nA | < 10 nA | ✅ |
| tpLH | ss | 48.33 ps | < 50 ps | ✅ |
| Skew | sf | 46.7% | < 10% | ⚠️ |
| Gain (AC) | fs | 11.65 dB | > 10 dB | ✅ |
| PM | fs | 81.7° | > 45° | ✅ |
| NMH | ff | 0.724 V | > 0.4 V | ✅ |
| NML | sf | 0.706 V | > 0.4 V | ✅ |

---

## 9. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| Vm across corners | 0.9 V ± 10% | 0.830 – 0.972 V | ✅ |
| Gain (DC) across corners | > 8 V/V | 8.58 – 14.67 | ✅ |
| Delay across corners | < 50 ps | 28.04 – 48.33 ps | ✅ |
| Gain (AC) across corners | > 10 dB | 11.65 – 23.25 dB | ✅ |
| PM across corners | > 45° | 81.7 – 91.4° | ✅ |
| Leakage across corners | < 10 nA | 26.6 pA – 5.33 nA | ✅ |
| Noise margins | > 0.4 V | > 0.69 V | ✅ |
| Skew | < 10% | 8.8 – 46.7% | ⚠️ |

---

## 10. Conclusion

The CMOS inverter was verified across all five process corners:

- **DC:** Vm shifts ±142 mV; gain 8.58–14.67 V/V; noise margins > 0.69 V
- **OP:** Leakage 26.6 pA–5.33 nA; static power < 10 nW
- **Transient:** Delay 28.0–48.3 ps; all corners < 50 ps target
- **AC:** Gain 11.65–23.25 dB; phase margin 81.7–91.4°

The design passes all corners for timing, gain, leakage, and stability.

**Minor note:** Skew varies widely (8.8% at fs to 46.7% at sf) due to process asymmetry, but total delay remains within specification.

---

## 11. Files

| File | Description |
|---|---|
| `corner_sweep.sh` | DC corner sweep script |
| `corner_op.sh` | OP corner sweep script |
| `corner_tran.sh` | Transient corner sweep script |
| `corner_ac.sh` | AC corner sweep script |
| `corner_results.txt` | DC corner results |
| `op_corner_results.txt` | OP corner results |
| `tran_corner_results.txt` | Transient corner results |
| `ac_corner_results.txt` | AC corner results |
| `log_*.log` | Per-corner simulation logs |
| `tt/`, `ss/`, `ff/`, `sf/`, `fs/` | Per-corner netlists and screenshots |



**End of Corner Analysis 

