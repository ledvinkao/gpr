
# Getting catchment polygons above water-gauging stations in Czech --------

# in hydrology we often need to work with catchments above water-gauging stations
# the reason may be to compare the discharge time series with the series obtained from climatological measurements (e.g. in the form of a grid)
# there are detailed layers of catchment divides for the territory of Czechia (e.g. 4th-order catchments), but they will not satisfy the hydrologist in this sense
# so we will have to derive such a layer ourselves
# a very good internet connection is needed, as we will download the necessary geographic layers

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "arcgislayers", 
                  "multidplyr") # for modern parallelization using tidyverse verbs and tables of the tibble class

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

# prepare for the parallelized processing
catch2 <- catch |> 
  left_join(stations,
            join_by(between(chp_14_s, # we make use of the new function join_by(), which allows for other relationships between keys than equality
                            chp_14_s_u,
                            chp_14_s))) |> 
  filter(!is.na(dbcn.y)) |> 
  group_by(dbcn.y) # grouping is important for partitioning

# further part is inspired by the vignette at https://cran.rstudio.com/web/packages/multidplyr/vignettes/multidplyr.html
cluster <- new_cluster(parallelly::availableCores() - 1) # as recommended in the vignette; performance depends on the specific machine

# partition the sf collection
catch2 <- catch2 |> 
  partition(cluster)

# show slaves that we are using the functions of the sf package
cluster_library(cluster,
                "sf")

# run the process of unifying polygons by groups defined by stations
# we measure the time spent
# at the end, we let play a sound to be announced everything is done:-)
tictoc::tic(); catch2 <- catch2 |> 
  summarize(geoms = st_union(geometry)) |> # exactly this must be run in parallel
  collect() |> 
  st_sf() |> 
  rename(id = dbcn.y); tictoc::toc(); beepr::beep(3)

# now, we can remove the cluster
rm(cluster)

# compute the areas of obtained catchments
catch2 <- catch2 |> 
  mutate(a = st_area(st_transform(geoms,
                                  3035)) |> 
           units::set_units("km2") |> 
           round(2)) |> # at the CHMI, it is customary to round km2 to two decimal places
  arrange(desc(a))

# get rid of the catchments with zero area
catch2 <- catch2 |> 
  filter(a > units::set_units(0,
                              "km2"))

# resulting layer may be saved to RDS to allow further work in R
write_rds(catch2,
          "results/catchments_above_738_stations.rds",
          compress = "gz")
