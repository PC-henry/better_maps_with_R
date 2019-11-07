
# When statistical areas lie – better maps with R
# Copyright (C) Productivity Commission 2019
# License: MIT (see LICENSE file)


# Load packages

library(tidyverse)
library(rmapshaper)
library(raster)
library(leaflet)
library(sf)




# Read in and eyeball data

shape <- read_sf("data/SA2_2016_AUST.shp") # DN need to fix +proj=longlat +datum=WGS84
shape




# Make an interactive map in 3 lines

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)




# Simplify map for visualisation/publication 

cmplx_size <- object.size(shape)
shape      <- ms_simplify(shape)
simpl_size <- object.size(shape)

message(
  simpl_size / cmplx_size, " of original size"
)




# Differenceing shapes 
# (removing Christmas and Cocos islands)

# Latlong of map boundaries

aus_box <- rbind(
  c(155, -9), 
  c(110, -9), 
  c(110, -45), 
  c(155, -45)
)




# Plot boundary 

leaflet(aus_box) %>% 
  addTiles() %>% 
  addPolygons()
  



# Convert to a polygon and match CRS

aus_box <- aus_box %>% 
  extent() %>% 
  as("SpatialPolygons") %>% 
  st_as_sf() %>% 
  st_set_crs(st_crs(shape))




# Trim the shapefile

shape <- st_intersection(shape, aus_box)




# Plot shape again

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)




