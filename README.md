# What:
Hopefully... approximately mapping how the Mediterranean Sea shrunk during the Messinian salinity crisis with modern bathymetric topography data.
# Why:
To learn R, and to learn a bit more about geospatial data.
# Stack: 
- R
- Python
- Jupyter
# Data:
[Bathymetric data](https://emodnet.ec.europa.eu/en/emodnet-web-service-documentation#data-download-services) collected by many organizations & published by the European Commission's European Marine Observation and Data Network (EMODnet).
## Terminology & Definitions:
_The European Commission_ (a governing body in the European Union) hosts a web service called _European Marine Observation and Data Network (EMODnet)_.  _EMODnet_ hosts all sorts of geospatial marine data, like Plankton density, bathymetry (sea basin topography), and geologic surveys, often in several different data formats.  

This repository takes advantage of two different data download services:
### _Web Coverage Service (WCS):_
The _**Web Coverage Service (WCS)_ is an implementation of data accessible over the internet.  It is called _WCS_ because it complies with the _Open Geospatial Consortium (OGC)'s_ extremely complicated requirements to be a _WCS._  The _OGC_ is some kind of cooperative entity that is supposed to create standards to make geospatial data more accessible.  _EMODnet_ has some data that is only available through their _WCS,_ like raster data. [See link.](https://emodnet.ec.europa.eu/en/emodnet-web-service-documentation#data-download-services)
### _Web Feature Service (WFS):_
The _**Web Feature Service (WFS)_ is different implementation of data accessible over the internet.  It is called _WFS_ because it complies with the _OGC's_ extremely complicated requirements to be a _WFS._  Again, certain data is only accessible through the _WFS,_ like features and vector data. [See link.](https://emodnet.ec.europa.eu/en/emodnet-web-service-documentation#data-download-services)
## Fetching Data:
Using _WFS_ and _WCS_ are very similar.  You pass all of the input data to the service via a URL, such as coordinates to specify the area you'd like the data for, resolution, service type, file format, etc.  Here is an example _WCS_ request:

_https://ows.emodnet-bathymetry.eu/wcs?service=wcs&version=1.0.0&request=getcoverage&coverage=emodnet:mean&crs=EPSG:4326&BBOX=22,39,24.5,41&format=image/tiff&interpolation=nearest&resx=0.001&resy=0.001_

A server on their end will do some work, and you will have a JSON, or a TIFF, or some kind of file returned to you by that call.

# Other Resources:
[Paradis' R Tutorial](https://cran.r-project.org/doc/contrib/Paradis-rdebuts_en.pdf)
