
# Points selection based on their relation to a polygon -------------------

# let us say we decided to choose the water-gauging stations that lie within a given rectangle
# then we make the opposite selection
# sf package offers to base such selections on several functions
# let us show it on the functions st_intersects() and st_disjoint()
# for selections using geometry there is a simplified procedure using square brackets

# load packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically
                  "sfheaders")

# first the work with metadata of water-gauging stations
meta <- read_rds("metadata/wgmeta2024.rds") |> 
  st_transform(4326) # to have the same crs

# rectangle creation
rectangle <- sfc_polygon(matrix(c(16.35, 49.3,
                                  18.85, 49.3,
                                  18.85, 50.2,
                                  16.35, 50.2,
                                  16.35, 49.3),
                                ncol = 2,
                                byrow = T)) |> 
  st_sf() |> 
  st_set_crs(4326) |> 
  st_set_geometry("geom") |> 
  as_tibble() |> 
  st_sf()

# select only stations that are inside the rectangle
# work resembles a familiar selection of rows
stations_in_rectangle <- meta[rectangle, ]

# by default, points inside the polygon are selected (the st_intersects() function is silently applied)
# for the opposite selection, it is necessary to set the argument 'op'
stations_outside_rectangle <- meta[rectangle, op = st_disjoint]

# plot the first and second situation
borders <- republika()

ggplot() + 
  geom_sf(data = borders,
          col = "purple",
          fill = NA,
          linewidth = 1.5) +
  geom_sf(data = rectangle,
          col = "black",
          fill = "grey30",
          alpha = 0.6,
          linewidth = 1.5) +
  geom_sf(data = stations_in_rectangle,
          col = "red",
          size = 1)

ggplot() + 
  geom_sf(data = borders,
          col = "purple",
          fill = NA,
          linewidth = 1.5) +
  geom_sf(data = rectangle,
          col = "black",
          fill = "grey30",
          alpha = 0.6,
          linewidth = 1.5) +
  geom_sf(data = stations_outside_rectangle,
          col = "red",
          size = 1)
