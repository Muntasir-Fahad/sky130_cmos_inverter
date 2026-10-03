# SKY130 CMOS Inverter — Design & Verification

Complete CMOS inverter design in SKY130 open-source PDK with full verification flow: schematic → simulation → layout → DRC → LVS → PEX → post-layout → corner/temperature.

## Design Specifications

| Parameter | Value |
|---|---|
| Technology | SKY130A (tt corner) |
| Supply Voltage | 1.8 V |
| NMOS (Wn / Ln) | 1.0 µm / 0.15 µm |
| PMOS (Wp / Lp) | 2.0 µm / 0.15 µm |
| Wp/Wn Ratio | 2.0 |
| Load Capacitance | 10 fF |

## Key Results

### DC Analysis
| Parameter | Value |
|---|---|
| VM | 0.8695 V (pre) / 0.872 V (post) |
| Gain_max | 11.85 V/V |
| Rail swing | 1.8 V |
| NMH / NML | 0.811 / 0.741 V |

### AC Analysis
| Parameter | Value |
|---|---|
| Gain | 21.37 dB (pre) / 21.33 dB (post) |
| BW | 446 MHz (pre) / 1.16 GHz (post) |
| UGF | 5.25 GHz (pre) / 14.41 GHz (post) |
| PM | 88.58° (pre) / 70.03° (post) |

### Transient Analysis
| Parameter | Value |
|---|---|
| tpHL | 32.18 ps (pre) / 34.53 ps (post) |
| tpLH | 42.44 ps (pre) / 42.12 ps (post) |
| tpd | 37.31 ps (pre) / 38.33 ps (post) |

### Corner Analysis
| Corner | Gain (dB) | BW (GHz) | UGF (GHz) |
|---|---|---|---|
| tt | 21.37 | 1.16 | 14.41 |
| ss | 23.25 | 0.673 | 10.30 |
| ff | 19.56 | 1.89 | 19.01 |
| sf | 14.32 | 0.951 | 4.89 |
| fs | 11.65 | 0.980 | 3.65 |

## Tools Used

- Xschem — Schematic capture
- ngspice 46 — Circuit simulation
- Magic VLSI 8.3 — Layout design
- Netgen 1.5 — LVS verification
- SKY130A PDK — Process Design Kit

## Repository Structure

```
sky130_cmos_inverter/
├── 00_docs/          - Design spec + all analysis records
├── 01_schematic/     - Xschem schematic + netlist
├── 02_simulation/    - DC, AC, Tran, OP, corner, sweep
├── 03_sizing/        - W/L sweep results
├── 04_layout/        - Magic layout + LVS + screenshots
├── 05_pex/           - PEX netlist + post-layout runs
├── 06_gds/           - Final GDS
├── 07_images/        - All plots and screenshots
└── README.md
```

## Verification Flow

| Stage | Status |
|---|---|
| Schematic | Done |
| Pre-Layout Simulation | Done |
| Layout Design | Done |
| DRC | Clean |
| LVS | Match |
| PEX | Done |
| Post-Layout Simulation | Done |
| Corner Analysis | Done |
| Temperature Sweep | Done |
| VDD Sweep | Done |
| GDS | Generated |

## Important Note on Simulation Conditions

Pre- and post-layout AC simulations use different loading conditions; therefore their frequency-performance values are not directly comparable.

- **Pre-layout AC:** 10 fF external test load
- **Post-layout AC:** ~1.22 fF natural parasitic (from PEX)

## Author

**Md. Muntasir Fahad**  
Bangladesh Army University of Engineering and Technology (BAUET)  
Course: Analog IC Design  
Date: October 2026

## License

Educational use only.

