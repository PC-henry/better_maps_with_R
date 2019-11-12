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
