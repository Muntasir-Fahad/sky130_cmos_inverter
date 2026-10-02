#!/bin/bash
# OP Temperature Sweep — Leakage current

echo "==============================================================="
echo " Temperature Sweep — OP / Leakage Analysis (TT)"
echo " Wn=1.0, Wp=2.0, L=0.15, VDD=1.8V"
echo "==============================================================="
printf "%-8s %-12s %-16s %-12s %-16s %-12s\n" "Temp(C)" "vout@0V(V)" "I@0V(A)" "vout@1.8V(V)" "I@1.8V(A)" "Power(nW)"
echo "---------------------------------------------------------------"

for t in n40 c0 c27 c85 c125; do
    case $t in
        n40)  temp=-40 ;;
        c0)   temp=0   ;;
        c27)  temp=27  ;;
        c85)  temp=85  ;;
        c125) temp=125 ;;
    esac
    
    # --- Case 1: Vin = 0 V ---
    cp op_template.spice ${t}/op_${t}_v0.spice
    sed -i "s/TEMP_PLACEHOLDER/$temp/" ${t}/op_${t}_v0.spice
    sed -i "s/V2 vin 0 DC 0/V2 vin 0 DC 0/" ${t}/op_${t}_v0.spice
    cd ${t} && ngspice -b op_${t}_v0.spice > log_op_${t}_v0.log 2>&1 && cd ..
    
    vout0=$(grep "v(vout)" ${t}/log_op_${t}_v0.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    i0=$(grep "v1#branch" ${t}/log_op_${t}_v0.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    
    # --- Case 2: Vin = 1.8 V ---
    cp op_template.spice ${t}/op_${t}_v18.spice
    sed -i "s/TEMP_PLACEHOLDER/$temp/" ${t}/op_${t}_v18.spice
    sed -i "s/V2 vin 0 DC 0/V2 vin 0 DC 1.8/" ${t}/op_${t}_v18.spice
    cd ${t} && ngspice -b op_${t}_v18.spice > log_op_${t}_v18.log 2>&1 && cd ..
    
    vout18=$(grep "v(vout)" ${t}/log_op_${t}_v18.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    i18=$(grep "v1#branch" ${t}/log_op_${t}_v18.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    
    # Absolute leakage current
    i0_abs=$(echo "$i0" | awk '{if($1<0) printf "%.2e", -$1; else printf "%.2e", $1}')
    i18_abs=$(echo "$i18" | awk '{if($1<0) printf "%.2e", -$1; else printf "%.2e", $1}')
    
    # Static power (worst-case = max of two)
    power=$(echo "$i0_abs $i18_abs" | awk '{p1=$1*1.8; p2=$2*1.8; p=(p1>p2)?p1:p2; printf "%.4f", p*1e9}')
    
    printf "%-8s %-12s %-16s %-12s %-16s %-12s\n" "$temp" "$vout0" "$i0_abs" "$vout18" "$i18_abs" "$power"
done

echo "==============================================================="
echo " Done. Check logs in each folder"
echo "==============================================================="
