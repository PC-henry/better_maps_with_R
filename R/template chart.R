
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


################################################
# Activity 2
##Choropleth using ggplot
################################################


# Create map theme objects

maptheme <- theme(
  panel.grid.major = element_line(colour = "transparent"), 
  panel.grid.minor = element_blank(),
  panel.background = element_blank(), 
  axis.line        = element_blank(),
  axis.title       = element_blank(),
  axis.text        = element_blank(),
  axis.ticks       = element_blank(),
  legend.position  = "none"
)

linesize <- 0.0001




# Set NA values to zero for charting

shape <- shape %>% 
  replace(is.na(.), 0)




# Create ggplot choropleth

ggplot() +
  geom_sf(
    data = shape, 
    size = 1 / 15,
    aes(fill = factor(Decile))
  ) +
  scale_fill_brewer(
    type    = "SEIFA", 
    palette = "Spectral"
  ) +
  maptheme 



################################################
# Activity 3: Recreate choropleth using population grid data
################################################

#################################
# import and clean Aus pop grid data
#################################

# read in population grid data
ABSpop <- raster("data/Australian_Population_Grid_2011.tif")

# Convert raster to SpatialPointsDataFrame
r.pts <- rasterToPoints(ABSpop, spatial=TRUE)

# reproject sp object
geo.prj <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" 
r.pts <- spTransform(r.pts, CRS(geo.prj)) 

# Assign coordinates to @data slot, display first 6 rows of data.frame
r.pts@data <- data.frame(r.pts@data, long=coordinates(r.pts)[,1],
                         lat=coordinates(r.pts)[,2])  

#save as data.frame
Aus_pop_centres  <- as.data.frame(r.pts)

###select only latitude longditude and number of service type
Aus_pop_centres <- Aus_pop_centres[,c(1:3)]

###remove zero values
Aus_pop_centres <- Aus_pop_centres %>% filter(Australian_Population_Grid_2011 != 0)



#################################
##Converitng Lat long to SA2
#################################

## Lat long to SA2 (ASGS Package)
# ASGS.foyer::install_ASGS()
library(ASGS)

centres_SA2 <- as.data.frame(latlon2SA(Aus_pop_centres$lat, Aus_pop_centres$long, to = "SA2",yr = "2016",return = "v"))

# Merge back to origional pop centre data 
POP_SA2 <- cbind(Aus_pop_centres,centres_SA2) %>%
  rename(SA2_NAME16=`latlon2SA(Aus_pop_centres$lat, Aus_pop_centres$long, to = "SA2", yr = "2016", return = "v")`)

#### Merge SEIFA into population centers data based on SA2
POP_GRID_SEIFA <- left_join(POP_SA2, shape, by="SA2_NAME16")

# Replace missing SEIFA 
POP_GRID_SEIFA[is.na(POP_GRID_SEIFA)] <- 0



#################################
### Plot using ggplot 
#################################

SEIFA_Pop_Grid_SA2 <- ggplot() +
  geom_sf(data = shape, size=linesize) +
  scale_fill_manual(values = c("grey", "white")) +
  geom_point(data = POP_GRID_SEIFA,
             aes(x = long, y = lat, 
                 color=factor(Decile)), size=0.0000000001, alpha=0.3) +
  scale_color_brewer(type="SEIFA", palette = "Spectral") +
  maptheme + coord_sf(xlim = c(110, 157), ylim = c(-45, -10), expand = FALSE) +
  theme(legend.position = "none")


ggsave(("data/Population_centres_Aus_SEFIA_SA2.png"),
       SEIFA_Pop_Grid_SA2,
       width = 15, height = 8.5 , units = "cm")

