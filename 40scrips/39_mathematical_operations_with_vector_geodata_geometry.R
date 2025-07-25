
# Mathematical operations with vector geodata geometry --------------------

# a geometry column of vector geodata is in fact of class list
# so we can do mathematical operations with it, such as addition or multiplication
# this property can be useful e.g. when systematically shifting points a few meters/kilometers in any direction

# let us demonstrate while using metadata from the Air Quality Section of the CHMI
# (can be retrieved at https://opendata.chmi.cz/air_quality/historical/)

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "arrow",
                  "RCzechia", # package sf is loaded automatically
                  "tmap")

# not to delay, we have the metadata (state to March 2025) already prepared in an Apache Parquet file airquality_metadata_pq
# Apache Parquet files can be treated like SQL databases
# establish a pointer to the file
aqmeta <- open_dataset("metadata/airquality_metadata_pq")

# say we want to limit ourselves to the O3 element
o3 <- aqmeta |> 
  filter(VELICINA_ZKRATKA == "O3") |> 
  collect() # this way we get the filtered table into the RAM

# convert to a sf collection
# and transform to the planar crs where we have meters as units
o3 <- o3 |> 
  st_as_sf(coords = c("ZEMEPISNA_DELKA",
                      "ZEMEPISNA_SIRKA"),
           crs = 4326) |> 
  st_transform(32633)

# try to plot
tm_shape(republika() |> 
           st_transform(32633)) + # aby byly crs stejné
  tm_borders(lwd = 3,
             col = "purple") +
  tm_shape(o3) +
  tm_dots(col = "grey20",
          size = 0.2)

# try to shift the points 10 km to the west and 10 km to the south
o3_shift <- o3 |> 
  mutate(geometry = geometry + c(-10000, -10000)) |> 
  st_set_crs(32633) # due to addition, we lose the information on crs, so we can set it again

# let us plot
tm_shape(republika() |> 
           st_transform(32633)) + 
  tm_borders(lwd = 3,
             col = "purple") +
  tm_shape(o3_shift) +
  tm_dots(col = "grey20",
          size = 0.2)
