
# Concatenating raster geodata --------------------------------------------

# sometimes it is useful to add the resulting layer to the data from which this layer was calculated
# for this purpose, simply, the function c() can be used, as if we were concatenating vectors or lists

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "terra",
                  "tidyterra")

# proceed similarly to script 27
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

ndvi <- (landsat[[4]] - landsat[[3]]) / (landsat[[4]] + landsat[[3]])

names(ndvi) <- "ndvi"

# add the ndvi layer to the landsat object and make sure we were successful
landsat <- landsat |> 
  c(ndvi)

names(landsat)

# we may plot again
ggplot() + 
  geom_spatraster(data = landsat$ndvi) +
  scale_fill_distiller(palette = "RdYlBu",
                       direction = -1) +
  labs(fill = "ndvi")

# condition for concatenation is of course the same geometry (crs, horizontal resolution, extent, etc.)
