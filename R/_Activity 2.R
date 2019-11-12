



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

