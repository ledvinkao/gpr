
# Creation of the thematic map for the course website ---------------------

# maps in R can be created using other packages besides tmap
# for instance, the ggplot2 approach in combination with other packages (to add scale, north arrow, etc.) is quite popular
# let us show how to do it this way and create a map that could be on the course website:-)

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia",
                  "czso", # for loading Czech Statistical Office data
                  "ggspatial") # for adding the scalebar and north arrow

# a good internet connection is expected because the underlying data are downloaded here

# getting the layer with administrative districts
# in addition, we convert to a better class tibble
districts <- okresy() |> 
  as_tibble() |> 
  st_sf()

# getting the table containing data from censuses
# first, a data catalogue needs to be studied
catalogue <- czso_get_catalogue()

# since we do not know exactly what the table is called, let us at least try to get closer
colnames(catalogue)

catalogue |> 
  mutate(dataset = str_to_lower(description)) |> 
  filter(str_detect(description, "sčítání")) |> 
  select(dataset_id, title)

# let us try it with the dataset with id 170240-17
tab <- czso_get_table("170240-17")

# limit ourselves to years 2001 and 2011
# rather establish a new object
# as well, limit ourselves to important columns (for joining with vector layer)
tab2 <- tab |> 
  filter(rok %in% c(2001, 2011)) |> 
  select(okres, rok, hodnota)

# we can aggregate by groups (in fact we have numbers for municipalities, not districts)
# we rather also order to let work everything we need
tab2 <- tab2 |> 
  arrange(okres, rok) |> 
  group_by(okres, rok) |> 
  summarize(val_num = sum(hodnota))

# before joining with the geographic layer it will be better to nest the data
tab2 <- tab2 |> 
  nest()

# perform joining based on the district code
districts <- districts |> 
  left_join(tab2,
            join_by(KOD_OKRES == okres))

# to calculate population density we need to know the areas of districts
# to do this we will use a equal-area crs, which is used across the EU for statistical calculations
# convert units to km2 and get rid of units for further calculations (for some functions, units are annoying)
districts <- districts |> 
  mutate(a = st_area(st_transform(geometry, 3035)) |> 
           units::set_units("km2") |> 
           units::drop_units())

# using functional programming we get the percentage of changes (year 2001 = 100%)
# an anonymous function may help us
districts <- districts |> 
  mutate(change = data |> 
           map2_dbl(a, \(x, y)
                    (slice(x, 2) |> pull(val_num) / y) / (slice(x, 1) |> pull(val_num) / y) * 100)
  )

# let us plot the map
ggplot(districts) +
  geom_sf(aes(fill = change)) +
  scale_fill_distiller(palette = "BuPu",
                       direction = 1) +
  scale_x_continuous(breaks = 12:19) +
  scale_y_continuous(breaks = 49:51) +
  labs(title = "Index of population density change in districts of Czechia between 2001 and 2011",
       subtitle = "2001 = 100 %, min. = 95.3 %, max. = 145.7 %",
       fill = "change [%]",
       caption = "source: CZSO") +
  annotation_north_arrow(location = "tr",
                         style = north_arrow_fancy_orienteering(),
                         which_north = "true") +
  annotation_scale(location = "bl")

# to save to a file we assign the plot to an object
p <- ggplot(districts) +
  geom_sf(aes(fill = change)) +
  scale_fill_distiller(palette = "BuPu",
                       direction = 1) +
  scale_x_continuous(breaks = 12:19) +
  scale_y_continuous(breaks = 49:51) +
  labs(title = "Index of population density change in districts of Czechia between 2001 and 2011",
       subtitle = "2001 = 100 %, min. = 95.3 %, max. = 145.7 %",
       fill = "change [%]",
       caption = "source: CZSO") +
  annotation_north_arrow(location = "tr",
                         style = north_arrow_fancy_orienteering(),
                         which_north = "true") +
  annotation_scale(location = "bl")

# and because we work in an R project, we can refer relatively when saving the file
# we assume we have a folder called figs in our project
# set A5 page size (landscape)
ggsave("figs/course_map.png",
       p,
       width = 21,
       height = 14.85,
       units = "cm")
