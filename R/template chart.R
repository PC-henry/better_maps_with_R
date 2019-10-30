


# Load packages

library(tidyverse)
library(leaflet)
library(sf)




# Read in data

shape <- read_sf("data/SA2_2016_AUST.shp")




# Plot

shape %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons()
