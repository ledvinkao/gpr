
# Watercourses length computation -----------------------------------------

# the length of a watercourse is a very important parameter for hydrologists and water managers
# before calculating the length of a watercourse (or other line element) it is important to have a vector layer in a crs that distorts lengths as little as possible in a certain territory
# in Czechia, for this purpose we use the crs with code EPSG:5514 (see https://epsg.io/5514)

# first, load the necessary packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically
                  "arcgislayers")

# let us do the calculation only for watercourses within the South Bohemian Region
sb <- kraje() |> 
  filter(NAZ_CZNUTS3 == "Jihočeský kraj") |>
  st_transform(5514) # crs directly transformed

# load the watercourses
watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> 
  st_sf()

# clip the watercourses by the borders of the region
# we also select only the important attributes not to be confused by such amounts of them
watercourses_sb <- watercourses |> 
  st_intersection(sb) |> 
  select(idvt,
         naz_tok)

# calculate the lengths and add them to the table as a new column
# length will be expressed in kilometers
# but we round up so that we can also determine the length in meters
watercourses_sb <- watercourses_sb |> 
  mutate(length = st_length(geometry) |> 
           units::set_units("km") |> 
           round(3))

# of course we have to realize that the lengths correspond to the clipped lines!
# length calculations can also be based on so-called geodetic measures
