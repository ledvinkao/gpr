
# Drawing RGB composites --------------------------------------------------

# sometimes it is advisable to prepare the visible bands and draw the so-called RGB composite

# load the necessary packaged first
# we assume, however, that we also have the package stars with data
xfun::pkg_attach2("tidyverse",
                  "terra")

# load the file
landsat <- rast(system.file("tif/L7_ETMs.tif",
                            package = "stars"))

# RGB comination is not prepared yet
has.RGB(landsat)

# so we prepare it with a suitable selection of bands (each mission can have this in a different way!)
RGB(landsat) <- c(3, 2, 1)

has.RGB(landsat)

# so we plot now
plot(landsat)
