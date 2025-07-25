
# Working with buffer -----------------------------------------------------

# creating a buffer is a very common activity because we need it for various purposes
# buffer can be created using the st_buffer() function, which is part of the sf package

# load packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia") # package sf is loaded automatically

# try to create a 50-km buffer surrounfing the borders of Czechia
borders <- republika() |> 
  st_transform(32633) # when working with buffers it is advisable to convert to plane projection (with coordinates in meters)

bbuf <- borders |> 
  st_buffer(units::set_units(50, "km")) # here we use the function to set up units from the units package (we may or may not write quotes before and after abbreviations of units, but sometimes it is more appropriate)

# plot the situation
ggplot() + 
  geom_sf(data = borders,
          col = "purple",
          linewidth = 1.5,
          fill = NA) +
  geom_sf(data = bbuf,
          col = "orange",
          linewidth = 1.5,
          fill = NA)

# there are also possibilities of entering negative numbers
# so this is going to be the shrinkage of the polygon
# here it is really necessary to have data in plane projection, otherwise empty geometry will be created
bbuf2 <- borders |> 
  st_buffer(units::set_units(-10, "km"))

ggplot() + 
  geom_sf(data = borders,
          col = "purple",
          linewidth = 1.5,
          fill = NA) +
  geom_sf(data = bbuf,
          col = "orange",
          linewidth = 1.5,
          fill = NA) +
  geom_sf(data = bbuf2,
          col = "red",
          fill = NA,
          linewidth = 1.5)
