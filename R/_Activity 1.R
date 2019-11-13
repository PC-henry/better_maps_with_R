# When statistical areas lie – better maps with R
# Copyright (C) Productivity Commission 2019
# License: MIT (see LICENSE file)


# Load packages

library(raster)
library(leaflet)
library(sf)
library(rmapshaper)
library(readxl)
library(tidyverse)

################################################
# Activity 1
# Making a basic map
################################################

# Activity 1a. Making a basic map in ggplot2

# Read in and eyeball data

shape <- read_sf("data/SA2_2016_AUST.shp")
summary(shape)
head(shape)

# Convert to simple features

shape <- shape %>% st_as_sf() 


#Plot using ggplot2 and geom_sf()

ggplot() +
  geom_sf(data = shape$geometry)+
  theme(
    axis.title = element_blank(),
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    rect = element_blank())



# Activity 1b. Make an interactive map

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)




# Activity 1c. Find the CRS (Geocentric Datum of Australia)

shape_crs <- st_crs(shape)




# Activity 1d. Set code columns to numeric

shape <- shape %>% 
  mutate(
    SA2_MAIN16 = as.numeric(SA2_MAIN16)
  ) 


# Activity 1e Differencing shapes (removing Christmas and Cocos islands)

# Create a Lat/long of map boundaries

aus_box <- rbind(
  c(155, -9), 
  c(110, -9), 
  c(110, -45), 
  c(155, -45),
  c(155, -9)
) 


# Plot boundary 

leaflet(aus_box) %>% 
  addTiles() %>% 
  addPolygons()


# Convert to a simple features polygon 

aus_box <- aus_box %>% 
  list() %>%            # Convert to list
  st_polygon() %>%      # Convert to polygon
  st_sfc %>%            # Convert to column
  st_sf %>%             # Convert to data frame
  st_set_crs(shape_crs) # Set CRS


# Trim the shapefile

shape <- st_intersection(shape, aus_box)


# Plot shape again

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)




