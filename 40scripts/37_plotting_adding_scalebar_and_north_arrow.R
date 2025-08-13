
# Kreslení map v R - adding scalebar and north arrow ----------------------

# north arrow is not even that important if we have tools for drawing a grid
# but a scalebar should be a part of every map

# so let us demonstrate adding these map elements by using the functions of the tmap package
# we build on script 36, where we have already started working with facets

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia",
                  "arcgislayers",
                  "tmap")

watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> 
  st_sf()

watercourses_sel <- watercourses |> 
  filter(str_detect(naz_tok, "^Teplá Vltava|^Studená Vltava|^Berounka|^Mandava"))

# try to add the borders of Czechia
b <- republika()

# and plot
# plot may be assigned to an object beforehand
p <- tm_shape(b) + 
  tm_graticules() +
  tm_borders(col = "purple",
             lwd = 3) + 
  tm_shape(watercourses_sel,
           is.main = T,
           crs = 4326) + 
  tm_lines(col = "darkblue") + 
  tm_facets("naz_tok",
            ncol = 2) + 
  tm_compass(position = c("right",
                          "top"),
             show.labels = F) + # not to show the letter N for north (in Czech we use S)
  tm_scalebar(position = c("LEFT", # letter case matters
                           "BOTTOM"))

# we can save the result using the tmap_save() function, where we also can play around with height, width, scale, etc.
tmap_save(p,
          "results/selected_watercourses.pdf")
