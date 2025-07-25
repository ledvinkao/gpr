
# Rasters and anonymous R functions vs. functions written in C++ ----------

# when applying a function to a raster, we need to distinguish between a function written in C++ and an R function
# anonymous functions assume R function applications and also consider a different strategy with rasters (e.g. they tend to process everything in RAM)
# R functions are generally slower, as we can demonstrate by measuring time

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia", # package sf is loaded automatically
                  "terra",
                  "geodata")

# compare different strategies to calculate the mean altitude in the regions
dem <- elevation_30s(country = "CZE",
                     path = "geodata",
                     mask = F)

regions <- kraje() |> 
  as_tibble() |> 
  st_sf()

# apply an anonymous function
tictoc::tic(); regions_a <- extract(dem,
                                    regions,
                                    fun = \(x) mean(x) |> 
                                      round(1),
                                    bind = T) |> 
  st_as_sf() |> 
  as_tibble() |> 
  st_sf(); tictoc::toc()

# now compare with the function implemented in C++
tictoc::tic(); regions_b <- extract(dem,
                                    regions,
                                    fun = mean,
                                    bind = T) |> 
  st_as_sf() |> 
  as_tibble() |> 
  st_sf() |> 
  mutate(CZE_elv = round(CZE_elv, 1)); tictoc::toc()

# differences naturally increase with increasing amount of data and sometimes it is not possible to apply procedure with an anonymous function because of RAM limits
