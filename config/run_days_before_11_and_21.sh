#!/bin/bash

# Verifica el día actual
day=$(date +%d)

# Días 8, 9, y 10 (tres días antes del 11 de cada mes)
if [[ "$day" == "08" || "$day" == "09" || "$day" == "10" ]]; then
    source /home/etl_agroclimatic_bulletins/env/bin/activate
    /home/WRF/EJECUTORES/RunWRF_JN_00.sh
fi

# Días 18, 19, y 20 (tres días antes del 21 de cada mes)
if [[ "$day" == "18" || "$day" == "19" || "$day" == "20" ]]; then
    source /home/etl_agroclimatic_bulletins/env/bin/activate
    /home/WRF/EJECUTORES/RunWRF_JN_00.sh
fi
