
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




# Read in, save CRS and eyeball data

shape <- read_sf("data/SA2_2016_AUST.shp")
summary(shape)




# Make an interactive map in 3 lines

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)




# Copy CRS (Geocentric Datum of Australia)

shape_crs <- st_crs(shape)




# Set code columns to numeric

shape <- shape %>% 
  mutate(
    SA2_MAIN16 = as.numeric(SA2_MAIN16)
  ) 




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




# Read in ABS socioeconomic data

seifa <- read_excel(
  path  = "data/SA2 SEIFA.xls",
  sheet = "Table 1",
  range = "A6:D2197"
)




# Harmonise names with SA2 data

names(seifa) <- c(
  "SA2_MAIN16", # SA2 code
  "SA2_NAME16", # SA2 name
  "Score",      # SEIFA score
  "Decile"      # SEIFA decile
)




# Drop name column and reclass

seifa <- seifa %>% 
  select(-SA2_NAME16) %>% 
  mutate_all(as.numeric)




# Merge data 

shape <- shape %>% 
  left_join(seifa)




# Create a choropleth of seifa

pal <- colorNumeric(
  palette = "Spectral",
  domain = shape$Score
)

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(
    fillColor   = ~pal(Score),
    fillOpacity = 0.7,
    weight      = 0.5, 
    color       = "grey"
  )





