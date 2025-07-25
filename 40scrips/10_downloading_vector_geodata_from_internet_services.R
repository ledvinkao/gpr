
# Downloading vector geodata from the internet ----------------------------

# there have been many cases lately where different vector geodata are shared through different servers
# we often encounter so-called ArcGIS REST API services, which is a consequence of the fact that many institutions use commercial ESRI licenses and do not have their own servers for this purpose
# so we often encounter vector geodata offered via so-called FeatureServers or MapServers
# there are multiple packages whose features allow you to get vector geodata from the internet, but currently the arcgislayers package has proven its worth

# load packages
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "arcgislayers")

# one of the many websites that offers open water management geodata through such services is the portal https://voda.gov.cz/
# here we can e.g. find a reference to a vector layer with an axis model of watercourses in Czechia and its immediate surroundings
# to load we need to know the link that can be found in the layer details
# we must not forget to also add the layer number (this must be the end of the link)
# when we do not specify the crs, the layer is loaded with the crs, which the service offers by default (in Czechia EPSG:5514)

watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> # for converting to the tibble-class simple feature collection
  st_sf()
