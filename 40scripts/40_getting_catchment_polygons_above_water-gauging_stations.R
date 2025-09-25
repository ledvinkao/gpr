
# Getting catchment polygons above water-gauging stations in Czechia ------

# in hydrology we often need to work with catchments above water-gauging stations
# the reason may be to compare the discharge time series with the series obtained from climatological measurements (e.g. in the form of a grid)
# there are detailed layers of catchment divides for the territory of Czechia (e.g. 4th-order catchments), but they will not satisfy the hydrologist in this sense
# so we will have to derive such a layer ourselves
# a very good internet connection is needed, as we will download the necessary geographic layers

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "arcgislayers")

# get the smallest catchment polygons based on https://open-data-chmi.hub.arcgis.com/datasets/chmi::rozvodnice-povod%C3%AD-4-%C5%99%C3%A1du-roz%C5%A1%C3%AD%C5%99en%C3%A9/about
# at the end, we edit the character strings to correctly contain the NA characters representing missing values (it can also be useful for other work)
catch <- arc_read("https://services1.arcgis.com/ZszVN9lBVA5x4VmX/arcgis/rest/services/rozvodnice5G_4_radu_plus/FeatureServer/6") |> 
  as_tibble() |> 
  st_sf() |> 
  mutate(across(where(is.character),
                \(x) if_else(x == "", NA, x)))

# keep a table only with rows that contain IDs of the water-gauging stations
# we use a side effect (unusual IDs, i.e. some dbcn, are converted to NA values inside filter())
# select only the most important columns before joining with the geometry part
stations <- catch |> 
  st_drop_geometry() |> 
  filter(!is.na(as.numeric(dbcn))) |> 
  select(dbcn,
         chp_14_s,
         chp_14_s_u)

# prepare for the parallelized processing by means of the function in_parallel() - see the documentation to purrr functions
catch2 <- catch |> 
  left_join(stations,
            join_by(between(chp_14_s, # we make use of the new function join_by(), which allows for other relationships between keys than equality
                            chp_14_s_u,
                            chp_14_s))) |> 
  filter(!is.na(dbcn.y)) |> 
  nest(rest = -dbcn.y)

# before running, we need to call so-called daemons whose number is dependent on the machine at hand
# wee need some function of the mirai package
mirai::daemons(0) # this is done only if we needed to switch to the sequential process

mirai::daemons(parallelly::availableCores() - 1) # to have the script general, we are looking at the number of available cores, while one core should be left for working on other things

# run the process of unifying polygons by rows representing the stations
# we measure the time spent
# at the end, we let play a sound to be announced everything is done:-)
# according to the documentation, it is necessary to ensure that the process will be run in paralell
mirai::require_daemons()

tictoc::tic(); catch3 <- catch2 |> 
  mutate(rest = map(rest,
                    in_parallel(\(x) {
                      xfun::pkg_attach2("tidyverse",
                                        "sf")
                      st_union(x)
                    }))) |> # unknown objects in other than the main process must be introduced after the function definition
  unnest(rest) |> 
  st_sf() |> # because the result of the unnest() function is a tibble
  st_set_geometry("geoms") |> # rename the geometry
  rename(id = dbcn.y); tictoc::toc(); beepr::beep(3)

# compute the areas of obtained catchments
catch3 <- catch3 |> 
  mutate(a = st_area(st_transform(geoms,
                                  3035)) |> 
           units::set_units("km2") |> 
           round(2)) |> # at the CHMI, it is customary to round km2 to two decimal places
  arrange(desc(a)) # for plotting, it is recommended that we have the biggest polygons at the bottom (i.e. the rows are arranged in the descending order)

# get rid of the catchments with zero area
catch3 <- catch3 |> 
  filter(a > units::set_units(0,
                              "km2"))

# resulting layer may be saved to RDS to allow further work in R
write_rds(catch3,
          "results/catchments_above_738_stations.rds",
          compress = "gz")
