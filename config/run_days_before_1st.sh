#!/bin/bash

# Verifica el mes y el día actual
month=$(date +%m)
day=$(date +%d)

mkdir -p /home/output/logs

log_file="/home/output/logs/$(date '+%Y-%m-%d_%H-%M-%S').log"

# Meses con 31 días
if [[ "$month" =~ ^(01|03|05|07|08|10|12)$ ]]; then
    if [[ "$day" == "29" || "$day" == "30" || "$day" == "31" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando script..." >> "$log_file"
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh >> "$log_file" 2>&1
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script finalizado." >> "$log_file"
    fi

# Meses con 30 días
elif [[ "$month" =~ ^(04|06|09|11)$ ]]; then
    if [[ "$day" == "28" || "$day" == "29" || "$day" == "30" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando script..." >> "$log_file"
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh >> "$log_file" 2>&1
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script finalizado." >> "$log_file"
    fi
fi
