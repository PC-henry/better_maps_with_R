
# Activity 2


# Check SA2 data is loaded

if(!exists(shape)) source("R/_Activity 1.R")




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
# using the descrete decile data instead 
# the score data.