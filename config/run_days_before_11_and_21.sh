#!/bin/bash

# Verifica el día actual
day=$(date +%d)

mkdir -p /home/output/logs

log_file="/home/output/logs/$(date '+%Y-%m-%d_%H-%M-%S').log"

# Días 8, 9, y 10 (tres días antes del 11 de cada mes)
if [[ "$day" == "08" || "$day" == "09" || "$day" == "10" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando script..." >> "$log_file"
    /home/WRF/EJECUTORES/RunWRF_JN_00.sh >> "$log_file" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script finalizado." >> "$log_file"
fi

# Días 18, 19, y 20 (tres días antes del 21 de cada mes)
if [[ "$day" == "18" || "$day" == "19" || "$day" == "20" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando script..." >> "$log_file"
    /home/WRF/EJECUTORES/RunWRF_JN_00.sh >> "$log_file" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script finalizado." >> "$log_file"
fi
