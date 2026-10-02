#!/bin/bash
# AC Temperature Sweep — Two-Step (gain first, then f3db)

echo "==============================================================="
echo " Temperature Sweep — AC Analysis (TT)"
echo " Wn=1.0, Wp=2.0, L=0.15, VDD=1.8V, CL=10fF"
echo "==============================================================="
printf "%-8s %-12s %-12s %-12s %-12s %-12s\n" "Temp(C)" "Gain(dB)" "f3db(MHz)" "UGF(GHz)" "Cin(fF)" "PM(deg)"
echo "---------------------------------------------------------------"

for t in n40 c0 c27 c85 c125; do
    case $t in
        n40)  temp=-40 ;;
        c0)   temp=0   ;;
        c27)  temp=27  ;;
        c85)  temp=85  ;;
        c125) temp=125 ;;
    esac
    
    # ---- Step 1: Gain measurement ----
    cp ac_template.spice ${t}/ac_${t}.spice
    sed -i "s/TEMP_PLACEHOLDER/$temp/" ${t}/ac_${t}.spice
    
    cd ${t} && ngspice -b ac_${t}.spice > ac_log_${t}_step1.log 2>&1 && cd ..
    
    gain=$(grep "gain_midband" ${t}/ac_log_${t}_step1.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    
    if [ -z "$gain" ]; then
        printf "%-8s %-12s %-12s %-12s %-12s %-12s\n" "$temp" "FAIL" "-" "-" "-" "-"
        continue
    fi
    
    # ---- Step 2: Threshold + f3db ----
    threshold=$(echo "$gain" | awk '{printf "%.4f", $1-3}')
    
    cd ${t}
    cp ac_${t}.spice ac_${t}_final.spice
    sed -i "s|meas ac phase_at_unity find phase_deg when gain_db=0 fall=1|let g3 = gain_db - $threshold\nmeas ac f3db when g3=0\nmeas ac phase_at_unity find phase_deg when gain_db=0 fall=1|" ac_${t}_final.spice
    ngspice -b ac_${t}_final.spice > ac_log_${t}.log 2>&1
    cd ..
    
    # ---- Extract all ----
    f3db=$(grep "^f3db " ${t}/ac_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    ugf=$(grep "^ugf " ${t}/ac_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    cin=$(grep "cin_at_1g" ${t}/ac_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    ph=$(grep "phase_at_unity" ${t}/ac_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    
    f3db_mhz=$(echo "$f3db" | awk '{printf "%.2f", $1/1e6}')
    ugf_ghz=$(echo "$ugf" | awk '{printf "%.3f", $1/1e9}')
    cin_ff=$(echo "$cin" | awk '{printf "%.3f", $1*1e15}')
    pm=$(echo "$ph" | awk '{printf "%.2f", 180-$1}')
    
    printf "%-8s %-12s %-12s %-12s %-12s %-12s\n" "$temp" "$gain" "$f3db_mhz" "$ugf_ghz" "$cin_ff" "$pm"
done

echo "==============================================================="
echo " Done. Logs in each folder (ac_log_n40.log, ...)"
echo "==============================================================="

