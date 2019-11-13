
# Moved this bit of code from Activity 1 to activity 2**********************************

################################################
# Activity 2
##Choropleth using ggplot
################################################


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

