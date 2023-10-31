# A script to perform the proper R library installs needed for this project.

# Mandatory:
install.packages("IRkernel") # for using R kernel with jupyter
install.packages("XML") # for looking at XML format data
install.packages("ncdf4") # interface to files written in netCDF format
install.packages("sp") # spatial data helpers
install.packages("terra") # geospatial data helpers (nearly 100 mb because it's several libraries in one)
install.packages("downloader") # wraps download.file so that you can download via HTTPS
install.packages("ggplot2") # for plotting
install.packages("raster")
install.packages("rasterVis") # for plotting raster data
install.packages("directlabels") # for labeling plots


# Considering/Optional:
# install.packages("tidyr")
# install.packages("dplyr") # dataframe manipulation