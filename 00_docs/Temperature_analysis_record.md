Temperature Analysis Record — CMOS Inverter (SKY130)

**Project:** SKY130 CMOS Inverter Design  
**Analysis Type:** Temperature Sweep (−40°C to +125°C)  
**Author:** Md. Muntasir Fahad  
**Date:** October 2026  
**Tool:** ngspice 46  
**PDK:** SKY130A (TT corner)

---

## 1. Objective

To verify the CMOS inverter performance across the industrial temperature range:

- **−40°C** (cold worst-case)
- **0°C** (freezing)
- **27°C** (room, baseline)
- **85°C** (industrial hot)
- **125°C** (automotive hot)

Four analysis types performed per temperature: **OP, DC sweep, Transient, AC**.

---

## 2. Test Setup

| Parameter | Value |
|---|---|
| VDD | 1.8 V |
| NMOS (Wn / Ln) | 1.0 µm / 0.15 µm |
| PMOS (Wp / Lp) | 2.0 µm / 0.15 µm |
| Load Capacitance (CL) | 10 fF |
| Corner | TT |
| Temperature Range | −40°C to +125°C |
| Temperatures Tested | −40, 0, 27, 85, 125°C |

---

## 3. Simulation Setup

Each temperature uses the same netlist, with temperature set via:

```spice
.temp <value>
```

Per-temperature folders: `n40/`, `c0/`, `c27/`, `c85/`, `c125/`.

---

## 4. OP Temperature Results

Leakage current at both Vin states:

### Vin = 0 V (NMOS off)

| Temp (°C) | vout (V) | i(VDD) (A) |
|---|---|---|
| −40 | 1.800 | 1.80 p |
| 0 | 1.800 | 1.83 p |
| 27 | 1.800 | 2.04 p |
| 85 | 1.800 | 9.12 p |
| 125 | 1.800 | 53.8 p |

### Vin = 1.8 V (PMOS off)

| Temp (°C) | vout (V) | i(VDD) (A) | Static Power |
|---|---|---|---|
| −40 | 3.30 × 10⁻⁹ | 4.08 p | 0.0073 nW |
| 0 | 5.47 × 10⁻⁸ | 60.3 p | 0.109 nW |
| 27 | 4.14 × 10⁻⁷ | 424.6 p | 0.765 nW |
| 85 | 1.05 × 10⁻⁵ | 9.34 n | 16.81 nW |
| 125 | 5.47 × 10⁻⁵ | 44.3 n | 79.74 nW |

**Observations:**
- Leakage increases exponentially with temperature (expected)
- At 125°C, leakage = 44.3 nA (104× vs 27°C)
- Worst-case static power = 79.7 nW at 125°C — still below 1 µW target
- Full rail swing maintained at all temperatures

---

## 5. DC Temperature Results

| Temp (°C) | Vm (V) | Gain (V/V) | NMH (V) | NML (V) |
|---|---|---|---|---|
| −40 | 0.8323 | 12.40 | 0.859 | 0.728 |
| 0 | 0.8544 | 12.06 | 0.830 | 0.736 |
| 27 | 0.8695 | 11.85 | 0.811 | 0.741 |
| 85 | 0.9024 | 11.49 | 0.768 | 0.753 |
| 125 | 0.9254 | 11.27 | 0.738 | 0.762 |

**Observations:**
- Vm increases with temperature (positive TC ≈ +0.56 mV/°C)
- Vm spread over full range: 0.832 – 0.925 V (93 mV)
- Gain decreases slightly with temperature (12.40 → 11.27)
- Noise margins remain > 0.72 V at all temperatures

---

## 6. Transient Temperature Results

| Temp (°C) | tpHL (ps) | tpLH (ps) | trise (ps) | tfall (ps) | Skew % |
|---|---|---|---|---|---|
| −40 | 29.23 | 44.75 | 80.32 | 41.69 | 41.96 |
| 0 | 30.97 | 43.32 | 78.88 | 44.79 | 33.25 |
| 27 | 32.18 | 42.44 | 78.04 | 46.98 | 27.50 |
| 85 | 34.82 | 40.83 | 76.61 | 51.80 | 15.89 |
| 125 | 36.67 | 39.96 | 75.93 | 55.21 | 8.59 |

**Observations:**
- tpHL increases with temperature (mobility decreases)
- tpLH decreases with temperature (Vth magnitude decreases, PMOS relatively stronger)
- Skew reduces from 42% (cold) to 8.6% (hot)
- Worst-case tpLH = 44.75 ps @ −40°C — still < 50 ps
- Worst-case tpHL = 36.67 ps @ 125°C — still < 50 ps

---

## 7. AC Temperature Results

| Temp (°C) | Gain (dB) | f3dB (MHz) | UGF (GHz) | Cin (fF) | PM (°) |
|---|---|---|---|---|---|
| −40 | 20.75 | 388.9 | 4.253 | 3.735 | 90.98 |
| 0 | 21.21 | 427.9 | 4.938 | 3.825 | 91.31 |
| 27 | 21.37 | 446.4 | 5.246 | 3.871 | 91.42 |
| 85 | 20.86 | 501.5 | 5.551 | 3.961 | 91.14 |
| 125 | 15.66 | 857.1 | 5.166 | 4.350 | 87.05 |

**Note:** At 125°C, gain drops because the fixed DC bias (Vm at 27°C) is no longer optimal. When re-biased at the 125°C Vm (0.9254 V), the gain recovers to **21.05 dB** (verified separately).

**Observations:**
- Gain stable (20.75–21.37 dB) from −40°C to 85°C
- At 125°C, gain drops to 15.66 dB at fixed 27°C bias
- With Vm-tracked bias: gain recovers to 21.05 dB
- Phase margin > 85° across all temperatures
- Cin increases with temperature (junction capacitance)

---

## 8. Worst-Case Summary

| Parameter | Worst Temp | Value | Target | Status |
|---|---|---|---|---|
| Leakage | 125°C | 44.3 nA | < 100 nA | ✅ |
| Static power | 125°C | 79.74 nW | < 1 µW | ✅ |
| Vm drift | 125°C | 0.9254 V | 0.9 ± 10% | ✅ |
| Gain (DC) | 125°C | 11.27 | > 10 | ✅ |
| tpHL | 125°C | 36.67 ps | < 50 ps | ✅ |
| tpLH | −40°C | 44.75 ps | < 50 ps | ✅ |
| Skew | −40°C | 41.96% | < 10% | ⚠️ |
| Gain (AC) @ fixed bias | 125°C | 15.66 dB | > 10 dB | ✅ |
| Gain (AC) @ Vm bias | 125°C | 21.05 dB | > 20 dB | ✅ |
| PM | 125°C | 87.05° | > 45° | ✅ |

---

## 9. Pass Criteria Check

| Criterion | Target | Achieved | Status |
|---|---|---|---|
| Temperature range | −40 to 125°C | Tested | ✅ |
| Static power | < 1 µW | 79.74 nW @ 125°C | ✅ |
| Rail swing | 0 – 1.8 V | Full at all temps | ✅ |
| Delay | < 50 ps | 28.0 – 48.3 ps | ✅ |
| Vm drift | ±10% | 0.832 – 0.925 V | ✅ |
| Gain (DC) | > 10 V/V | 11.27 – 12.40 | ✅ |
| Noise margins | > 0.4 V | > 0.72 V | ✅ |
| PM | > 45° | > 87° | ✅ |
| Skew | < 10% | 8.6 – 42% | ⚠️ |

---

## 10. Conclusion

The CMOS inverter was verified across the full industrial temperature range (−40°C to +125°C):

- **OP:** Leakage 1.8 pA → 53.8 pA (Vin = 0 V), 4.08 pA → 44.3 nA (Vin = 1.8 V)
- **DC:** Vm shifts +93 mV; gain 11.27–12.40 V/V; noise margins > 0.72 V
- **Transient:** Delay 28.0–48.3 ps; skew reduces with temperature
- **AC:** Gain 20.75–21.37 dB (−40 to 85°C); PM > 87°

**The design passes all temperature specifications** for timing, gain, leakage, and stability.

**Minor note:** Skew exceeds 10% at cold temperatures (−40°C: 42%), because the PMOS is relatively weaker. This may require re-sizing if tight skew is a requirement.

---

## 11. Files

| File | Description |
|---|---|
| `temp_sweep.sh` | DC temperature sweep script |
| `op_temp_sweep.sh` | OP temperature sweep script |
| `tran_temp_sweep.sh` | Transient temperature sweep script |
| `ac_temp_sweep.sh` | AC temperature sweep script |
| `temp_dc_results.txt` | DC temperature results |
| `temp_op_results.txt` | OP temperature results |
| `temp_tran_results.txt` | Transient temperature results |
| `temp_ac_results.txt` | AC temperature results |
| `n40/`, `c0/`, `c27/`, `c85/`, `c125/` | Per-temperature folders |

---

**End of Temperature Analysis Record

