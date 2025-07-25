
# Raster layers as list elements ------------------------------------------

# in the terra package there are also functions for converting SpatRaster to list and vice versa
# sometimes, it may be convenient to convert such raster geodata (e.g. because of the application of a vectorized function inside map() or walk() functions)

# load the necessary packages
xfun::pkg_attach2("tidyverse",
                  "terra")

# load the raster geodata with multiple layers
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

# check the class
class(landsat)

# other functions for data exploration can be applied
str(landsat)

glimpse(landsat)

# apply the function as.list()
landsatl <- as.list(landsat)

class(landsatl)

str(landsatl)

glimpse(landsatl)

# now let us try to write each layer to the files on disk separately
# let us also measure the time of the process
tictoc::tic(); landsatl |> 
  walk(\(x) writeRaster(x,
                        str_c("results/",
                              names(x),
                              ".tif"),
                        overwrite = T)); tictoc::toc() # "overwrite" is set to get rid of telling us that a certain file already exists (just overwrite it)

# is the following approach faster?
nms <- str_c("results/",
             names(landsat),
             ".tif")

# we need to choose specific strategies depending on the task and the machine on which we intend to process the data

# note also that, for the purposes of other functions, the multi-layer raster can be converted to an array
