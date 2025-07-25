
# River network density calculation ---------------------------------------

# one of the parameters we can specify for each square from script 17 is the density of the river network
# all we need is some layer of watercourses

# load the necessary packages
xfun::pkg_attach2("tidyverse",
                  "ggtext", # for nicer plot titles, axis labels, etc.
                  "RCzechia", # package sf is loaded automatically
                  "arcgislayers")

# create the grid of square polygons
squares_czechia <- republika() |> 
  st_transform(3035) |> 
  st_make_grid(cellsize = units::set_units(10, "km")) |> 
  st_sf() |> 
  as_tibble() |> 
  st_sf() |> 
  st_set_geometry("geometry")

# load the layer with watercourses
watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> 
  st_sf()

# we can limit ourselves only to the squares and their parts located inside the territory of Czechia
squares_czechia <- squares_czechia |> 
  st_intersection(republika() |> 
                    st_transform(3035))

# assign a number to each row in the attribute table to ensure that every future calculation is correct
# and remove the useless column with the country name
squares_czechia <- squares_czechia |> 
  mutate(id = row_number()) |> 
  select(-NAZ_STAT)

# now we need to clip watercourses by squares
# certainly, it is good to transform to have the same crs
watercourses_clips <- watercourses |> 
  st_intersection(squares_czechia |> 
                    st_transform(5514))

# let us calculate the sum of the lengths of the watercourses in all the squares
watercourses_clips_sums <- watercourses_clips |> 
  group_by(id) |> 
  summarize(sum = sum(st_length(geometry) |> 
                        units::set_units("km") |> 
                        round(3)))

# because we have clipped the squares by the borders of the Czechia, now they will not all have 100 km2
# calculate the areas of the new polygons
squares_czechia <- squares_czechia |> 
  mutate(area = st_area(geometry) |> 
           units::set_units("km2") |> 
           round(2))

# join the two tables based on the id key
# now, we can get rid of one of the geometries
# we might as well calculate the density of the river network
joined <- squares_czechia |> 
  left_join(watercourses_clips_sums |> 
              st_drop_geometry(),
            join_by(id)) |> 
  mutate(density = sum / area)

# plot the situation
# when plotting, we sometimes need to remove the units
joined <- joined |> 
  mutate(density = units::drop_units(density))

ggplot() + 
  geom_sf(data = joined,
          aes(fill = density)) + # for making the differences more visible
  scale_fill_distiller(palette = "Blues",
                       direction = 1,
                       transform = "log10") + # for making the differences more visible without transforming the data
  labs(fill = "river density<br>[km km<sup>-2</sup>]") +
  theme(legend.title = element_markdown()) # must be; otherwise the previous line based on ggtext would not work
