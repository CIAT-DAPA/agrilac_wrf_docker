#!/bin/sh
EJEC_DESC="/home/WRF/gfs/bin/"
EJEC_WPS="/home/WRF/WPS-4.1"
EJEC_WRF="/home/WRF/WRF-4.1.2/run"
EJEC_ARWPost="/home/WRF/AUXILIARES/ARWpost"
EJEC_GRADS="/home/WRF/AUXILIARES/grads-1.8/grads-1.8/bin"
#DIR="/home/gfs"
#BINDIR=$DIR"/bin"
#WRFDIR=$DIR"/work"
#WRFDIR="/home/gfs/work"
WRFDIR="/home/WRF/gfs/GFS-grib2/DATA"
DATDIRWRF="/home/WRF/gfs/GFS-grib2"


fechaIni=`date +20%y%m%d`
YYMMDD=`date +%y%m%d`
YY=`date +%Y`
MM=`date +%m`
DD=`date +%d`


###############
P=12
PF=12
PL=240

dias=$(($PL/24))


YYf=`date --date='+'$dias' day' +%Y`
MMf=`date --date='+'$dias' day' +%m`
DDf=`date --date='+'$dias' day' +%d`


prefigWRFd1="wrfout_d01_"
prefigWRFd2="wrfout_d02_"
prefigWRFd3="wrfout_d03_"
posfigWRF="_12:00:00"


prefigARWd1="ARWout_d01_"
prefigARWd2="ARWout_d02_"
prefigARWd3="ARWout_d03_"

prefigGFS="GFS-grib2_ac_"

DOM1="d01"
DOM2="d02"
DOM3="d03"

fileInt="namelist.wps"
fileOut="namelistOut.wps"

echo "Comenzando a descargar los datos del GFS: `date`"
echo "Fecha "$fechaIni"."
cd $EJEC_DESC
bash get_gfs-grib2_CARIBE_54h-025.sh 12


cd $WRFDIR
rm GFS*
####Descomprimir Datos GFS###################
cp $DATDIRWRF"/"$prefigGFS$YY$MM$DD"12.tar.gz" $WRFDIR
cd $WRFDIR
tar -xzvf $prefigGFS$YY$MM$DD"12.tar.gz"
rm $prefigGFS$YY$MM$DD"12.tar.gz"
###############################################


cd $EJEC_WPS
rm met_em*
rm GFS:*
rm GRIBFILE*
echo "Haciendo link"    
./link_grib.csh $WRFDIR"/GFS-*"
echo "Terminado link"
echo "Editando fichero namelist.wps"
#############Editar fichero namelist.wps###########
cd $EJEC_WPS
sed -e '1,5s/ start_date = .*/ start_date = '\'''$YY'-'$MM'-'$DD'_12:00:00'\'','\'''$YY''-''$MM''-''$DD'_12:00:00'\'','\'''$YY'-'$MM'-'$DD'_12:00:00'\'','\'''$YY'-'$MM'-'$DD'_12:00:00'\'','\'''$YY'-'$MM'-'$DD'_12:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,5s/ end_date   = .*/ end_date   = '\'''$YYf'-'$MMf'-'$DDf'_12:00:00'\'','\'''$YYf''-''$MMf''-''$DDf'_12:00:00'\'','\'''$YYf'-'$MMf'-'$DDf'_12:00:00'\'','\'''$YYf'-'$MMf'-'$DDf'_12:00:00'\'','\'''$YYf'-'$MMf'-'$DDf'_12:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
##################################################
echo "Terminado editado fichero namelist.wps"
echo "Comenzando el ungrib"
./ungrib.exe
echo "Terminado el ungrib"
echo "Comenzando el metgrid"
./metgrid.exe
echo "Terminado el metgrid"
cd /home/WRF/gfs/GFS-grib2
#rm *.tar.gz


cd $EJEC_WRF
rm met_em*
echo "Haciendo ln a met_em"
ln -s /home/WRF/WPS-4.1/met_em* /home/WRF/WRF-4.1.2/run
echo "Terminado ln a met_em"
fileInt="namelist.input"
fileOut="namelistOut.input"
echo "Editando fichero namelist.input"
#############Editar fichero namelist.input###########
sed -e '1,20s/ start_year                          = .*/ start_year                          = '$YY', '$YY', '$YY', '$YY', '$YY',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ start_month                         = .*/ start_month                         = '$MM',   '$MM',   '$MM',   '$MM',   '$MM',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ start_day                           = .*/ start_day                           = '$DD',   '$DD',   '$DD',   '$DD',   '$DD',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ start_day                           = .*/ start_day                           = '$DD',   '$DD',   '$DD',   '$DD',   '$DD',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ start_hour                          = .*/ start_hour                          = '$P',   '$P',   '$P',   '$P',   '$P',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
################@@@@@@@@@@@@@@@@@@@@@#####################
sed -e '1,20s/ end_year                            = .*/ end_year                            = '$YYf', '$YYf', '$YYf', '$YYf', '$YYf',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_month                           = .*/ end_month                           = '$MMf',   '$MMf',   '$MMf',   '$MMf',   '$MMf',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_day                             = .*/ end_day                             = '$DDf',   '$DDf',   '$DDf',   '$DDf',   '$DDf',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_hour                            = .*/ end_hour                            = '$PF',   '$PF',   '$PF',   '$PF',   '$PF',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ interval_seconds                    = .*/ interval_seconds                    = '10800',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt



######################################################
echo "Terminado editado fichero namelist.input"
ulimit -s unlimited
echo "Corriendo el real"
./real.exe
echo "Termiando el real"

ulimit -s unlimited
echo "Corriendo el wrf"
#date

#/usr/local/slurm/bin/sbatch scrip-wrf.sh
ulimit -s unlimited

#nohup /home/WRF/COMPILER_gfortran/mpich2-install/bin/mpiexec.hydra -np 8 ./wrf.exe
nohup mpirun -np 12 ./wrf.exe


ulimit -s unlimited
echo "Copiando archivos para ARWPost"
cd $EJEC_ARWPost
mv $EJEC_WRF"/"$prefigWRFd1$YY"-"$MM"-"$DD$posfigWRF $EJEC_ARWPost
mv $EJEC_WRF"/"$prefigWRFd2$YY"-"$MM"-"$DD$posfigWRF $EJEC_ARWPost
mv $EJEC_WRF"/"$prefigWRFd3$YY"-"$MM"-"$DD$posfigWRF $EJEC_ARWPost
echo "Terminado copiando archivos para ARWPost"

fileInt="namelist.ARWpost"
fileOut="namelistOut.input"
############################################DOMINIO 1##############################################
echo "Editando fichero namelist.ARWpost"
#############Editar fichero namelist.ARWpost###########
sed -e '1,20s/ start_date = .*/ start_date = '\'''$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_date = .*/ end_date = '\'''$YYf'-'$MMf'-'$DDf'_06:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ input_root_name = .*/ input_root_name = '\'''$prefigWRFd1$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ output_root_name = .*/ output_root_name = '\'''\.''\\/''$prefigARWd1''$YY'-'$MM'-'$DD''\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
######################################################
echo "Terminado editando fichero namelist.ARWpost"
echo "Correindo el ARWpost"

ulimit -s unlimited
./ARWpost.exe

echo "Terninado de correr el ARWpost"
#rm wrfout*



fileInt="namelist.ARWpost"
fileOut="namelistOut.input"
############################################DOMINIO 1##############################################
echo "Editando fichero namelist.ARWpost"
#############Editar fichero namelist.ARWpost###########
sed -e '1,20s/ start_date = .*/ start_date = '\'''$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_date = .*/ end_date = '\'''$YYf'-'$MMf'-'$DDf'_06:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ input_root_name = .*/ input_root_name = '\'''$prefigWRFd2$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ output_root_name = .*/ output_root_name = '\'''\.''\\/''$prefigARWd2''$YY'-'$MM'-'$DD''\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
######################################################
echo "Terminado editando fichero namelist.ARWpost"
echo "Correindo el ARWpost"

ulimit -s unlimited
./ARWpost.exe

echo "Terninado de correr el ARWpost"




cd $EJEC_GRADS
fileInt="datos12_d01_Honduras_HRes.gs"
fileOut="datosOut_d01_Honduras_HRes.gs"
echo "Editando fichero datos.gs $DOM1"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'home'\\/'WRF'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd1$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################
echo "Terminado editando fichero datos.gs $DOM1"
echo "Haciendo datos con el GRADS"
grads -lcb "datos12_d01_Honduras_HRes.gs"



cd $EJEC_GRADS
fileInt="datos12_d02_Honduras_HRes.gs"
fileOut="datosOut_d02_Honduras_HRes.gs"
echo "Editando fichero datos.gs $DOM1"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'home'\\/'WRF'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd2$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################
echo "Terminado editando fichero datos.gs $DOM1"
echo "Haciendo datos con el GRADS"
grads -lcb "datos12_d02_Honduras_HRes.gs

exit

cd $EJEC_GRADS
fileInt="datos00_d01_CAVILA_HRes.gs"
fileOut="datosOut_d01_CAVILA_HRes.gs"
echo "Editando fichero datos.gs $DOM1"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'home'\\/'WRF'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd1$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################
echo "Terminado editando fichero datos.gs $DOM1"
echo "Haciendo datos con el GRADS"
grads -lcb "datos00_d01_CAVILA_HRes.gs"


cd $EJEC_GRADS
fileInt="datos00_d01_CMW_HRes.gs"
fileOut="datosOut_d01_CMW_HRes.gs"
echo "Editando fichero datos.gs $DOM1"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'home'\\/'WRF'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd1$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################
echo "Terminado editando fichero datos.gs $DOM1"
echo "Haciendo datos con el GRADS"
grads -lcb "datos00_d01_CMW_HRes.gs"


cd $EJEC_GRADS
fileInt="datos00_d01_CA_HRes.gs"
fileOut="datosOut_d01_CA_HRes.gs"
echo "Editando fichero datos.gs $DOM1"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'home'\\/'WRF'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd1$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################
echo "Terminado editando fichero datos.gs $DOM1"
echo "Haciendo datos con el GRADS"
grads -lcb "datos00_d01_CA_HRes.gs"


cd $EJEC_GRADS
fileInt="datos00_d01_LaISLA_HRes.gs"
fileOut="datosOut_d01_LaISLA_HRes.gs"
echo "Editando fichero datos.gs $DOM1"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'home'\\/'WRF'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd1$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################
echo "Terminado editando fichero datos.gs $DOM1"
echo "Haciendo datos con el GRADS"
grads -lcb "datos00_d01_LaISLA_HRes.gs"



###################################################################################################
#############################################DOMINIO 2############################################
#rm /home/WRF/AUXILIARES/ARWpost/ARWout_d01*


#cd /home/WRF/SALIDAS_MAPAS-00/CUBA
#tar -zcvf WRF-CUBA-00_Precip.tar.gz PRECIPITACIONES_VTO ACUM_PREC
#tar -zcvf WRF-CUBA-00_Temp.tar.gz TEMPERATURA
#tar -zcvf WRF-CUBA-00_IndiceK.tar.gz INDICE-K


cd /home/WRF/SALIDAS_MAPAS-00/PRECIPITACIONES_VTO

convert -delay 100 -quality 20 -size 200 -loop 0 Precipitaciones_03.png Precipitaciones_06.png Precipitaciones_09.png Precipitaciones_12.png Precipitaciones_15.png Precipitaciones_18.png Precipitaciones_21.png Precipitaciones_24.png Precipitaciones_27.png Precipitaciones_30.png Precipitaciones_33.png Precipitaciones_36.png Precipitaciones_39.png Precipitaciones_42.png Precipitaciones_45.png Precipitaciones_48.png Precipitaciones_51.png Precipitaciones_54.png PrecAnimadaL_Ini_00UTC.gif

convert -delay 30 -quality 20 -size 200 -loop 0 Precipitaciones_03.png Precipitaciones_06.png Precipitaciones_09.png Precipitaciones_12.png Precipitaciones_15.png Precipitaciones_18.png Precipitaciones_21.png Precipitaciones_24.png Precipitaciones_27.png Precipitaciones_30.png Precipitaciones_33.png Precipitaciones_36.png Precipitaciones_39.png Precipitaciones_42.png Precipitaciones_45.png Precipitaciones_48.png Precipitaciones_51.png Precipitaciones_54.png PrecAnimadaR_Ini_00UTC.gif

echo "Salida del modelo WRF-00_PreciRegSaludos" | mail -s "WRF-00_Prec-Caribe_Animada" -A "PrecAnimadaL_Ini_00UTC.gif" -A "PrecAnimadaR_Ini_00UTC.gif" pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,capotecuevas1953@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

echo "Salida del modelo WRF-00_PreciRegSaludos" | mail -s "WRF-00_Prec-Caribe" -A "Precipitaciones_12.png" -A "Precipitaciones_15.png" -A "Precipitaciones_18.png" -A "Precipitaciones_21.png" -A "Precipitaciones_24.png" -A "Precipitaciones_27.png" -A  "Precipitaciones_30.png" -A "Precipitaciones_33.png" -A "Precipitaciones_36.png" -A "Precipitaciones_39.png" -A "Precipitaciones_42.png" -A  "Precipitaciones_45.png" -A "Precipitaciones_48.png" -A "Precipitaciones_51.png" -A "Precipitaciones_54.png" aldomoya00@gmail.com,pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,capotecuevas1953@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/CUBA/HR_850-500
echo "Salida del modelo WRF-00_HR_850-500. Saludos" | mail -s "WRF-00_HR_850-500_CUBA" -A "HR850-500_18.png" -A "HR850-500_24.png" -A "HR850-500_42.png" -A "HR850-500_48.png" -A "HR850-500_54.png" pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/CUBA/INDICE-K
echo "Salida del modelo WRF-00_IndiceK. Saludos" | mail -s "WRF-00_IndiceK-CUBA" -A "IK_12.png" -A "IK_21.png" -A "IK_24.png" -A "IK_36.png" -A "IK_45.png" -A "IK_48.png" -A "IK_54.png" freddysebastianruizarias@gmail.com,pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/CUBA/PRECIPITACIONES_VTO

convert -delay 100 -quality 20 -size 200 -loop 0 Precipitaciones_03.png Precipitaciones_06.png Precipitaciones_09.png Precipitaciones_12.png Precipitaciones_15.png Precipitaciones_18.png Precipitaciones_21.png Precipitaciones_24.png Precipitaciones_27.png Precipitaciones_30.png Precipitaciones_33.png Precipitaciones_36.png Precipitaciones_39.png Precipitaciones_42.png Precipitaciones_45.png Precipitaciones_48.png Precipitaciones_51.png Precipitaciones_54.png PrecAnimadaL_Ini_00UTC.gif

convert -delay 30 -quality 20 -size 200 -loop 0 Precipitaciones_03.png Precipitaciones_06.png Precipitaciones_09.png Precipitaciones_12.png Precipitaciones_15.png Precipitaciones_18.png Precipitaciones_21.png Precipitaciones_24.png Precipitaciones_27.png Precipitaciones_30.png Precipitaciones_33.png Precipitaciones_36.png Precipitaciones_39.png Precipitaciones_42.png Precipitaciones_45.png Precipitaciones_48.png Precipitaciones_51.png Precipitaciones_54.png PrecAnimadaR_Ini_00UTC.gif

echo "Salida del modelo WRF-00_PrecipCUBASaludos" | mail -s "WRF-00_Prec-CUBA_Animada" -A "PrecAnimadaL_Ini_00UTC.gif" -A "PrecAnimadaR_Ini_00UTC.gif" aldomoya00@gmail.com,pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,capotecuevas1953@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

echo "Salida del modelo WRF-00_PrecipCUBASaludos" | mail -s "WRF-00_Prec-CUBA" -A "Precipitaciones_12.png" -A "Precipitaciones_15.png" -A "Precipitaciones_18.png" -A "Precipitaciones_21.png" -A "Precipitaciones_24.png" -A "Precipitaciones_27.png" -A  "Precipitaciones_30.png" -A "Precipitaciones_33.png" -A "Precipitaciones_36.png" -A "Precipitaciones_39.png" -A "Precipitaciones_42.png" -A  "Precipitaciones_45.png" -A "Precipitaciones_48.png" -A "Precipitaciones_51.png" -A "Precipitaciones_54.png" aldomoya00@gmail.com,pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,capotecuevas1953@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/CUBA/TEMPERATURA
echo "Salida del modelo WRF-00_TempCUBA. Saludos" | mail -s "WRF-00_Temp-CUBA" -A "T_2m_12.png" -A "T_2m_15.png" -A "T_2m_18.png" -A "T_2m_21.png" -A "T_2m_24.png" -A "T_2m_27.png" -A "T_2m_30.png" -A  "T_2m_33.png" -A "T_2m_36.png" -A  "T_2m_39.png" -A "T_2m_42.png" -A "T_2m_45.png" -A "T_2m_48.png" -A "T_2m_51.png" -A "T_2m_54.png" aldomoya00@gmail.com,pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,capotecuevas1953@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/CUBA/MAX_DBZ
echo "Salida del modelo WRF-00_MaxDBZCUBA. Saludos" | mail -s "WRF-00_MaxDBZ-CUBA" -A "Max_DBZ_12.png" -A "Max_DBZ_15.png" -A "Max_DBZ_18.png" -A "Max_DBZ_21.png" -A "Max_DBZ_24.png" -A "Max_DBZ_27.png" -A "Max_DBZ_30.png" -A  "Max_DBZ_33.png" -A "Max_DBZ_36.png" -A  "Max_DBZ_39.png" -A "Max_DBZ_42.png" -A "Max_DBZ_45.png" -A "Max_DBZ_48.png" -A "Max_DBZ_51.png" -A "Max_DBZ_54.png" aldomoya00@gmail.com,pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,capotecuevas1953@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/CUBA/ACUM_PREC
echo "Salida del modelo WRF-00_PrecipCUBA-ACUM. Saludos" | mail -s "WRF-00_PrecACUM-CUBA" -A "Precipitaciones_36.png" aldomoya00@gmail.com,pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,regueiramolina@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,miguelkbz64@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,cmpcienfuegos@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,capotecuevas1953@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com,juliomartinr03@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/CUBA/VIENTO/VIENTO_SUP
echo "Salida del modelo WRF-00_VientoS. Saludos" | mail -s "WRF-00_VtoSup-CUBA" -A "FV_10m_12.png" -A "FV_10m_15.png" -A "FV_10m_18.png" -A "FV_10m_21.png" -A "FV_10m_24.png" -A "FV_10m_27.png" -A "FV_10m_30.png" -A  "FV_10m_33.png" -A "FV_10m_36.png" -A "FV_10m_39.png" -A "FV_10m_42.png" -A "FV_10m_45.png" -A "FV_10m_48.png" -A "FV_10m_51.png" -A "FV_10m_54.png" pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,alvy940919@gmail.com,pronostico@ssp.insmet.cu,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,miguelkbz64@gmail.com,jglezdom89@gmail.com,edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,juliomartinr03@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,yuniesky2323@gmail.com,pronosticoij@gmail.com,bryamvaldes2508@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu,luisenriquegarcia1201@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CAVILA/PRECIPITACIONES_VTO
echo "Salida del modelo WRF-00_PrecipSaludos" | mail -s "WRF-00_Prec-RegCentral" -A "Precipitaciones_12.png" -A "Precipitaciones_15.png" -A "Precipitaciones_18.png" -A "Precipitaciones_21.png" -A "Precipitaciones_24.png" -A "Precipitaciones_27.png" -A  "Precipitaciones_30.png" -A "Precipitaciones_33.png" -A "Precipitaciones_36.png" -A "Precipitaciones_39.png" -A "Precipitaciones_42.png" -A  "Precipitaciones_45.png" -A "Precipitaciones_48.png" -A "Precipitaciones_51.png" -A "Precipitaciones_54.png" pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,capotecuevas1953@gmail.com,juliomartinr03@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,luisenriquegarcia1201@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CAVILA/TEMPERATURA
echo "Salida del modelo WRF-00_Temp. Saludos" | mail -s "WRF-00_Temp-RegCentral" -A "T_2m_12.png" -A "T_2m_15.png" -A "T_2m_18.png" -A "T_2m_21.png" -A "T_2m_24.png" -A "T_2m_27.png" -A "T_2m_30.png" -A  "T_2m_33.png" -A "T_2m_36.png" -A  "T_2m_39.png" -A "T_2m_42.png" -A "T_2m_45.png" -A "T_2m_48.png" -A "T_2m_51.png" -A "T_2m_54.png" pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,capotecuevas1953@gmail.com,juliomartinr03@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,luisenriquegarcia1201@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CAVILA/VIENTO/VIENTO_SUP
echo "Salida del modelo WRF-00_VientoS. Saludos" | mail -s "WRF-00_VtoSup-RegCentral" -A "FV_10m_12.png" -A "FV_10m_15.png" -A "FV_10m_18.png" -A "FV_10m_21.png" -A "FV_10m_24.png" -A "FV_10m_27.png" -A "FV_10m_30.png" -A  "FV_10m_33.png" -A "FV_10m_36.png" -A "FV_10m_39.png" -A "FV_10m_42.png" -A "FV_10m_45.png" -A "FV_10m_48.png" -A "FV_10m_51.png" -A "FV_10m_54.png" pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,juliomartinr03@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,luisenriquegarcia1201@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CAVILA/ACUM_PREC
echo "Salida del modelo WRF-00_PrecipACUM. Saludos" | mail -s "WRF-00_PrecACUM-RegCentral" -A "Precipitaciones_36.png" pronostico@cav.insmet.cu,msccordova@gmail.com,obenedicor@gmail.com,freddysebastianruizarias@gmail.com,regueiramolina@gmail.com,bbfonseca437@gmail.com,alvy940919@gmail.com,vladimirleon045@gmail.com,yosmelvispaezcornell@gmail.com,pronostico@vcl.insmet.cu,amaury.machado42@gmail.com,regueiramolina@gmail.com,cmpcienfuegos@gmail.com,capotecuevas1953@gmail.com,juliomartinr03@gmail.com,pronosticossp73@gmail.com,andres.escalonafaure1962@gmail.com,victormanuel8916@gmail.com,wchv7072@gmail.com,roislanperezaguero@gmail.com,frankcubafc@gmail.com,luisenriquegarcia1201@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_LaISLA/PRECIPITACIONES_VTO
echo "Salida del modelo WRF-00_PrecipSaludos" | mail -s "WRF-00_Prec-RegOccidental" -A "Precipitaciones_12.png" -A "Precipitaciones_15.png" -A "Precipitaciones_18.png" -A "Precipitaciones_21.png" -A "Precipitaciones_24.png" -A "Precipitaciones_27.png" -A  "Precipitaciones_30.png" -A "Precipitaciones_33.png" -A "Precipitaciones_36.png" -A "Precipitaciones_39.png" -A "Precipitaciones_42.png" -A  "Precipitaciones_45.png" -A "Precipitaciones_48.png" -A "Precipitaciones_51.png" -A "Precipitaciones_54.png" edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,pronosticoij@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_LaISLA/TEMPERATURA
echo "Salida del modelo WRF-00_Temp. Saludos" | mail -s "WRF-00_Temp-RegOccidental" -A "T_2m_12.png" -A "T_2m_15.png" -A "T_2m_18.png" -A "T_2m_21.png" -A "T_2m_24.png" -A "T_2m_27.png" -A "T_2m_30.png" -A  "T_2m_33.png" -A "T_2m_36.png" -A  "T_2m_39.png" -A "T_2m_42.png" -A "T_2m_45.png" -A "T_2m_48.png" -A "T_2m_51.png" -A "T_2m_54.png" edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,pronosticoij@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_LaISLA/VIENTO/VIENTO_SUP
echo "Salida del modelo WRF-00_VientoS. Saludos" | mail -s "WRF-00_VtoSup-RegOccidental" -A "FV_10m_12.png" -A "FV_10m_15.png" -A "FV_10m_18.png" -A "FV_10m_21.png" -A "FV_10m_24.png" -A "FV_10m_27.png" -A "FV_10m_30.png" -A  "FV_10m_33.png" -A "FV_10m_36.png" -A "FV_10m_39.png" -A "FV_10m_42.png" -A "FV_10m_45.png" -A "FV_10m_48.png" -A "FV_10m_51.png" -A "FV_10m_54.png" edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,pronosticoij@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_LaISLA/ACUM_PREC
echo "Salida del modelo WRF-00_PrecipACUM. Saludos" | mail -s "WRF-00_PrecACUM-RegOccidental" -A "Precipitaciones_36.png" edgardosoler2@gmail.com,luis.sanchez0868111@gmail.com,pronosticoij@gmail.com,hracosta1990@gmail.com,alfredo71cu@gmail.com,sanjuan@pri.insmet.cu

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CMW/PRECIPITACIONES_VTO
echo "Salida del modelo WRF-00_Precip. Saludos" | mail -s "WRF-00_Prec-RegCamawey" -A "Precipitaciones_12.png" -A "Precipitaciones_15.png" -A "Precipitaciones_18.png" -A "Precipitaciones_21.png" -A "Precipitaciones_24.png" -A "Precipitaciones_27.png" -A "Precipitaciones_30.png" -A "Precipitaciones_33.png" -A  "Precipitaciones_36.png" -A "Precipitaciones_39.png" -A  "Precipitaciones_42.png" -A  "Precipitaciones_45.png" -A "Precipitaciones_48.png" -A "Precipitaciones_51.png" -A "Precipitaciones_54.png" yosmelvispaezcornell@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CMW/TEMPERATURA
echo "Salida del modelo WRF-00_Temp. Saludos" | mail -s "WRF-00_Temp-RegCamawey" -A "T_2m_12.png" -A "T_2m_15.png" -A "T_2m_18.png" -A "T_2m_21.png" -A "T_2m_24.png" -A "T_2m_27.png" -A "T_2m_30.png" -A "T_2m_33.png" -A "T_2m_36.png" -A "T_2m_39.png" -A "T_2m_42.png" -A "T_2m_45.png" -A "T_2m_48.png" -A "T_2m_51.png" -A "T_2m_54.png" yosmelvispaezcornell@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CMW/VIENTO/VIENTO_SUP
echo "Salida del modelo WRF-00_VientoS. Saludos" | mail -s "WRF-00_VtoSup-RegCamawey" -A "FV_10m_12.png -A "FV_10m_15.png" -A "FV_10m_18.png" -A "FV_10m_21.png" -A "FV_10m_24.png" -A "FV_10m_27.png" -A "FV_10m_30.png" -A "FV_10m_33.png" -A "FV_10m_36.png" -A "FV_10m_39.png" -A "FV_10m_42.png" -A "FV_10m_45.png" -A "FV_10m_48.png" -A "FV_10m_51.png" -A "FV_10m_54.png" yosmelvispaezcornell@gmail.com

cd /home/WRF/SALIDAS_MAPAS-00/SALIDAS_CMW/ACUM_PREC
echo "Salida del modelo WRF-00_PrecipACUM. Saludos" | mail -s "WRF-00_PrecACUM-RegCamawey" -A "Precipitaciones_36.png" yosmelvispaezcornell@gmail.com


exit

cd $EJEC_ARWPost

fileInt="namelist.ARWpost"
fileOut="namelistOut.input"
echo "Editando fichero namelist.ARWpost"
#############Editar fichero namelist.ARWpost###########
sed -e '1,20s/ start_date = .*/ start_date = '\'''$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_date = .*/ end_date = '\'''$YYf'-'$MMf'-'$DDf'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ input_root_name = .*/ input_root_name = '\'''$prefigWRFd2$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ output_root_name = .*/ output_root_name = '\'''\.''\\/''$prefigARWd2''$YY'-'$MM'-'$DD''\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
######################################################
echo "Terminado editando fichero namelist.ARWpost"
echo "Correindo el ARWpost"

ulimit -s unlimited
./ARWpost.exe

echo "Terninado de correr el ARWpost"

cd $EJEC_GRADS
fileInt="datos00_d02.gs"
fileOut="datosOut_d02.gs"
echo "Editando fichero datos.gs $DOM2"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'data'\\/'users'\\/'amoya'\\/'WRF_PERU'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd2$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################

###################
echo "Terminado editando fichero datos.gs $DOM2"
echo "Haciendo datos con el GRADS"

grads -lcb "datos00_d02.gs"




cd $EJEC_ARWPost

fileInt="namelist.ARWpost"
fileOut="namelistOut.input"
echo "Editando fichero namelist.ARWpost"
#############Editar fichero namelist.ARWpost###########
sed -e '1,20s/ start_date = .*/ start_date = '\'''$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_date = .*/ end_date = '\'''$YYf'-'$MMf'-'$DDf'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ input_root_name = .*/ input_root_name = '\'''$prefigWRFd3$YY'-'$MM'-'$DD'_00:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
##
sed -e '1,20s/ output_root_name = .*/ output_root_name = '\'''\.''\\/''$prefigARWd3''$YY'-'$MM'-'$DD''\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
######################################################
echo "Terminado editando fichero namelist.ARWpost"
echo "Correindo el ARWpost"

ulimit -s unlimited
./ARWpost.exe


echo "Terninado de correr el ARWpost"

cd $EJEC_GRADS
fileInt="datos00_d03.gs"
fileOut="datosOut_d03.gs"
echo "Editando fichero datos.gs $DOM2"
#############Editar fichero datos.gs###################
sed -e '1,3s/.*open .*/'\''open '\\/'data'\\/'users'\\/'amoya'\\/'WRF_PERU'\\/'AUXILIARES'\\/'ARWpost'\\/''$prefigARWd3$YY'-'$MM'-'$DD'.ctl'\''''/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
###################

###################
echo "Terminado editando fichero datos.gs $DOM2"
echo "Haciendo datos con el GRADS"

grads -lcb "datos00_d03.gs"



exit



















