
# Catchment area calculation ----------------------------------------------

# similarly, the area of the watercourse catchment is a very important parameter in hydrology
# let us say we want to find out how many km2 are occupied by individual main drainage areas in Czechia

# first, load necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "arcgislayers")

# polygon layer with drainage areas can be replaced by polygons of 1st-order catchments
# this polygon layer can be found on the CHMI's open geodata wesite (see https://open-data-chmi.hub.arcgis.com/)
drain <- arc_read("https://services1.arcgis.com/ZszVN9lBVA5x4VmX/arcgis/rest/services/rozvodnice5G_1_radu/FeatureServer/2") |> 
  as_tibble() |> 
  st_sf()

# sometimes it happens that the vector layer is not valid
# it may be due to the fact that the current GIS works with the Google's open s2 library, which prefers to work on sphere rather than plane
# another reason may be that older GIS systems in which some layers were formed did not support the MULTIPOLYGON geometry, and that the POLYGON geometry (now incorrectly) represents multiple polygons for some simple feature rows
# and it is also the case of this polygon layer, as we can see by the function st_is_valid()
st_is_valid(drain)

# validity of geometry can be obtained by the function st_make_valid()
drain <- drain |> 
  st_make_valid()

drain |> 
  st_is_valid()

# now we can calculate areas, but before calculating them is necessary to transform the geometry to an equal-area crs
# in Europe, we use for area calculations the crs with EPSG:3035 (see https://epsg.io/3035)
drain <- drain |> 
  st_transform(3035) |> 
  mutate(area = st_area(geometry) |> 
           units::set_units("km2") |> 
           round(2))

# extract the columns we care about and throw away the geometry
drain_important <- drain |> 
  select(naz_pov,
         area) |> 
  st_drop_geometry()

# let us also note how convenient it is to have tables of the tibble class
# after applying the function units::set_units() here we have information about units under the column name
