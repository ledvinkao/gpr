
# Plotting maps in R - tmap and facets ------------------------------------

# as we know, even in ggplot2 concept we could draw a map (using geom_sf()) using facets
# ggplot2 strategy, however, does not allow free scales on axes when using the function, so it is advisable to reach for another tool

# for this example we find four rivers in the vector layer with watercourses: Teplá Vltava, Studená Vltava, Berounka and Mandava
# every river gets its own picture panel

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf",
                  "arcgislayers",
                  "tmap")

# select the wanted watercourses
watercourses <- arc_read("https://agrigis.cz/server/rest/services/ISVSVoda/osy_vodnich_linii/FeatureServer/0") |> 
  as_tibble() |> 
  st_sf()

# we make use the possibility to insert a regular expression into the str_detect() function
watercourses_sel <- watercourses |> 
  filter(str_detect(naz_tok, "^Teplá Vltava|^Studená Vltava|^Berounka|^Mandava"))

# let us plot
tm_shape(watercourses_sel,
         crs = 4326) + # rather select a more natural crs for showing meridians and parallels
  tm_graticules() + # this way, a grid from meridians and parallels may be drawn
  tm_lines(col = "darkblue") +
  tm_facets("naz_tok",
            ncol = 2,
            free.coords = T) # very important, set as TRUE by default, but it is there because of the option to switch to FALSE

# if there was enough space, the coordinates of all axes would be drawn
