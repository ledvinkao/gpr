
# Saving vector geodata to modern files -----------------------------------

# in the world of GIS there are much more modern and suitable types of files to store geodata
# recommended are e.g. geojson or geopackage formats (suffix .gpkg), currently also geoparquet (suffix .parquet)

# load packages first
xfun::pkg_attach2("tidyverse",
                  "sf")

# get the reservoir polygons correctly again
reservoirs <- read_sf("geodata/dib_a05_vodni_nadrze/a05_vodni_nadrze.shp",
                      options = "ENCODING=WINDOWS-1250",
                      layer = "a05_vodni_nadrze")

# save to geojson file first
reservoirs |> 
  st_transform(32633) |> 
  write_sf("geodata/water_reservoirs_new.geojson")

# then save to a geopackage file
reservoirs |> 
  st_transform(32633) |> 
  write_sf("geodata/water_reservoirs_new.gpkg")

# vector geodata can also be stored in RDS files
# which is handy just when we want to take full advantage of the potential of R (e.g. with nesting of columns, etc.)
reservoirs |> 
  st_transform(32633) |> 
  write_rds("geodata/water_reservoirs_new.rds")
