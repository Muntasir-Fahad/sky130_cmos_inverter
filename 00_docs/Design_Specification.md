📋 Design Specification — CMOS Inverter (SKY130)

### 1. Technology & Supply

| Parameter | Symbol | Min | Typ | Max | Unit |
|---|---|---|---|---|---|
| Technology Node | — | — | 130 | — | nm |
| PDK | — | — | SKY130A | — | — |
| Supply Voltage | VDD | 1.62 | 1.8 | 1.98 | V |
| Operating Temperature | T | −40 | 27 | 125 | °C |
| Process Corners | — | ss | tt | ff | — |

---

### 2. Device Sizing

| Parameter | Symbol | Typ | Unit |
|---|---|---|---|
| NMOS Width | Wn | 1.0 | µm |
| NMOS Length | Ln | 0.15 | µm |
| PMOS Width | Wp | 2.0 | µm |
| PMOS Length | Lp | 0.15 | µm |
| Wp/Wn Ratio | — | 2.0 | — |
| Number of Fingers | nf | 1 | — |

---

### 3. DC Specifications

| Parameter | Symbol | Min | Typ | Max | Unit |
|---|---|---|---|---|---|
| Switching Threshold | VM | — | 0.9 | — | V |
| Output High Voltage | VOH | 1.7 | 1.8 | — | V |
| Output Low Voltage | VOL | — | 0 | 0.1 | V |
| Input High Voltage | VIH | — | 1.1 | — | V |
| Input Low Voltage | VIL | — | 0.7 | — | V |
| Noise Margin High | NMH | 0.4 | — | — | V |
| Noise Margin Low | NML | 0.4 | — | — | V |
| DC Gain (at VM) | Av | 10 | — | — | V/V |
| Static Leakage Power | Pleak | — | — | 1 | nW |

---

### 4. Transient Specifications

| Parameter | Symbol | Min | Typ | Max | Unit |
|---|---|---|---|---|---|
| Propagation Delay (HL) | tpHL | — | — | 50 | ps |
| Propagation Delay (LH) | tpLH | — | — | 50 | ps |
| Avg Propagation Delay | tpd | — | — | 50 | ps |
| Rise Time (10–90%) | trise | — | — | 100 | ps |
| Fall Time (90–10%) | tfall | — | — | 100 | ps |
| Skew \|tpHL−tpLH\| | — | — | — | 10 | % |
| Load Capacitance | CL | — | 10 | — | fF |

---

### 5. AC Specifications

| Parameter | Symbol | Min | Typ | Max | Unit |
|---|---|---|---|---|---|
| Midband Gain | Av | 20 | — | — | dB |
| Unity Gain Frequency | fT | 1 | — | 10 | GHz |
| −3dB Bandwidth | BW | — | — | — | GHz |
| Gain-Bandwidth Product | GBW | — | — | — | GHz |
| Phase Margin | PM | 45 | — | — | ° |
| Input Capacitance | Cin | 1 | — | 3 | fF |

---

### 6. Power Specifications

| Parameter | Symbol | Min | Typ | Max | Unit |
|---|---|---|---|---|---|
| Static Power | Pstatic | — | — | 1 | nW |
| Dynamic Power @ 100 MHz | Pdyn | — | — | 10 | µW |
| Energy per Switching | Ecycle | — | — | 50 | fJ |

---

### 7. Corner Targets

| Corner | Vm (V) | Gain (V/V) | tpd (ps) | I(VDD) @ 1.8V |
|---|---|---|---|---|
| tt | 0.90 ±5% | > 10 | < 50 | < 1 nA |
| ss | 0.90 ±10% | > 10 | < 60 | < 100 pA |
| ff | 0.90 ±10% | > 8 | < 40 | < 10 nA |

---

### 8. Temperature Targets

| Temp (°C) | Vm (V) | Gain (V/V) | tpd (ps) | Static Power |
|---|---|---|---|---|
| −40 | 0.90 ±10% | > 10 | < 50 | < 1 nW |
| 27 | 0.90 ±5% | > 10 | < 50 | < 1 nW |
| 125 | 0.90 ±10% | > 10 | < 50 | < 100 nW |

---

### 9. VDD Targets

| VDD (V) | Vm/VDD | Gain (V/V) | tpd (ps) |
|---|---|---|---|
| 1.62 | ~0.48 | > 10 | < 60 |
| 1.80 | ~0.48 | > 10 | < 50 |
| 1.98 | ~0.48 | > 10 | < 45 |

---

### 10. Layout & Sign-off

| Check | Target |
|---|---|
| DRC Violations | 0 |
| LVS Match | Yes |
| PEX | Done |
| Post-Layout tpd deviation | < 20% |
| Post-Layout gain deviation | < 10% |
| GDSII | Generated |

---

### 11. Summary Table (Key Goals)

| Category | Parameter | Target |
|---|---|---|
| **Sizing** | Wn × Wp | 1.0 × 2.0 µm |
| **Sizing** | L | 0.15 µm |
| **Timing** | tpd | < 50 ps |
| **Timing** | trise/tfall | < 100 ps |
| **Timing** | Skew | < 10% |
| **DC** | Vm | 0.9 V ±5% |
| **DC** | Gain | > 10 V/V |
| **DC** | NMH/NML | > 0.4 V |
| **AC** | Gain | > 20 dB |
| **AC** | UGF | 1–10 GHz |
| **AC** | PM | > 45° |
| **AC** | Cin | 1–3 fF |
| **Power** | Static | < 1 nW |
| **Power** | Dynamic @100MHz | < 10 µW |
| **Layout** | DRC | 0 |
| **Layout** | LVS | Match |


