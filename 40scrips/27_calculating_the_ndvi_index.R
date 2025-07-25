
# Calculating the NDVI index ----------------------------------------------

# calculations of spectral indices are probably most common operations with optical satellite images 
# one of the most used (and perhaps overused) indices is the normalized difference vegetation index (NDVI)
# it comes from two bands - near infrared (Landsat 7 band 4) and red (Landsat 7 band 3)

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "terra",
                  "tidyterra")

# load Landsat data
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

# using a simple expression for NDVI (see https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index), we can continue as follows
ndvi <- (landsat[[4]] - landsat[[3]]) / (landsat[[4]] + landsat[[3]])

# resulting layer may be renamed as well
names(ndvi) <- "ndvi"

# the layer can be plotted by functions supporting the ggplot concept
ggplot() + 
  geom_spatraster(data = ndvi) +
  scale_fill_distiller(palette = "RdYlBu",
                       direction = -1) +
  labs(fill = "ndvi")
