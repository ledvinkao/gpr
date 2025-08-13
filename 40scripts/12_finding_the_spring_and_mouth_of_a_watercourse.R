
# Finding the spring and mouth of a watercourse ---------------------------

# it happens that we need to find the beginning and end of a line object
# here the lwgeom package functions are helpful

# load packages
# there are some conflicts between functions from different packages, but we do not notice that until we do not mind
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "arcgislayers",
                  "lwgeom")

# we load all watercourses in Czechia, which are used by the River Basin Authorities under the Ministry of Agriculture
watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> 
  st_sf()

# find e.g. the Teplá Vltava River
tvltava <- watercourses |> 
  filter(naz_tok == "Teplá Vltava")

# to apply the functions for finding the spring and the mouth, it is necessary that the line is of the LINESTRING type, not MULTILINESTRING type
# the warning is odd because we will only get one line per MULTILINESTRING (but it is probably always applied)
tvltava <- tvltava |> 
  st_cast("LINESTRING")

# however, we can continue
# here we take advantage of the fact that the axis model of watercourses is arranged in such a way that the starting point is always the mouth and the end point is always the spring
# it is for a reason to be able to count river kilometers
mouth <- tvltava |> 
  st_startpoint() |> # result is only the geometry
  st_sf() |> # so we convert to a simple feature
  st_set_geometry("geom") |> # if we get the unwanted name of the geometry column, we can rename it
  as_tibble() |> # we want a better class - a tibble
  st_sf() # from which we need to get a simple feature again

# the same for the spring
spring <- tvltava |> 
  st_endpoint() |> 
  st_sf() |> 
  st_set_geometry("geom") |> 
  as_tibble() |> 
  st_sf()

# the location of both the mouth and the spring can be plotted in a dynamic map
mouth <- mouth |> 
  mutate(type = "mouth")

spring <- spring |> 
  mutate(type = "spring")

together <- bind_rows(mouth,
                      spring)

# dynamic maps can be shown e.g. as follows
# the package mapview must be installed
mapview::mapview(together)
