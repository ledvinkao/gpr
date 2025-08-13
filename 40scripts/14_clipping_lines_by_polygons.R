
# Clipping lines by polygons ----------------------------------------------

# although in other GIS software we know this activity as 'clipping', in R (better said in the sf package) this activity is replaced by the st_intersection() function
# in addition to geometry the function also solves attributes
# beware! not to confuse this function with the st_intersects() function, which does something else

# load the packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically
                  "arcgislayers")

# let us say we want to clip the layer of watercourses with the border of the South Bohemian Region

# load the layer with the regions and select only the South Bohemian Region
regions <- kraje()

sb <- regions |> 
  filter(NAZ_CZNUTS3 == "Jihočeský kraj")

# load the watercourses
watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> 
  st_sf()

watercourses_sb <- watercourses |>  
  st_intersection(st_transform(sb, st_crs(watercourses))) # we need to have the same crs (inherited here by the function st_crs())

ggplot() + 
  geom_sf(data = sb,
          col = "red",
          fill = NA,
          linewidth = 1.5) +
  geom_sf(data = watercourses_sb,
          col = "darkblue")
