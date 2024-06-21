# Docker Image for WRF Model with Agrilac Postprocessing

This Docker image is configured to run the Weather Research and Forecasting (WRF) model in the context of Honduras, with additional setup for postprocessing using the [WRF postprocessing package](https://github.com/CIAT-DAPA/agrilac_wrf_postprocessing).

## Description

This Docker image is based on Ubuntu 20.04 and includes all necessary dependencies and configurations to set up and run the WRF model, as well as process its outputs using the WRF postprocessing package.

### Features

- Installs essential packages and tools required for WRF model setup and execution.
- Sets up directories for input and output data.
- Copies necessary configuration files and scripts.
- Downloads and extracts WRF model files and dependencies.
- Configures and compiles WRF and WPS (WRF Preprocessing System).
- Integrates the WRF postprocessing package for data transformation and visualization.

## Installation and Usage

To use this Docker image, follow these steps:

1. **Pull the Docker Image**:

```bash
   docker pull dsclimateaction/wrf_10_days
```

### 2. Run the Docker Container

```bash
    docker run -it --name wrf-container -v /path/to/local/input:/home/input -v /path/to/local/output:/home/output dsclimateaction/wrf_10_days:latest
```

Replace **/path/to/local/input** and **/path/to/local/output** with your local directories for input and output data. For example, if your WRF model output files are located in **/path/to/local/input** on your local machine, and you want to save the processed outputs to **/path/to/local/output**, you would modify the command as follows:

> [!NOTE]
> Agrilac WRF Postprocessing: The container includes the Agrilac WRF postprocessing package (agrilac_wrf_postprocessing) for transforming WRF model outputs into daily raster images and PNG files.
> High-Resolution Geographic Data: Geographic data specific to the Caribbean region is preconfigured and utilized by the WRF model setup within the container.
