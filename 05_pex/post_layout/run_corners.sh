#!/bin/bash
# Post-Layout Inverter Corner Analysis
# Runs tt, ff, ss corners automatically

echo "=========================================="
echo "Post-Layout Inverter Corner Analysis"
echo "=========================================="
echo ""

# Directory
cd ~/Desktop/chip/inverter_26_9_26/08_pex || exit 1

# Corners to run
CORNERS=("tt" "ff" "ss")

# Loop through corners
for CORNER in "${CORNERS[@]}"; do
    echo "=========================================="
    echo "Running corner: $CORNER"
    echo "=========================================="
    
    # Create corner-specific netlist
    cat > corner_${CORNER}.spice << EOF
** Post-Layout Inverter Corner: ${CORNER}
.include inverter_pex_4.spice
.lib /usr/local/share/pdk/sky130A/libs.tech/combined/sky130.lib.spice ${CORNER}

V1 vin 0 DC 0.872 AC 1
V2 vdd 0 1.8

.control
run
op
print v(vout) i(V2)

ac dec 10 1 100G
meas ac gain find vdb(vout) at=1k
meas ac bw when vdb(vout)=gain-3
meas ac ugf when vdb(vout)=0
meas ac pm find phase_deg at=1k
.endc
.end
EOF

    # Run simulation
    echo "Running ngspice..."
    ngspice -b  corner_${CORNER}.spice 2>&1 | tee corner_${CORNER}_log.txt | \
        grep -E "v\(vout\)|i\(v2\)|gain|bw|ugf|pm" | head -20
    
    echo ""
    echo "Log saved: corner_${CORNER}_log.txt"
    echo ""
done

echo "=========================================="
echo "All corners complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "--------"
for CORNER in "${CORNERS[@]}"; do
    echo "=== $CORNER ==="
    grep -E "gain|bw|ugf" corner_${CORNER}_log.txt 2>/dev/null | head -5
    echo ""
done
