
# Loading vector geodata directly from a ZIP archive (saved) --------------

# shapefile wrapped in a ZIP archive is a fairly common occurrence
# if we have a downloaded ZIP archive on a local disk, it is not necessary to unpack it, but it is possible to load a vector geodata file from the archive directly

# first load the necessary packages
xfun::pkg_attach2("tidyverse",
                  "sf")

# the path to the ZIP file needs to be completed with the prefix '/vsizip'
# this way we can e.g. see what data is waiting for us in the archive
st_layers("/vsizip/geodata/dib_A05_Vodni_nadrze.zip")

# then a similar trick with the path can be applied when loading data
# note that the st_read() function also exists
# in both functions st_read() and read_sf() it is possible to write lowercase letters in the word 'WINDOWS'
reservoirs <- st_read("/vsizip/geodata/dib_A05_Vodni_nadrze.zip",
                      options = "ENCODING=windows-1250")

# there is a warning that there are more files to load in the ZIP file and that the first one has been selected
# this does not bother us at the moment (otherwise the warning can be removed by the layer name specification in the 'layer' argument)
reservoirs <- st_read("/vsizip/geodata/dib_a05_vodni_nadrze.zip",
                      options = "ENCODING=windows-1250",
                      layer = "a05_vodni_nadrze") # even here, ignoring the letter case works

# what is the difference in the loaded object compared to the one from script 01?

# result has no tibble class, which, otherwise, is much clearer
# there is a st_sf() function that when combined with as_tibble() will help
reservoirs <- reservoirs |> 
  as_tibble() |> 
  st_sf()

# condition must be satisfied that there is the presence of a column with geometry

# selecting layers using the "layer" argument also helps when working with the second archived object, which is just an attribute table
# first of all, it is about solving the character encoding problem again
supplement <- read_sf("/vsizip/geodata/dib_a05_vodni_nadrze.zip",
                      options = "ENCODING=windows-1250",
                      layer = "a05_doplnujici_charakteristiky")
