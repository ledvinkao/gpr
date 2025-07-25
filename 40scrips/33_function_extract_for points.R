
# Function extract() for points -------------------------------------------

# as already indicated, the extract() function can be used for other types of vector geodata than polygons
# let us demonstrate the meaning of this function for points (e.g. locations of water-gauging stations in Czechia)

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "terra",
                  "geodata")

# load the file with metadata of water-gauging stations
meta <- read_rds("metadata/wgmeta2024.rds")

# for points the 'fun' argument has no meaning, rather the 'method' argument is important
# but we leave the simple extraction
# we prefer to remember different crs as well (although today's versions of the terra package allow differing crs)
dem <- elevation_30s(country = "CZE",
                     path = "geodata",
                     mask = F)

meta <- extract(dem,
                meta |> 
                  st_transform(crs(dem)), # we inherit the crs of the raster layer
                bind = T) |> 
  st_as_sf() |> 
  as_tibble() |> 
  st_sf()
