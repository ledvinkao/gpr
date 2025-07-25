
# Two and more geometries of vector geodata -------------------------------

# simple feature collections can easily have more geometries
# it may come in handy if we need more geometries to calculate some characteristic
# there are characteristics where e.g. we need one crs with the least distortion of lengths and the second with an equal-area crs

# let us find out how much the shapes of individual administrative regions of Czechia differ from a circle
# for these purposes there is a so-called Graveli coefficient

# load the necessary packages first
xfun::pkg_attach2("tidyverse",
                  "RCzechia") # package sf loaded automatically

# load the region polygons
regions <- kraje() |> 
  as_tibble() |> 
  st_sf()

# we already know that on the territory of Czechia it is possible to use the crs with EPSG:5514 for calculation of lengths
# for area calculation we use the crs with EPSG:3035
# so let us transform the geometry that is now in the crs with EPSG:4326
regions <- regions |> 
  mutate(geom1 = st_transform(geometry,
                              5514),
         geom2 = st_transform(geometry,
                              3035))

# indeed, now we have three geometric columns, as one can see
regions

# let us say we do not care about the original geometry anymore
# so we throw away the first geometric column
regions <- regions |> 
  st_drop_geometry()

# now, calculate the perimeters of polygons
# as well the polygon areas
# let us compute them in m and m2, respectively
# the calculation is done even if we lost the sf class after applying the st_drop_geometry() function
regions <- regions |> 
  mutate(perim = st_perimeter(geom1),
         area = st_area(geom2))

# now we are ready to calculate the Graveli coefficients (see e.g. Riedl and Zachar, 1984, p. 14)
regions <- regions |> 
  mutate(graveli = perim / 2 / sqrt(pi * area))

# since the result is a table (not a simple feature collection), we can remove other unnecessary columns accordingly
regions <- regions |> 
  select(-c(geom1, geom2)) |> 
  mutate(perim = NULL, # this way we also can remove columns
         area = NULL)


# Literature --------------------------------------------------------------

# Riedl, O. and Zachar, D.: Forest Amelioration, Elsevier, Amsterdam, 623 pp., 1984.
