
# Slope aspect ------------------------------------------------------------

# slope aspect is an important factor influencing a wide range of hydrometeorological variables
# when working with R, datasets offered by the geodata package usually suffice
# this package also includes a function for downloading the digital elevation model (DEM)
# with these models we can do various calculations related to the terrain

# load the necessary packages first
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically with this
                  "terra",
                  "tidyterra",
                  "geodata")

# we use the function elevation_30s(), where we specify that we want to focus on the territory of Czechia
# masking is undesirable now
dem <- elevation_30s(country = "CZE",
                     path = "geodata",
                     mask = F)

# observe how the data are looking
ggplot() + 
  geom_spatraster(data = dem) +
  scale_fill_hypso_c(palette = "wiki-schwarzwald-cont") +
  labs(fill = "m n.m.") + 
  geom_sf(data = republika(),
          fill = NA,
          col = "purple",
          linewidth = 1.5)

# let us get the aspect slope in degrees from the model
# we directly save the result to a file, and plot
asp <- terrain(dem,
               v = "aspect",
               filename = "geodata/CZ_asp.tif",
               overwrite = T)

ggplot() + 
  geom_spatraster(data = asp) + 
  scale_fill_distiller(palette = "RdYlGn") +
  labs(fill = "orientace \nsvahu [°]")

# but there is still work to be done
