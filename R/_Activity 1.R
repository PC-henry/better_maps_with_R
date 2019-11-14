
# ACTIVITY ONE
# Making a basic map


# Load packages

library(raster)     # Use raster data
library(leaflet)    # Interactive maps
library(sf)         # Simple features data
library(rmapshaper) # Simplify polygons
library(readxl)     # Read excel data
library(tidyverse)  # Charting and data manipulation


# Activity 1a. Making a basic map in ggplot2

# Read in and eyeball data

shape <- read_sf("data/Simple SA2.shp")

summary(shape)
head(shape)

# Activity 1d. Set code columns to numeric

shape <- shape %>% 
  mutate(
    SA2_MAIN16 = as.numeric(SA2_MAIN16)
  ) 


#Plot using ggplot2 and geom_sf()

ggplot() +
  geom_sf(data = shape$geometry)


# Activity 1b. Make an interactive map

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)


# Activity 1e. Differencing shapes (removing Christmas and Cocos islands)

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


# Activity 1a. ggplot bonus content - removing background axis, labels and grid
ggplot() +
  geom_sf(data = shape$geometry)+
theme(
  axis.title = element_blank(),
  axis.line  = element_blank(),
  axis.text  = element_blank(),
  axis.ticks = element_blank(),
  panel.grid = element_blank(),
  rect       = element_blank()
) 

