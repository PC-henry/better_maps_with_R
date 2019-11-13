
# Activity 2


# Make palette function using SEIFA 

pal <- colorNumeric(
  palette = "Spectral",
  domain = shape$Score
)




# Make an interactive choropleth

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(
    fillColor   = ~pal(Score),
    fillOpacity = 0.7,
    weight      = 0.5, 
    color       = "grey"
  )




# Create ggplot map theme object

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




# Set NA values to zero for charting

shape <- shape %>% 
  replace(is.na(.), 0)




# Create ggplot choropleth

ggplot() +
  geom_sf(
    data = shape, 
    size = 1 / 15,
    aes(fill = Score)
  ) +
  scale_fill_continuous() +
  maptheme 




# YOUR TURN
# Try to make a ggplot and a leaflet
# using decile data instead of 