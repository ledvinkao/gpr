
# Filtering according to the values in raster layers ----------------------

# if there are layer selections for raster geodata, there must also be filtering
# the author of the terra package states that each layer can be imagined as an individual table column
# therefore the filter() function can be used similarly as for tables

# load the necessary packages first
xfun::pkg_attach2("tidyverse",
                  "terra",
                  "tidyterra")

# load the file with raster geodata
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

# let us observe the statistics of individual bands
summary(landsat)

# let us try e.g. filtering to 6th band values that are greater than 60
landsatf <- landsat |> 
  filter(L7_ETMs_6 > 60)

# plot the result
plot(landsatf)
