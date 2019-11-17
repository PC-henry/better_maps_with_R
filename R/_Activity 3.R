
# ACTIVITY 3
# Recreate choropleth using population grid data

# Check IRSD data is loaded

if(!exists("irsd")) source("R/_Activity 2.R")




# Read in population grid data as points

pop <- "data/Australian_Population_Grid_2011.tif" %>% 
  raster() %>%
  rasterToPoints(spatial = TRUE)




# Eyeball the dataframe features

summary(pop)




# Remove points with no population

pop <- pop %>% 
  subset(   
    pop$Australian_Population_Grid_2011 > 0
  ) 




# Convert to SF & reproject to shape CRS

pop <- pop %>% 
  st_as_sf() %>% 
  st_transform(shape_crs)




# Use spatial join function
# Left FALSE means keep only matched points

pop <- pop %>%
  st_join(shape, left = FALSE)




# Plot using ggplot 
# Note: takes a long time to load

ggplot() +
  # Background SA2s
  geom_sf(
    data = shape, 
    size = 1e-04
  ) +
  scale_fill_manual(
    values = c("grey", "white")
  ) +
  # Foreground points
  geom_sf(
    data = pop, 
    size = 1e-11, 
    aes(colour = Decile)
  ) +
  scale_color_brewer(
    palette = "Spectral"
  ) +
  # Theme 
  maptheme
  
