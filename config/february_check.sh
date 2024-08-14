#!/bin/bash

# Verifica si el año es bisiesto
if [ $(date +%Y) -eq $(date +%Y -d "$(date +%Y)-02-29") ]; then
    # Año bisiesto: ejecutar el 29 de febrero
    if [ $(date +%d) -eq 29 ]; then
        source /home/etl_agroclimatic_bulletins/env/bin/activate
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh
    fi
else
    # Año no bisiesto: ejecutar el 26 de febrero
    if [ $(date +%d) -eq 26 ]; then
        source /home/etl_agroclimatic_bulletins/env/bin/activate
        /home/WRF/EJECUTORES/RunWRF_JN_00.sh
    fi
fi
