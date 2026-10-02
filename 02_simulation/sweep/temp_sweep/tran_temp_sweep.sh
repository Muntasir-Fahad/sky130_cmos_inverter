#!/bin/bash
echo "==============================================================="
echo " Temperature Sweep — Transient Analysis (TT)"
echo "==============================================================="
printf "%-8s %-12s %-12s %-12s %-12s %-12s\n" "Temp(C)" "tpHL(ps)" "tpLH(ps)" "trise(ps)" "tfall(ps)" "Skew%"
echo "---------------------------------------------------------------"

for t in n40 c0 c27 c85 c125; do
    case $t in
        n40)  temp=-40 ;;
        c0)   temp=0   ;;
        c27)  temp=27  ;;
        c85)  temp=85  ;;
        c125) temp=125 ;;
    esac
    
    cp tran_template.spice ${t}/tran_${t}.spice
    sed -i "s/TEMP_PLACEHOLDER/$temp/" ${t}/tran_${t}.spice
    
    cd ${t}
    ngspice -b tran_${t}.spice > tran_log_${t}.log 2>&1
    cd ..
    
    tphl=$(grep "^tphl " ${t}/tran_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    tplh=$(grep "^tplh " ${t}/tran_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    trise=$(grep "^trise " ${t}/tran_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    tfall=$(grep "^tfall " ${t}/tran_log_${t}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    
    tphl_ps=$(echo "$tphl" | awk '{printf "%.2f", $1*1e12}')
    tplh_ps=$(echo "$tplh" | awk '{printf "%.2f", $1*1e12}')
    trise_ps=$(echo "$trise" | awk '{printf "%.2f", $1*1e12}')
    tfall_ps=$(echo "$tfall" | awk '{printf "%.2f", $1*1e12}')
    skew=$(echo "$tphl_ps $tplh_ps" | awk '{d=$1-$2; if(d<0)d=-d; a=($1+$2)/2; printf "%.2f", d/a*100}')
    
    printf "%-8s %-12s %-12s %-12s %-12s %-12s\n" "$temp" "$tphl_ps" "$tplh_ps" "$trise_ps" "$tfall_ps" "$skew"
done
echo "==============================================================="
