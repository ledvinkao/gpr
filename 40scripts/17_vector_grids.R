
# Vector grids ------------------------------------------------------------

# sometimes it pays to create your own regular network of polygons covering some territory
# we want to investigate the spatial variability of a phenomenon, for example
# to create such vector grids, e.g. the st_make_grid() function from the sf package can be utilized

# first, load the necessary packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia") # package sf is loaded automatically

# if, for example, we want to cover the territory of Czechia with a regular network of squares with an area of 100 km2, we can proceed as follows
squares_czechia <- republika() |> 
  st_transform(3035) |> 
  st_make_grid(cellsize = units::set_units(10, "km"))

# plot the situation
ggplot() + 
  geom_sf(data = squares_czechia) +
  geom_sf(data = republika(),
          fill = NA,
          col = "red",
          lwd = 1.5)

# and we can also see the area of each square
squares_czechia <- squares_czechia |> 
  st_sf() |> 
  as_tibble() |> 
  st_sf() |> 
  st_set_geometry("geometry") |> 
  mutate(area = st_area(geometry) |> 
           units::set_units("km2"))
