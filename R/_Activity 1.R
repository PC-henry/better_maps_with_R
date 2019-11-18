
# ACTIVITY ONE
# Making a basic map


# Load packages

library(raster)     # Use raster data
library(leaflet)    # Interactive maps
library(sf)         # Simple features data
library(readxl)     # Read excel data
library(tidyverse)  # Charting and data manipulation




# Activity 1a. Making a basic map in ggplot2

# Read in and eyeball data

shape <- read_sf("data/Simple SA2.shp")

summary(shape)
head(shape)



# Set SA2_MAIN16 variable to numeric

shape <- shape %>% 
  mutate(
    SA2_MAIN16 = as.numeric(SA2_MAIN16)
  ) 



#Plot using ggplot2 and geom_sf()

ggplot(shape) +
  geom_sf()


# YOUR TURN
# Re-produce the ggplot
## Bonus content - Remove background information 
# - remove background axis, labels and grid


# Activity 1b. Make an interactive map

leaflet(shape) %>% 
  addTiles() %>% #adding layers to map. Using default base map - OpenStreetMap tiles.
  addPolygons(label = ~SA2_NAME16) #adding SA2 polygons

# YOUR TURN
# Re-create SA2s in leaflet


# Activity 1c. Differencing shapes 
# (removing Christmas and Cocos islands)

# Create a Lat/long of map boundaries

aus_box <- rbind( #Combining vector by rows
  c(155, -9), 
  c(110, -9), 
  c(110, -45), 
  c(155, -45),
  c(155, -9)
) 
summary(aus_box)


# Plot boundary 

leaflet(aus_box) %>% 
  addTiles() %>% 
  addPolygons() 



# CRS is not defined here - see warning message
# Save CRS from spatial file's metadata into shape_crs

shape_crs <- st_crs(shape) #retrieve the object's CRS




# Convert to a simple features polygon 

aus_box <- aus_box %>% 
  list() %>%            # Convert to list
  st_polygon() %>%      # Convert to sf polygon
  st_sfc %>%            # Convert to sf column
  st_sf %>%             # Convert to sf object 
  st_set_crs(shape_crs) # Set CRS




# Trim the shapefile

shape <- st_intersection(shape, aus_box)




# Plot shape again

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)


#YOUR TURN
#Use your own custom lat/long coordinates to create boundaries
#Or filter by State (STE_NAME16) to view specific States and Territories

# Activity 1a. ggplot bonus content 
# - removing background axis, labels and grid

ggplot() +
  geom_sf(data = shape) +
  theme(
    panel.grid.major = element_line(colour = "transparent"), 
    panel.grid.minor = element_blank(),
    panel.background = element_blank(), 
    axis.line        = element_blank(),
    axis.title       = element_blank(),
    axis.text        = element_blank(),
    axis.ticks       = element_blank()
  ) 


