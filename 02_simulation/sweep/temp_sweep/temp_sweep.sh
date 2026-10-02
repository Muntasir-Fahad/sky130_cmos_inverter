#!/bin/bash
# Temperature Sweep — DC Analysis
# -40°C to +125°C

echo "==============================================================="
echo " Temperature Sweep — DC Analysis (TT corner)"
echo " Wn=1.0, Wp=2.0, L=0.15, VDD=1.8V"
echo "==============================================================="
printf "%-8s %-12s %-12s %-12s %-12s %-12s %-12s\n" "Temp(C)" "Vm(V)" "Gain" "VIL(V)" "VIH(V)" "NMH(V)" "NML(V)"
echo "---------------------------------------------------------------"

for t in n40 c0 c27 c85 c125; do
    case $t in
        n40)  temp=-40 ;;
        c0)   temp=0   ;;
        c27)  temp=27  ;;
        c85)  temp=85  ;;
        c125) temp=125 ;;
    esac
    
    # Copy + substitute temp
    cp dc_template.spice ${t}/dc_${t}.spice
    sed -i "s/TEMP_PLACEHOLDER/$temp/" ${t}/dc_${t}.spice
    
    # Run
    cd ${t}
    ngspice -b dc_${t}.spice > log_${t}.log 2>&1
    cd ..
    
    # Extract
    vm=$(grep "vm " ${t}/log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    gmax=$(grep "gain_max" ${t}/log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    vil=$(grep "vil " ${t}/log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    vih=$(grep "vih " ${t}/log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    nmh=$(grep "^nmh" ${t}/log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    nml=$(grep "^nml" ${t}/log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    
    printf "%-8s %-12s %-12s %-12s %-12s %-12s %-12s\n" "$temp" "$vm" "$gmax" "$vil" "$vih" "$nmh" "$nml"
done

echo "==============================================================="
echo " Done. Logs saved in each folder (log_n40.log, log_c27.log...)"
echo "==============================================================="

