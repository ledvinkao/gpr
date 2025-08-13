
# Spatial join ------------------------------------------------------------

# sometimes, we need to add attributes (fields) from one table to another just based on geometric relationship
# the st_join() function appears to be a suitable tool for this task, again considering the st_intersects() option by default
# by default, the left join is also considered
# suppose that in addition to which basin (given by the number hlgp4) the water station belongs to, we also need information about belonging to the region

# load packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia") # package sf is loaded automatically

# work with metadata
meta <- read_rds("metadata/wgmeta2024.rds") |> 
  st_transform(4326)

# loading the layer with administrative regions
regions <- kraje()

# for the demonstration, we will focus only on the essential columns
# after application of the select() function, the geometry remains (it is the so-called "sticky geometry")
meta <- meta |> 
  select(dbc:hlgp4)

regions <- regions |> 
  select(kraj = NAZ_CZNUTS3)

# now, we apply joining using the function st_join()
meta <- meta |> 
  st_join(regions)

# do we have some station without any region?
meta |> 
  filter(is.na(kraj))

# what are the numbers of stations in individual regions?
meta |> 
  filter(!is.na(kraj)) |> 
  count(kraj)

# we can see that the geometry now is annoying
# but we can get rid of it
meta |> 
  st_drop_geometry() |> 
  filter(!is.na(kraj)) |> 
  count(kraj)
