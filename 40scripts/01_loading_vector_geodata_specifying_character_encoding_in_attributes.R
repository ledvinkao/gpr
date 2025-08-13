
# Loading shapefiles with other character encoding than UTF-8 -------------

# it is often the case that we come across obsolete vector geodata that have a different attribute encoding in the files than the standard UTF-8
# sometimes it even happens that the loaded file does not have a defined reference coordinate system (crs) either
# in this case it makes sense to try e.g. crs with EPSG code 5514 in the Czech environment (very likely if we see negative numbers in the coordinates)
# we often run into such cases e.g. in connection with the so-called shapefiles (probably the most widespread type of vector geodata files)
# examples of such data are the ones from Digital Water Base (DIBAVOD) files maintained by the T.G. Masaryk Water Research Institute, p.r.i.
# download e.g. the ZIP file with polygons of water reservoirs from https://dibavod.cz/27/struktura-dibavod.html and unpack everything (section A - basic phenomena of surface and groundwater)

# load the necessary packages for the next load of files that are inside this archive
# the most important is the SHP file which we also need to refer to by using the supporting GDAL library driver
# we will also have to set the correct encoding
xfun::pkg_attach2("tidyverse",
                  "sf")

reservoirs <- read_sf("geodata/dib_a05_vodni_nadrze/a05_vodni_nadrze.shp", # we assume the location of the downloaded file in the geodata folder of our R project
                      options = "ENCODING=WINDOWS-1250")
