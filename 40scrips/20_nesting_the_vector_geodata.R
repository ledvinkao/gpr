
# Nesting the vector geodata ----------------------------------------------

# in vector geodata analyses, so-called nesting of attribute tables sometimes pays off
# when working with vector data, this property naturally offers itself, especially if the class of the attribute table is tibble

# let us demonstrate this property on our metadata of water-gauging stations, where information about the administrative region is missing
# information about belonging to the region can be obtained by a spatial query

# load necessary packages
xfun::pkg_attach2("tidyverse",
                  "RCzechia") # package sf is loaded automatically

# load the regions
regions <- kraje() |> 
  as_tibble() |> 
  st_sf()

# load station metadata and directly link to the regions
meta <- read_rds("metadata/wgmeta2024.rds") |> 
  st_transform(4326) |> 
  st_join(regions) |> 
  filter(!is.na(NAZ_CZNUTS3)) # getting rid of rows where the region is not in the end

# now we can nest according to the region and calculate e.g. the median area of the catchment above the station in each region
meta <- meta |> 
  group_by(NAZ_CZNUTS3) |> # studying the respective vignette (nest() function) is advised
  nest(data = -c(KOD_KRAJ:NAZ_CZNUTS3)) # minus sign means negation here

# there is a list-column that contains everything we wanted to nest
# using functional programming we get a new column with median area
meta <- meta |> 
  mutate(medarea = map_dbl(data,
                           \(x) st_drop_geometry(x) |> 
                             pull(plo_sta) |> 
                             median(x, 
                                    na.rm = T) |> # if missing values were present
                             round(2)
  )
  )
