#!/bin/bash
# Sizing sweep for CMOS inverter - find Wn/Wp for Vm = 0.9 V

echo "==============================================="
echo " Wn/Wp Sweep — Vm extraction (TT, 27C)"
echo "==============================================="
echo ""

for wn in .6 .8 1.0 1.2 1.4 1.6 ; do
  for wp in .6 .8 1.0 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.2 4.4; do
    cp ../../03_simulation/dc/inverter_dc.spice tmp_wn${wn}_wp${wp}.spice
    
    # Replace Wn and Wp in NMOS and PMOS lines
    sed -i "s/W=1 nf/W=$wn nf/" tmp_wn${wn}_wp${wp}.spice
    sed -i "s/W=2 nf/W=$wp nf/" tmp_wn${wn}_wp${wp}.spice
    
    # Simplify .control block — remove plots, keep only vm meas
    sed -i "s/^plot.*$//" tmp_wn${wn}_wp${wp}.spice
    sed -i "s/^meas dc gain_max.*$//" tmp_wn${wn}_wp${wp}.spice
    sed -i "s/^meas dc vil.*$//" tmp_wn${wn}_wp${wp}.spice
    sed -i "s/^meas dc vih.*$//" tmp_wn${wn}_wp${wp}.spice
    sed -i "s/^let gain.*$//" tmp_wn${wn}_wp${wp}.spice
    sed -i "s/^print nmh.*$//" tmp_wn${wn}_wp${wp}.spice
    
    # Run simulation
    ngspice -b tmp_wn${wn}_wp${wp}.spice > log_wn${wn}_wp${wp}.log 2>&1
    
    # Extract Vm
    vm=$(grep "vm " log_wn${wn}_wp${wp}.log | awk '{print $3}')
    
    # Extract gain_max
    gmax=$(grep "gain_max" log_wn${wn}_wp${wp}.log | awk '{print $3}')
    
    printf "Wn=%-4s Wp=%-4s  Vm=%-12s  Wp/Wn=%-5s\n" "$wn" "$wp" "$vm" "$(echo "scale=2; $wp/$wn" | bc)"
  done
done

echo ""
echo "==============================================="
echo "Done. Look for Vm closest to 0.9 V"
echo "==============================================="
