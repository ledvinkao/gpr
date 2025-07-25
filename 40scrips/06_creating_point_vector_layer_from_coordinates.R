
# Creation of (point) vector geodata from given coordinates ---------------

# sometimes it happens that we do not have a vector layer directly
# but we can use the knowledge of coordinates and coordinate reference system (crs)
# let us have metadata of water-gauging stations that can be retrieved from a JSON file with the address https://opendata.chmi.cz/hydrology/historical/metadata/meta1.json
# this metadata contains two columns with coordinates and we know that the crs is the one with EPSG code 4326

# load packages
# extra package jsonlite here for easier work with JSON files
xfun::pkg_attach2("tidyverse",
                  "jsonlite",
                  "sf")

# transform into a table
# we use knowledge about the structure (where are the data and where are the headers)
url <- "https://opendata.chmi.cz/hydrology/historical/metadata/meta1.json"

meta <- jsonlite::fromJSON(url) # sometimes you need to set in a .Renviron file CURL_SSL_BACKEND=openssl

meta <- meta$data$data$values |> 
  as.data.frame() |> 
  as_tibble() |> 
  set_names(meta$data$data$header |> 
              str_split(",") |> 
              unlist()) |> 
  janitor::clean_names() # adjust column names to more reasonable (package janitor needs to be installed)

# vector layer (simple feature collection) is obtained by function st_as_sf()
# function st_as_sf() is different from function st_sf()
# function st_as_sf() creates new geometry, whereas function st_sf() already requires some geometry in the table
meta <- meta |> 
  mutate(across(geogr1:plo_sta, # we change the type of some columns (if it makes sense, we convert to numeric)
                as.numeric)) |> 
  st_as_sf(coords = c("geogr2", "geogr1"), # longitude first, then latitude
           crs = 4326) |> 
  st_transform(32633) # we prefer to transform to avoid problems with changing the order of coordinates, as today's versions of the PROJ library do

# it may happen that the columns with character strings will have an incorrect representation of missing values
# this may be addressed as follows
meta <- meta |> 
  mutate(across(where(is.numeric),
                \(x) if_else(x == "", NA, x))
  )

# save for further work
meta |> 
  write_rds("metadata/wgmeta2024.rds",
            compress = "gz")
