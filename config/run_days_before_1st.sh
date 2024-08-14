#!/bin/bash

# Verifica el mes y el día actual
month=$(date +%m)
day=$(date +%d)

# Meses con 31 días
if [[ "$month" =~ ^(01|03|05|07|08|10|12)$ ]]; then
    if [[ "$day" == "29" || "$day" == "30" || "$day" == "31" ]]; then
        source /home/etl_agroclimatic_bulletins/env/bin/activate
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh
    fi

# Meses con 30 días
elif [[ "$month" =~ ^(04|06|09|11)$ ]]; then
    if [[ "$day" == "28" || "$day" == "29" || "$day" == "30" ]]; then
        source /home/etl_agroclimatic_bulletins/env/bin/activate
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh
    fi
fi
