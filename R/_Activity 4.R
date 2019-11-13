

# Simplify map for visualisation/publication 

cmplx_size <- object.size(shape)
shape      <- ms_simplify(shape)
simpl_size <- object.size(shape)

message(
  simpl_size / cmplx_size, " of original size"
)




# Communication

for_report <- ggplot() %>% 
  geom_sf(data = shape, size=0.0001) +
  scale_fill_manual(values = c("grey", "white")) +
  geom_point(data = POP_GRID_SEIFA,
             aes(x = long, y = lat, 
                 color=factor(Decile)), size=0.0000000001, alpha=0.3) +
  scale_color_brewer(type="SEIFA", palette = "Spectral") +
  maptheme + coord_sf(xlim = c(110, 157), ylim = c(-45, -10), expand = FALSE) +
  theme(legend.position = "none")
  
for_web <- leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(
    fillColor   = ~pal(Score),
    fillOpacity = 0.7,
    weight      = 0.5, 
    color       = "grey"
  )
  

ggsave("map.png", SEIFA_Pop_Grid_SA2)

htmlwidgets::saveWidget(for_web, "map.html")

