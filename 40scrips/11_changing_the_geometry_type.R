
# Changing the geometry type ----------------------------------------------

# sometimes you need to change the geometry type
# some other functions (see other scripts) even require it
# in script 10 we can notice that after downloading the vector layer from the service we have a MULTILINESTRING geometry
# convert this type to LINESTRING, i.e. simple lines

# first load the necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "arcgislayers")

# we load all watercourses in Czechia, which are used by the River Basin Authorities under the Ministry of Agriculture
watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> 
  st_sf()

# geometry type can be changed by the function st_cast()
watercourses_simplified <- watercourses |> 
  st_cast("LINESTRING")

# are there any watercourses that are (wrongly) split into multiple parts in the model?
watercourses_simplified |> 
  st_drop_geometry() |> # rather get rid of the geometry, otherwise the process would be very long
  group_by(idvt) |> # we are grouping by the IDs of watercourses
  count() |> 
  filter(n > 1)
