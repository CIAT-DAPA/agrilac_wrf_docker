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
OUTPUT_PATH="/home/output"


fechaIni=`date +20%y%m%d`
YYMMDD=`date +%y%m%d`
YY=`date +%Y`
MM=`date +%m`
DD=`date +%d`

#YY=2024
#MM=06
#DD=07

###############
P=12
PF=12
PL=240

dias=$(($PL/24))


YYf=`date --date='+'$dias' day' +%Y`
MMf=`date --date='+'$dias' day' +%m`
DDf=`date --date='+'$dias' day' +%d`

#YYf=2024
#MMf=06
#DDf=08



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

########CREATE OUTPUTS FOLDER####################
mkdir -p $OUTPUT_PATH"/wrf"
mkdir -p $OUTPUT_PATH"/grads"
mkdir -p $OUTPUT_PATH"/postprocessing"
mkdir -p $OUTPUT_PATH"/data"
mkdir -p $OUTPUT_PATH"/shapefile"


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
cp $EJEC_WRF"/"$prefigWRFd1$YY"-"$MM"-"$DD$posfigWRF $OUTPUT_PATH"/wrf/"$prefigWRFd1$YY"-"$MM"-"$DD$posfigWRF".nc"
cp $EJEC_WRF"/"$prefigWRFd2$YY"-"$MM"-"$DD$posfigWRF $OUTPUT_PATH"/wrf/"$prefigWRFd2$YY"-"$MM"-"$DD$posfigWRF".nc"
cp $EJEC_WRF"/"$prefigWRFd3$YY"-"$MM"-"$DD$posfigWRF $OUTPUT_PATH"/wrf/"$prefigWRFd3$YY"-"$MM"-"$DD$posfigWRF".nc"

mv $EJEC_WRF"/"$prefigWRFd1$YY"-"$MM"-"$DD$posfigWRF $EJEC_ARWPost
mv $EJEC_WRF"/"$prefigWRFd2$YY"-"$MM"-"$DD$posfigWRF $EJEC_ARWPost
mv $EJEC_WRF"/"$prefigWRFd3$YY"-"$MM"-"$DD$posfigWRF $EJEC_ARWPost
echo "Terminado copiando archivos para ARWPost"

fileInt="namelist.ARWpost"
fileOut="namelistOut.input"
############################################DOMINIO 1##############################################
echo "Editando fichero namelist.ARWpost"
#############Editar fichero namelist.ARWpost###########
sed -e '1,20s/ start_date = .*/ start_date = '\'''$YY'-'$MM'-'$DD'_12:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_date = .*/ end_date = '\'''$YYf'-'$MMf'-'$DDf'_12:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ input_root_name = .*/ input_root_name = '\'''$prefigWRFd1$YY'-'$MM'-'$DD'_12:00:00'\'',/g' $fileInt > $fileOut
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
sed -e '1,20s/ start_date = .*/ start_date = '\'''$YY'-'$MM'-'$DD'_12:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ end_date = .*/ end_date = '\'''$YYf'-'$MMf'-'$DDf'_12:00:00'\'',/g' $fileInt > $fileOut
rm $fileInt
mv  $fileOut $fileInt
####
sed -e '1,20s/ input_root_name = .*/ input_root_name = '\'''$prefigWRFd2$YY'-'$MM'-'$DD'_12:00:00'\'',/g' $fileInt > $fileOut
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
grads -lcb "datos12_d02_Honduras_HRes.gs"

cp -r /home/WRF/SALIDAS_MAPAS-12 $OUTPUT_PATH"/grads"

wrf_postprocessing -i $OUTPUT_PATH -o $OUTPUT_PATH"/postprocessing"

python3 /home/send_email.py

cd /home/etl_agroclimatic_bulletins

virtualenv env

python3 src/master.py

deactivate

exit

