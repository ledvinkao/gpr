
# Plotting maps in R - tmap package modes ---------------------------------

# currently, for drawing maps in R, probably the most elaborated package is tmap
# actually, it does not need to be about maps at first, but it may be more about drawing sketches to see if we are in the right territory with our analyses
# package tmap has one great feature, namely that we can draw geodata into dynamic representations (with valuable basemaps)

# plot polygons of administrative regions of Czechia

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia",
                  "tmap")

regions <- kraje() |> 
  as_tibble() |> 
  st_sf()

# static representation first (like in ggplot2 case we chain with the operator +)
tm_shape(regions) + 
  tm_polygons(col = "purple",
              fill = "magenta",
              fill_alpha = 0.3)

# now a dynamic representation
# we need to switch to the 'view'´mode
tmap_mode("view")

tm_shape(regions) + 
  tm_polygons(col = "purple",
              fill = "magenta",
              fill_alpha = 0.3)

# we can get back into drawing static maps as follows
tmap_mode("plot")

# we can plot only borders instead of polygons
tm_shape(regions) +
  tm_borders(col = "purple")
