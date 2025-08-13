
# Function extract() ------------------------------------------------------

# there is a very important extract() function in the terra package
# this function can be used to extract the raster values for the points located in the raster cell
# this function can also be used to extract values along the line, but mainly it can be employed when aggregating raster values inside the polygon

# load the necessary packages first
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically
                  "terra",
                  "geodata")

# demonstrate the importance of this function on slope inclination in Czechia and its surroundings
dem <- elevation_30s(country = "CZE",
                     path = "geodata",
                     mask = F)

slp <- terrain(dem,
               v = "slope",
               filename = "geodata/CZE_slp.tif",
               overwrite = T)

values(slp) |> 
  range(na.rm = T)

# we need some polygons to aggregate across
# we take e.g. administrative regions of Czechia
# this vector layer is even in the same crs, so there is no need to transform
# but the new versions of the terra package hardly need transformations anymore, because vector geodata without the previous transformation of crs are automatically transformed into a raster crs
regions <- kraje()

# the crs() function comes from the terra package, but since some time it can also be applied to an object of the sf class
crs(regions) == crs(regions)

# apply the extract() function and calculate e.g. the median slope inclination in each region
# note that the function also has the 'bind' argument, by which we indicate that we want to attach the resulting values to the vector layer table
# otherwise the result would be only a matrix
# in this case we don not really need a polygon ID
regions <- extract(slp, # it is a custom here that the first place is occupied by a raster
                   regions,
                   fun = median, # but any reasonable anonymous function can be set here
                   bind = T) |> # the result is a native vector format of the terra package (SpatVector)
  st_as_sf() |> # it can be converted to a simple feature collection
  as_tibble() |> # and then change the class into tibble
  st_sf()

# setting the argument exact = T will give the exact proportions of cells according to the polygon boundary, but the calculation takes much longer
