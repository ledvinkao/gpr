
# Categorical raster ------------------------------------------------------

# in the previous script 29 we saw that something still needs to be done about the slope aspect
# repeat quickly what was done in script 29 (without plotting) and continue

# load packages
xfun::pkg_attach2("tidyverse",
                  "terra",
                  "geodata")

# if DEM is already downloaded in the directory, it is just loaded and nothing is downloaded anymore
dem <- elevation_30s(country = "CZE",
                     path = "geodata",
                     mask = F)

# get the aspect in degrees
asp <- terrain(dem,
               v = "aspect",
               filename = "geodata/CZ_asp.tif",
               overwrite = T)

# let us find out what the minimum is and what the maximum is
asp |> 
  values() |> 
  range(na.rm = T) # ignoring missing values (or values of cells where nothing could be decided on the aspect; there are really few of them)

# let us convert raster values to categories
cat <- asp |> 
  values() |> 
  cut(breaks = c(0,
                 seq(from = 45,
                     to = 315,
                     by = 90),
                 360),
      include.lowest = T, # zero will be included in the first interval (left-closed interval)
      labels = c("n1", # first north
                 "e", # east
                 "s", # south
                 "w", # west
                 "n2")) |> # second north
  fct_collapse(n = c("n1", "n2"), # two norths merged together
               e = "e",
               s = "s",
               w = "w")

# function rast() can be used for inheriting geometry (i.e. removes values from asp raster)
asp_cat <- rast(asp)

# now setting category values
values(asp_cat) <- cat

# terra package has its own color palettes, one of them is also for the slope aspect
plot(asp_cat,
     col = map.pal("aspect",
                   n = 4))

# note that instead of combining functions values() and cut(), it is possible to use terra::classify() (it is not possible to set labels) or terra::subst() (it is possible to set labels)

# tidyterra package offers additional suitable color palettes for plotting in the sense of ggplot2
library(tidyterra)

ggplot() + 
  geom_spatraster(data = asp_cat) + 
  scale_fill_grass_d(palette = "aspect") + 
  labs(fill = "slope aspect\n(categories)")
