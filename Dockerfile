# Imagen base
FROM ubuntu:20.04

# Establecer el directorio de trabajo
WORKDIR /home

RUN mkdir input && mkdir output

VOLUME /home/input
VOLUME /home/output

# Copiar el archivo Build_WRF_and_WPS_V40.zip desde /inputs/ al contenedor
COPY /Input/Build_WRF_and_WPS_V40_v2.zip /home/
ENV DEBIAN_FRONTEND noninteractive
# Instalar dependencias
RUN apt-get update && apt-get install -y \
    openssh-client \
    gcc \
    gfortran \
    g++ \
    libtool \
    automake \
    autoconf \
    make \
    m4 \
    grads \
    libpng-dev \
    libhdf5-mpich-dev \
    default-jre \
    vim \
    curl \
    csh \
    unzip \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir WRF && \
    unzip /home/Build_WRF_and_WPS_V40_v2.zip -d /home/WRF/
    

RUN cd /home/WRF && \
    /home/WRF/build_libs.csh


RUN export HOME=`cd;pwd` && \
    mkdir -p $HOME/WRF && \
    cd $HOME/WRF && \
    mkdir Library && \
    cd $HOME/WRF/Library && \
    scp /home/WRF/library.zip /root/WRF/Library && \
    unzip library.zip

RUN cp /home/WRF/WRF-4.1.2.tar.gz /home/WRF/COMPILER_gfortran && \
    cp /home/WRF/WPS-4.1.2.tar.gz /home/WRF/COMPILER_gfortran && \
    cd /home/WRF/COMPILER_gfortran/ && \
    tar -xvf WRF-4.1.2.tar.gz && \
    tar -xvf WPS-4.1.2.tar.gz


RUN export NETCDF=/home/WRF/COMPILER_gfortran/netcdf-install && \
    export PATH=$NETCDF/bin:${PATH} && \
    export PATH=/home/WRF/COMPILER_gfortran/mpich2-install/bin:${PATH} && \
    cd /home/WRF/COMPILER_gfortran/WRF-4.1.2/ && \
    echo "34" | ./configure


RUN cd /home/WRF/COMPILER_gfortran/WRF-4.1.2/ && \
    export DIR=$HOME/WRF/Library && \
    export CC=gcc && \
    export CXX=g++ && \
    export FC=gfortran && \
    export F77=gfortran && \
    export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH && \
    export NETCDF=$DIR && \
    export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH && \
    ./compile em_real

RUN cd /home/WRF/COMPILER_gfortran/WPS-4.1/ && \
    export NETCDF=/home/WRF/COMPILER_gfortran/netcdf-install && \
    export PATH=$NETCDF/bin:${PATH} && \
    export PATH=/home/WRF/COMPILER_gfortran/mpich2-install/bin:${PATH} && \
    cp /home/WRF/COMPILER_gfortran/jasper-install/include/jasper/*.* /home/WRF/COMPILER_gfortran/jasper-install/include/ && \
    export JASPERLIB=/home/WRF/COMPILER_gfortran/jasper-install/lib && \
    export JASPERINC=/home/WRF/COMPILER_gfortran/jasper-install/include && \
    export WRF_DIR=/home/WRF/COMPILER_gfortran/WRF-4.1.2 && \
    echo "1" | ./configure && \
    ./compile && \
    bash
# Nota: Los demás pasos para descomprimir Build_WRF_and_W