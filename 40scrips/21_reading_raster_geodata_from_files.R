
# Reading raster geodata from files ---------------------------------------

# to work with raster geodata in the current R mainly the package terra is used
# for working with raster geodata, there is also the package stars, but it is a bit more difficult to work with because it is rather designed for arrays and data cubes
# manipulation of raster geodata in the sense of tidyverse (and also drawing raster maps) is enabled by the tidyterra package
# with these packages example data comes, which we take advantage of
# the terra package author even created a separate package called geodata for gaining geodata from the internet
# let us show how we can load a raster geodata file using the rast() function of the terra package

# load the necessary packages first
xfun::pkg_attach2("tidyverse",
                  "terra")

# let us see what GeoTIFF files come with the stars package and what with the terra package
dir(system.file(package = "stars"),
    pattern = "\\.tif$",
    recursive = T,
    full.names = T)

dir(system.file(package = "terra"),
    pattern = "\\.tif$",
    recursive = T,
    full.names = T)

# load e.g. the L7_ETMs.tif file, which is a product of the Landsat mission
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

# this way you can draw multiple layers at once
plot(landsat)

# the image has six bands, which you can find out just by printing to the Console
landsat

# or we can use nlyr()
nlyr(landsat)

# of course, we can apply other query functions
nrow(landsat)

ncol(landsat)

crs(landsat) |> 
  cat()

crs(landsat) |> 
  str_view()
