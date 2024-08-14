#!/bin/bash

mkdir -p /home/output/logs

log_file="/home/output/logs/$(date '+%Y-%m-%d_%H-%M-%S').log"

# Verifica si el año es bisiesto
if [ $(date +%Y) -eq $(date +%Y -d "$(date +%Y)-02-29") ]; then
    # Año bisiesto: ejecutar el 29 de febrero
    if [ $(date +%d) -eq 29 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando script..." >> "$log_file"
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh >> "$log_file" 2>&1
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script finalizado." >> "$log_file"
    fi
else
    # Año no bisiesto: ejecutar el 26 de febrero
    if [ $(date +%d) -eq 26 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando script..." >> "$log_file"
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh >> "$log_file" 2>&1
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script finalizado." >> "$log_file"
    fi
fi
