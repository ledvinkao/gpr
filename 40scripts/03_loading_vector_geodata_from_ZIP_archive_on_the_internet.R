
# Loading vector geodata directly from a ZIP archive (internet) -----------

# sometimes the ZIP file is not even necessary to download and vector geodata can be taken directly from the archive located on the internet

# first load the necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf")

# to be successful in loading, we need to know the internet address of the file (ending in '.zip')
# we insert this address into our 'loading' function, but we also use so-called prefix chaining

# it is advisable to see what is available in the archive or folder before loading geodata
# by the st_layers() function from the sf package, folders can be viewed like this
# let us demonstrate on the file for Slovakia offered on the website of the European Environment Agency (EEA)
st_layers("/vsizip//vsicurl/https://www.eea.europa.eu/data-and-maps/data/eea-reference-grids-2/gis-files/slovakia-shapefile/at_download/file/slovakia_shapefile.zip")

# and load one of the layers
sk <- read_sf("/vsizip//vsicurl/https://www.eea.europa.eu/data-and-maps/data/eea-reference-grids-2/gis-files/slovakia-shapefile/at_download/file/slovakia_shapefile.zip",
              layer = "sk_10km")

# details of these procedures can be found on the GDAL website, which is used in this vector geodata retrieval
# see https://gdal.org/en/latest/user/virtual_file_systems.html
# note, for example, double slashes after /vsizip (not necessary, but recommended)
