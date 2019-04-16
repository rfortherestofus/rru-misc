library(tidyverse)
library(here)

# This file brings in assets (data and CSS) from the assets repo (https://github.com/rfortherestofus/assets).

# Get Data ----------------------------------------------------------------

download.file("https://github.com/rfortherestofus/assets/raw/master/data/nhanes.csv",
              destfile = here("frequencies-three-ways", "nhanes.csv"))


# Get CSS -----------------------------------------------------------------

download.file("https://raw.githubusercontent.com/rfortherestofus/course-assets/master/style/style.css",
              destfile = here("assets", "style.css"))