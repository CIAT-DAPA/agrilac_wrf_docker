FROM ubuntu:20.04

# Set non-interactive mode for package installation
ENV DEBIAN_FRONTEND noninteractive

# Set the working directory
WORKDIR /home

# Create input and output directories
RUN mkdir input && mkdir output

# Set up volumes for input and output directories
VOLUME /home/input
VOLUME /home/output

# Copy necessary files to the container
COPY /config/* /home/

# Install dependencies
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
    wget \
    csh \
    unzip \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*


# Set up WRF and WPS
RUN mkdir WRF && \
    unzip /home/Build_WRF_and_WPS_V40_v2.zip -d /home/WRF/ && \
    unzip /home/automation_scripts.zip -d /home/ && \
    unzip /home/gfs.zip -d /home/WRF/ && \
    mv /home/ParaHonduras/* /home/WRF/ && \
    mv /home/RunWRF_JN_00.sh /home/WRF/EJECUTORES/ && \
    mv /home/RunWRF_JN_12.sh /home/WRF/EJECUTORES/ && \
    chmod 777 /home/WRF/EJECUTORES/RunWRF_JN_00.sh && \
    chmod 777 /home/WRF/EJECUTORES/RunWRF_JN_12.sh && \
    chmod 777 /home/WRF/gfs/bin/wgrib2 && \
    chmod 777 /home/WRF/AUXILIARES/ARWpost/ARWpost.exe && \
    mv /home/get_gfs-grib2_CARIBE_54h-025.sh /home/WRF/gfs/bin/ && \
    unzip /home/SHAPES.zip -d /home/WRF/AUXILIARES/ && \
    mv /home/datos00_d01_Honduras_HRes.gs /home/WRF/AUXILIARES/grads-1.8/grads-1.8/bin/ && \
    mv /home/datos00_d02_Honduras_HRes.gs /home/WRF/AUXILIARES/grads-1.8/grads-1.8/bin/ && \
    mv /home/datos12_d01_Honduras_HRes.gs /home/WRF/AUXILIARES/grads-1.8/grads-1.8/bin/ && \
    mv /home/datos12_d02_Honduras_HRes.gs /home/WRF/AUXILIARES/grads-1.8/grads-1.8/bin/ && \
    pip3 install git+https://github.com/CIAT-DAPA/agrilac_wrf_postprocessing && \
    wget -O geog_high_res_mandatory.tar.gz "https://cgiar-my.sharepoint.com/:u:/g/personal/s_calderon_cgiar_org/EdwYmtChgwxJryOWXoNf5RYBfk08tT3TTJfuTLpZlaFF7w?e=5yQZVp&download=1" && \
    tar -xzvf geog_high_res_mandatory.tar.gz -C /home/WRF/

# Build WRF dependencies
RUN cd /home/WRF && \
    /home/WRF/build_libs.csh && \
    export HOME=`cd;pwd` && \
    mkdir -p $HOME/WRF && \
    cd $HOME/WRF && \
    mkdir Library && \
    cd $HOME/WRF/Library && \
    scp /home/WRF/library.zip /root/WRF/Library && \
    unzip library.zip && \
    cd /home/WRF/ && \
    tar -xvf WRF-4.1.2.tar.gz && \
    tar -xvf WPS-4.1.2.tar.gz

# Configure and compile WRF
RUN export NETCDF=/home/WRF/COMPILER_gfortran/netcdf-install && \
    export PATH=$NETCDF/bin:${PATH} && \
    export PATH=/home/WRF/COMPILER_gfortran/mpich2-install/bin:${PATH} && \
    cd /home/WRF/WRF-4.1.2/ && \
    echo "34" | ./configure && \
    cd /home/WRF/WRF-4.1.2/ && \
    export DIR=$HOME/WRF/Library && \
    export CC=gcc && \
    export CXX=g++ && \
    export FC=gfortran && \
    export F77=gfortran && \
    export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH && \
    export NETCDF=$DIR && \
    export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH && \
    ./compile em_real && \
    mv /home/namelist.input /home/WRF/WRF-4.1.2/run/

# Configure and compile WPS
RUN cd /home/WRF/WPS-4.1/ && \
    cp /home/Vtable /home/WRF/WPS-4.1/ && \
    export NETCDF=/home/WRF/COMPILER_gfortran/netcdf-install && \
    export PATH=$NETCDF/bin:${PATH} && \
    export PATH=/home/WRF/COMPILER_gfortran/mpich2-install/bin:${PATH} && \
    cp /home/WRF/COMPILER_gfortran/jasper-install/include/jasper/*.* /home/WRF/COMPILER_gfortran/jasper-install/include/ && \
    export JASPERLIB=/home/WRF/COMPILER_gfortran/jasper-install/lib && \
    export JASPERINC=/home/WRF/COMPILER_gfortran/jasper-install/include && \
    export WRF_DIR=/home/WRF/WRF-4.1.2 && \
    echo "1" | ./configure && \
    ./compile && \
    mv /home/namelist.wps /home/WRF/WPS-4.1/


RUN cd /home/WRF/ && \
    mkdir SALIDAS_MAPAS-00 && \
    mkdir SALIDAS_MAPAS-12 && \
    cd /home/WRF/SALIDAS_MAPAS-00/ && \
    mkdir D_01 D_02 && \
    cd D_01/ && \
    mkdir ACUM_PREC HR_850_500 PRECIPITACIONES_HUR PRECIPITACIONES_VTO SST SALIDAS_CMW SALIDAS_CAVILA TEMPERATURA VIENTO && \
    cd .. && \
    cp -r D_01/* D_02/ && \
    cd .. && \
    cp -r SALIDAS_MAPAS-00/* SALIDAS_MAPAS-12/ && \
    cd /home/WRF/WPS-4.1/ && \
    ./geogrid.exe


CMD ["tail", "-f", "/dev/null"]