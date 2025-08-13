
# Saving to SHP with standard encoding and projection ---------------------

# at the CHMI, the standard coordinate reference system (crs) is the one with EPSG code 32633
# moreover, it is desirable that the file have this projection clearly defined in the .prj file after saving
# we will also try to save the information on character encoding in the text attributes (file .cpg)

# loading packages first
xfun::pkg_attach2("tidyverse",
                  "sf")

# we load e.g. water reservoirs in a familiar way
reservoirs <- read_sf("geodata/dib_a05_vodni_nadrze/a05_vodni_nadrze.shp",
                      options = "ENCODING=WINDOWS-1250",
                      layer = "a05_vodni_nadrze")

# save to a new shapefile with standard encoding and projection definition
# the extension specifies which driver to use for saving
reservoirs |> 
  st_transform(32633) |> 
  write_sf("geodata/water_reservoirs_new.shp",
           layer_options = "ENCODING=UTF-8")

# by default it is only possible to save a certain number of characters for different field types (see https://gdal.org/drivers/vector/shapefile.html)
# also warnings say that
warnings()

# this problem could probably be circumvented by setting other field widths
# we will not dwell on this, as it is advisable to learn to save to other, more modern files
