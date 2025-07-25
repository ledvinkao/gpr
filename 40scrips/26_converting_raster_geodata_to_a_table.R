
# Converting raster geodata to a table ------------------------------------

# sometimes it may be useful (e.g. for better manipulation) to convert raster geodata into a table
# the author of the terra package of course thinks of it, too

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "terra")

# load raster geodata (ideally with multiple layers)
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

# apply the function as.data.frame()
# sometimes it can be useful to get even the x and y coordinates into the table, so we set the argument 'xy' to TRUE
# the data frame format we can be converted to the tibble class
tab <- as.data.frame(landsat,
                     xy = T) |> # it is good to study other offered arguments, such as the possibility of getting a long table format, etc.
  as_tibble()

# print at least part of the table in the Console
tab

# subsequently, other operations can be performed with the table, such as finding a row with a missing value in any band
tab |> 
  filter(if_any(L7_ETMs_1:L7_ETMs_6, is.na))

# note that the function st_coordinates() exists in the sf package to obtain vector geodata coordinates
