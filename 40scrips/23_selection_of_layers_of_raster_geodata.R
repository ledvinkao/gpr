
# Selection of layers of raster geodata -----------------------------------

# there are several options to select the layers (bands) of raster geodata
# let's show how this can be done natively with geodata of type SpatRaster, and also how to use the select() function from the tidyterra package

# load the necessary packages first
xfun::pkg_attach2("tidyverse",
                  "terra",
                  "tidyterra")

# load the file with raster geodata
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

# because raster geodata with multiple layers behave like a list, double square brackets can be used to select layers
landsat[[c(1, 3)]]

# we can also use the select() function from the tidyterra package
landsat |> 
  select(1, 3)

# of course we can refer to the names of layers (even with the use of regular expressions)
landsat[[str_detect(names(landsat), "_1$|_3$")]]

landsat |> 
  select(matches("_1$|_3$"))

# watch out! with such a small amount of layers it is almost impossible to see the difference in operation length, but the native way with brackets is much faster
# processing speed is very apparent in case of big data (with a large number of layers)
tictoc::tic(); landsat[[str_detect(names(landsat), "_1$|_3$")]]; tictoc::toc()

tictoc::tic(); landsat |> 
  select(matches("_1$|_3$")); tictoc::toc()

# because a multi-layer raster can often be treated as a list, the $ operator can be used to select one specific layer followed by the layer name
