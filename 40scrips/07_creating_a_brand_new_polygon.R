
# Creation of a brand new vector layer ------------------------------------

# suppose we have to create a polygon (e.g. a rectangle) to define our area of interest for further work
# this is a very common case when e.g. using such a polygon we download more geodata from some server

# load packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically
                  "sfheaders") # although there are functions in the sf package for this as well, sfheaders offer more arguments

# suppose that the region of interest is a spherical rectangle extending between 16.35-18.85°N and 49.3-50.2°W

# first create matrix with first and last rows identical (to close the polygon)
mat <- matrix(c(16.35, 49.3,
                18.85, 49.3,
                18.85, 50.2,
                16.35, 50.2,
                16.35, 49.3),
              ncol = 2,
              byrow = T)

# create a polygon, which does not have a coordinate system yet
# we can also change our mind and create only the geometry object (function sfg_polygon()) or directly a simple feature object with a default field (function sf_polygon())
rectangle <- sfc_polygon(mat)

# add a coordinate system and change the object type to a simple feature
# we will also name the column with geometry
# and to be completely satisfied, we add a class of tibble to the object
rectangle <- rectangle |>
  st_sf() |> 
  st_set_crs(4326) |> 
  st_set_geometry("geom") |> # this way we change the name of the geometry column (under no circumstances by using set_names()!)
  as_tibble() |> 
  st_sf() # # we have to apply a second time, otherwise we would only have a table

# plot the situation
# we download an auxiliary layer for a better understanding of the position
borders <- republika()

ggplot() +
  geom_sf(data = borders,
          col = "purple",
          linewidth = 1.5,
          fill = NA) +
  geom_sf(data = rectangle,
          col = "black",
          fill = "grey30",
          alpha = 0.6,
          linewidth = 1.5)
