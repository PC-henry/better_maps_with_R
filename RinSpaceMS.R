#install packages

# install.packages("raster")
# install.packages("leaflet")
# install.packages("rmapshaper")


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
head(shape)

shape <- shape %>% st_as_sf() #convert to simple features

ggplot() +
  geom_sf(data = shape$geometry)+
  theme(
  axis.title = element_blank(),
  axis.line = element_blank(),
  axis.text = element_blank(),
  axis.ticks = element_blank(),
  panel.grid = element_blank(),
  rect = element_blank())


# Make an interactive map in 3 lines

shape_inter <- leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)
shape_inter


# Copy CRS (Geocentric Datum of Australia)

shape_crs <- st_crs(shape)
shape_crs #EPSG: 4283, proj4string: "+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs" i.e. undefined.

# Set code columns to numeric

shape <- shape %>% 
  mutate(
    SA2_MAIN16 = as.numeric(SA2_MAIN16)
  ) 


# Simplify map for visualisation/publication 

cmplx_size <- object.size(shape) #memory usage
shape      <- ms_simplify(shape) #simplifies polygons or lines
simpl_size <- object.size(shape) #memory usage after simplification

message(
  simpl_size / cmplx_size, " of original size"
) #prints new memory usage as a proportion of original size (0.0894427666250876)


