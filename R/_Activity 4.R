
# ACTIVITY 4

# Clear all previous work & restart

rm(list = ls())
.rs.restartR()




# Load packages

library(sf)
library(leaflet)
library(rmapshaper)
library(htmlwidgets)
library(tidyverse)




# Read in full detail SA2 file

shape <- read_sf("data/SA2_2016_AUST.shp")




# Simplify map for visualisation/publication 

.cmplx_size <- object.size(shape)
shape       <- ms_simplify(shape)
.simpl_size <- object.size(shape)

message(
  round(.simpl_size / .cmplx_size, 2) * 100, 
  "% of original size"
)




# Communication

for_report <- shape %>% 
  filter(STE_NAME16 == "Tasmania") %>% 
  ggplot() +
  geom_sf()
  
for_web <- shape %>% 
  filter(STE_NAME16 == "Tasmania") %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons(label = ~SA2_NAME16)
  

ggsave("map.png", for_report)
saveWidget(for_web, "map.html")

