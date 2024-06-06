#!/bin/sh
#-------------------------------------------------------------------------------------
# Script para descargar datos GFS a 0.5º (grib2) de http://nomads.ncep.noaa.gov/
# RAM	noviembre 2010
#-------------------------------------------------------------------------------------
# NOTA: utilitza l'aplicativo http://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_hd.pl 
#       donde hay la lista de VARS y LEVS disponibles
#       Para + info consultar tambien:
#           http://www.nco.ncep.noaa.gov/pmb/products/gfs/gfs.t00z.pgrb2f00.shtml
#       Los datos estan tambien en los servidores del NCO (NCEP Central Operations):
#           http://www.ftp.ncep.noaa.gov/data/nccf/com/gfs/prod
#           ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/gfs/prod
#       (pero sin opcion para recortar dominios)
#-------------------------------------------------------------------------------------

# directorios
DIR="/home/WRF/gfs"
BINDIR=$DIR"/bin"
WRKDIR=$DIR"/work"
DATDIR=$DIR"/GFS-grib2"
#DATDIR="/data/GFS-grib2"

# ejecutables
#CURL="/usr/bin/curl -# -U modelos:Mecpt125 -x 172.20.1.2:3128"
CURL="/usr/bin/curl -#"
WGRIB2="/home/WRF/gfs/bin/wgrib2"

# comprueba argumentos
if (test $# -eq 1) then
  HH=$1
  YYMMDD=`date +%y%m%d`
  tmax=`date +%s -d "6 hour"`
  iini=0
elif (test $# -eq 2) then
  HH=$1
  YYMMDD=$2
  tmax=`date +%s -d "6 hour"`
  iini=0
elif (test $# -eq 3) then
  HH=$1
  YYMMDD=$2
  iini=$3
  tmax=`date +%s -d "6 hour"`
else 
  echo "Uso: $0 HH"
  echo "     $0 HH YYMMDD"
  echo "     $0 HH YYMMDD I"
  echo "     (donde HH puede ser 00, 06, 12 i 18)"
  echo "     (donde I es el fichero inicial a descargar"
  echo
  exit
fi

DATE1=`date +%Y%m%d%H -d "$YYMMDD $HH"`
DATE=`date +%Y%m%d -d "$YYMMDD"`

# Parametros ficheros GRIB (modificar en caso de nuevas variables 

#URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p50.pl?file=gfs.t"$HH"z.pgrb2full.0p50.f0"
URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t"$HH"z.pgrb2.0p25.f0"
#URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t"$HH"z.pgrb2.1p00.f0"
#URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?dir=%2Fgfs.20210421%2F00%2Fatmos?file=gfs.t"$HH"z.pgrb2.1p00.f0"

if (test $HH == "09") then
    HR=(00 12 24 36 48)
else
    HR=(00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99)
# 102 105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 153 156 159 162 165 168 171 174 177 180 183 186 189 192 195 198 201 204 207 210 213 216 219 222 225 228 231 234 237 240 243 246 249 252 255 258 261 264 267 270 273 276 279 282 285 288 291 294 297 300 303 306 309 312 315 318 321 324 327 330 333 336 339 342 345 348 351 354 357 360 363 366 369 372 375 378 381 384)
#   HR=(00 03)
fi
#variables de configuración de descarga
LEVS="&lev_0-0.1_m_below_ground=on&lev_0.1-0.4_m_below_ground=on&lev_0.4-1_m_below_ground=on&lev_1000_mb=on&lev_100_mb=on&lev_10_m_above_ground=on&lev_1-2_m_below_ground=on&lev_150_mb=on&lev_200_mb=on&lev_250_mb=on&lev_2_m_above_ground=on&lev_300_mb=on&lev_350_mb=on&lev_400_mb=on&lev_450_mb=on&lev_500_mb=on&lev_50_mb=on&lev_550_mb=on&lev_600_mb=on&lev_650_mb=on&lev_700_mb=on&lev_70_mb=on&lev_750_mb=on&lev_800_mb=on&lev_850_mb=on&lev_900_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&lev_mean_sea_level=on&lev_surface"
VARS="=on&var_HGT=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SOILW=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_APCP=on&var_ACPCP=on&var_TSOIL=on&var_LAND"
#AREA="=on&subregion=&leftlon=-170&rightlon=10&toplat=60&bottomlat=-70"
AREA="=on&subregion=&leftlon=-120&rightlon=-50&toplat=35&bottomlat=-5"
#DIR="&dir=%2Fgfs."$DATE
dir0="atmos"
DIR="&dir=%2Fgfs."$DATE"%2F"$HH"%2F"$dir0
#DIR=&dir=%2Fgfs.20210421%2F00%2Fatmos

campos="0"	# Numero total de campos de cada fichero grib 
		# Si modificamos VARS y NIVS se debe recalcular
                # 132 para el primer plazo y 134 para el resto
# INICIO

cd $WRKDIR
  if [ $iini -eq 0 ]; then
  rm -f GFS-grib2*
  fi
  echo "INICIO DESCARGA: `date`"

  i=$iini  
  len=${#HR[*]}
  while [ $i -lt $len ]; do
    time=`date +%s`
    if [ $time -lt $tmax ]; then
      FILE="GFS-grib2_"$HH"_"${HR[$i]}"_"$YYMMDD"_ac"
      echo  `date +%H:%M`" -----> Descargando ($i) $FILE "
      #echo $URL""${HR[$i]}""$LEVS""$VARS""$AREA""$DIR
      $CURL -f -s $URL""${HR[$i]}""$LEVS""$VARS""$AREA""$DIR -o "grib.tmp"
      #echo "No me supe explicar."
      ############ Mi code
       # dt=`$WGRIB2 grib.tmp`
       # mv grib.tmp $FILE 
       # echo $dt
      ##############################
      if [ -f grib.tmp ]; then
        aux=`$WGRIB2 grib.tmp|wc -l`        
	if (test $i -ne 0) then
          campos="0"
	fi        
        if [ $aux -ge $campos ]; then
	  mv grib.tmp $FILE
          let i++
        else
          echo "WARNING! Fichero $FILE incompleto, esperaba que la cantidad de campos fuera de $campos y hay una cantidad de $aux"
          sleep 10
        fi
      else
        echo "WARNING! No ha descargado el fichero $FILE"
        sleep 60
      fi      
      rm -f grib.tmp
    else
      echo "ERROR! Descarga incompleta por superarse el tiempo de $tmax"
      exit
    fi
   done

#URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p50.pl?file=gfs.t"$HH"z.pgrb2full.0p50.f0"
URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t"$HH"z.pgrb2.0p25.f"
#URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?file=gfs.t"$HH"z.pgrb2.1p00.f0"
#URL="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_1p00.pl?dir=%2Fgfs.20210421%2F00%2Fatmos?file=gfs.t"$HH"z.pgrb2.1p00.f0"

if (test $HH == "09") then
    HR=(00 12 24 36 48)
else
	HR=(102) #105 108 111 114 117 120 123 126 129 132 135 138 141 144 147 150 153 156 159 162 165 168 171 174 177 180 183 186 189 192 195 198 201 204 207 210 213 216 219 222 225 228 231 234 237 240 243 246 249 252 255 258 261 264)
   #267 270 273 276 279 282 285 288 291 294 297 300 303 306 309 312 315 318 321 324 327 330 333 336 339 342 345 348 351 354 357 360 363 366 369 372 375 378 381 384)
#   HR=(00 03)
fi
#variables de configuración de descarga
LEVS="&lev_0-0.1_m_below_ground=on&lev_0.1-0.4_m_below_ground=on&lev_0.4-1_m_below_ground=on&lev_1000_mb=on&lev_100_mb=on&lev_10_m_above_ground=on&lev_1-2_m_below_ground=on&lev_150_mb=on&lev_200_mb=on&lev_250_mb=on&lev_2_m_above_ground=on&lev_300_mb=on&lev_350_mb=on&lev_400_mb=on&lev_450_mb=on&lev_500_mb=on&lev_50_mb=on&lev_550_mb=on&lev_600_mb=on&lev_650_mb=on&lev_700_mb=on&lev_70_mb=on&lev_750_mb=on&lev_800_mb=on&lev_850_mb=on&lev_900_mb=on&lev_925_mb=on&lev_950_mb=on&lev_975_mb=on&lev_mean_sea_level=on&lev_surface"
VARS="=on&var_HGT=on&var_PRES=on&var_PRMSL=on&var_RH=on&var_SOILW=on&var_TMP=on&var_UGRD=on&var_VGRD=on&var_APCP=on&var_ACPCP=on&var_TSOIL=on&var_LAND"
#AREA="=on&subregion=&leftlon=-170&rightlon=10&toplat=60&bottomlat=-70"
AREA="=on&subregion=&leftlon=-120&rightlon=-50&toplat=35&bottomlat=-5"
#DIR="&dir=%2Fgfs."$DATE
dir0="atmos"
DIR="&dir=%2Fgfs."$DATE"%2F"$HH"%2F"$dir0
#DIR=&dir=%2Fgfs.20210421%2F00%2Fatmos

campos="0"	# Numero total de campos de cada fichero grib 
		# Si modificamos VARS y NIVS se debe recalcular
                # 132 para el primer plazo y 134 para el resto
# INICIO

cd $WRKDIR
  #if [ $iini -eq 0 ]; then
  #rm -f GFS-grib2*
  #fi
  echo "INICIO DESCARGA: `date`"

  i=$iini  
  len=${#HR[*]}
  while [ $i -lt $len ]; do
    time=`date +%s`
    if [ $time -lt $tmax ]; then
      FILE="GFS-grib2_"$HH"_"${HR[$i]}"_"$YYMMDD"_ac"
      echo  `date +%H:%M`" -----> Descargando ($i) $FILE "
      #echo $URL""${HR[$i]}""$LEVS""$VARS""$AREA""$DIR
      $CURL -f -s $URL""${HR[$i]}""$LEVS""$VARS""$AREA""$DIR -o "grib.tmp"
      #echo "No me supe explicar."
      ############ Mi code
       # dt=`$WGRIB2 grib.tmp`
       # mv grib.tmp $FILE 
       # echo $dt
      ##############################
      if [ -f grib.tmp ]; then
        aux=`$WGRIB2 grib.tmp|wc -l`        
	if (test $i -ne 0) then
          campos="0"
	fi        
        if [ $aux -ge $campos ]; then
	  mv grib.tmp $FILE
          let i++
        else
          echo "WARNING! Fichero $FILE incompleto, esperaba que la cantidad de campos fuera de $campos y hay una cantidad de $aux"
          sleep 10
        fi
      else
        echo "WARNING! No ha descargado el fichero $FILE"
        sleep 60
      fi      
      rm -f grib.tmp
    else
      echo "ERROR! Descarga incompleta por superarse el tiempo de $tmax"
      exit
    fi
   done


  
  echo "FINAL DESCARGA: `date`"


     
    tar -cvzf "GFS-grib2_ac_"$DATE1".tar.gz" GFS-*

    echo "cp -f "GFS-grib2_ac_"$DATE1".tar.gz" $DATDIR"/""
    cp -f "GFS-grib2_ac_"$DATE1".tar.gz" $DATDIR"/"

  

echo "FINAL: `date`"
#/home/wrf/SCR_EJECUTA_WRF/RunWRF_$HH.sh
exit
