#!/bin/bash
# VDD Sweep — All Analysis

echo "==============================================================="
echo " VDD Sweep — Comprehensive Analysis"
echo " Wn=1.0, Wp=2.0, L=0.15, TT, 27°C, CL=10fF"
echo "==============================================================="

# Substitution values
substitute() {
    local file=$1
    local vdd=$2
    local vdd_half=$(echo "$vdd/2" | bc -l)
    sed -i "s/VDD_PLACEHOLDER/$vdd/g" $file
    sed -i "s/VDD_HALF_PLACEHOLDER/$vdd_half/g" $file
}

# =====================
# OP Analysis
# =====================
echo ""
echo "--- OP Analysis (leakage @ Vin=VDD) ---"
printf "%-8s %-16s %-16s %-16s\n" "VDD(V)" "vout(V)" "I_leak(A)" "Power(nW)"
echo "---------------------------------------------------------------"

for v in v162 v180 v198; do
    case $v in
        v162) vdd=1.62 ;;
        v180) vdd=1.80 ;;
        v198) vdd=1.98 ;;
    esac
    
    cp op_template.spice ${v}/op_${v}.spice
    substitute ${v}/op_${v}.spice $vdd
    
    cd ${v} && ngspice -b op_${v}.spice > op_log_${v}.log 2>&1 && cd ..
    
    vout=$(grep "v(vout)" ${v}/op_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    i=$(grep "v1#branch" ${v}/op_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    i_abs=$(echo "$i" | awk '{if($1<0) printf "%.3e", -$1; else printf "%.3e", $1}')
    power=$(echo "$i_abs $vdd" | awk '{printf "%.4f", $1*$2*1e9}')
    
    printf "%-8s %-16s %-16s %-16s\n" "$vdd" "$vout" "$i_abs" "$power"
done

# =====================
# DC Analysis
# =====================
echo ""
echo "--- DC Analysis (Vm, Gain) ---"
printf "%-8s %-12s %-12s %-12s %-12s %-12s\n" "VDD(V)" "Vm(V)" "Vm/VDD" "Gain" "VIL(V)" "VIH(V)"
echo "---------------------------------------------------------------"

for v in v162 v180 v198; do
    case $v in
        v162) vdd=1.62 ;;
        v180) vdd=1.80 ;;
        v198) vdd=1.98 ;;
    esac
    
    cp dc_template.spice ${v}/dc_${v}.spice
    substitute ${v}/dc_${v}.spice $vdd
    # Extra: fix the VDD/2 substitution
    vdd_half=$(echo "$vdd/2" | bc -l)
    sed -i "s|VDD_PLACEHOLDER/2|$vdd_half|g" ${v}/dc_${v}.spice
    
    cd ${v} && ngspice -b dc_${v}.spice > dc_log_${v}.log 2>&1 && cd ..
    
    vm=$(grep "vm " ${v}/dc_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    gmax=$(grep "gain_max" ${v}/dc_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    vil=$(grep "vil " ${v}/dc_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    vih=$(grep "vih " ${v}/dc_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    ratio=$(echo "$vm $vdd" | awk '{printf "%.3f", $1/$2}')
    
    printf "%-8s %-12s %-12s %-12s %-12s %-12s\n" "$vdd" "$vm" "$ratio" "$gmax" "$vil" "$vih"
done

# =====================
# Transient Analysis
# =====================
echo ""
echo "--- Transient Analysis (Delay) ---"
printf "%-8s %-12s %-12s %-12s\n" "VDD(V)" "tpHL(ps)" "tpLH(ps)" "Skew%"
echo "---------------------------------------------------------------"

for v in v162 v180 v198; do
    case $v in
        v162) vdd=1.62 ;;
        v180) vdd=1.80 ;;
        v198) vdd=1.98 ;;
    esac
    
    cp tran_template.spice ${v}/tran_${v}.spice
    substitute ${v}/tran_${v}.spice $vdd
    vdd_half=$(echo "$vdd/2" | bc -l)
    sed -i "s|VDD_PLACEHOLDER/2|$vdd_half|g" ${v}/tran_${v}.spice
    
    cd ${v} && ngspice -b tran_${v}.spice > tran_log_${v}.log 2>&1 && cd ..
    
    tphl=$(grep "^tphl " ${v}/tran_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    tplh=$(grep "^tplh " ${v}/tran_log_${v}.log | head -1 | awk -F'=' '{print $2}' | awk '{print $1}')
    
    tphl_ps=$(echo "$tphl" | awk '{printf "%.2f", $1*1e12}')
    tplh_ps=$(echo "$tplh" | awk '{printf "%.2f", $1*1e12}')
    skew=$(echo "$tphl_ps $tplh_ps" | awk '{d=$1-$2; if(d<0)d=-d; a=($1+$2)/2; printf "%.2f", d/a*100}')
    
    printf "%-8s %-12s %-12s %-12s\n" "$vdd" "$tphl_ps" "$tplh_ps" "$skew"
done

echo ""
echo "==============================================================="
echo " VDD Sweep Complete"
echo "==============================================================="
