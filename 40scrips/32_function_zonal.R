
# Function zonal() --------------------------------------------------------

# in script 31, we did not consider the problem with a non-equal-area crs
# let us show how to face this problem e.g. in case of a categorical raster

# load necessary packages first
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically
                  "terra",
                  "geodata")

dem <- elevation_30s(country = "CZE",
                     path = "geodata",
                     mask = F)

# we let compute the slope inclination in degrees
slp <- terrain(dem,
               v = "slope",
               filename = "geodata/CZE_slp.tif",
               overwrite = T)

# let us demonstrate classification using a matrix with three columns
slp_cat <- classify(slp,
                    rcl = matrix(c(0, 5, 1,
                                   5, 10, 2,
                                   10, 15, 3,
                                   15, Inf, 4), # also the value Inf (infinity) is taken as a real value
                                 ncol = 3,
                                 byrow = T),
                    include.lowest = T)

# the cellSize() function is used to calculate the cell area
# so we can add another layer with cell area values to the raster layer with slope inclination categories
slp_cat <- c(slp_cat,
             area = cellSize(slp_cat)) # new layers can even take the name we want

# we see that the areas are different because we don not have the raster with an equal-area crs
slp_cat

# we still need a layer with polygons, so we take the regions again
regions <- kraje()

# concatenate the raster layers
# when rasterizing polygons we select, as the raster, again the object slp_cat to have the same geometry
# we take e.g. the name of the region from the vector layer to identify the field
slp_cat <- c(slp_cat,
             rasterize(regions,
                       slp_cat,
                       field = "NAZ_CZNUTS3"))

# now, it is time to apply the function zonal()
result <- zonal(slp_cat[[2]], # we want to summarize areas
                slp_cat[[c(3, 1)]],
                fun = "sum") |> 
  as_tibble() # originally the results are returned as a data frame, but we want a nicer output in the tibble class

# let us additionally determine the percentages of each slope category in each region
result <- result |> 
  pivot_longer(cols = -1,
               names_to = "slp_cat",
               values_to = "area") |> 
  mutate(area = units::set_units(area,
                                 "m2"),
         area = units::set_units(area,
                                 "km2"))

result <- result |> 
  group_by(NAZ_CZNUTS3) |> 
  mutate(percentage = (area / sum(area)),
         percentage = units::set_units(percentage, "%") |> 
           round(2))

# calculating shares in this way is more correct as it considers different raster cell areas
