
# Activity 2


# Check SA2 data is loaded

if(!exists("shape")) source("R/_Activity 1.R")





# Read in ABS socioeconomic data

irsd <- read_excel(
  path  = "data/SA2 SEIFA.xls",
  sheet = "Table 1",
  range = "A6:D2197"
)




# Harmonise names with SA2 data

names(irsd) <- c(
  "SA2_MAIN16", # SA2 code
  "SA2_NAME16", # SA2 name
  "Score",      # SEIFA score
  "Decile"      # SEIFA decile
)




# Drop name column and reclass

irsd <- irsd %>% 
  select(-SA2_NAME16) %>%         # Drop names
  mutate_all(as.numeric)          # All cols numeric
  




# Merge data 

shape <- shape %>% 
  left_join(irsd)




# Make palette function using IRSD 

pal <- colorFactor(
  palette = "Spectral",
  domain = shape$Decile
)




# Make an interactive choropleth

leaflet(shape) %>% 
  addTiles() %>% 
  addPolygons(
    fillColor   = ~pal(Decile),
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
  axis.ticks       = element_blank()
)




# Set NA values to zero for charting

shape <- shape %>% 
  replace(is.na(.), 0) %>%
  mutate(Decile = as.factor(Decile)) # Factor for charting




# Create ggplot choropleth

ggplot() +
  geom_sf(
    data = shape, 
    size = 1e-04,
    aes(fill = Decile)
  ) +
  scale_fill_brewer(palette = "Spectral") +
  maptheme 
  



# YOUR TURN
# Try to make a ggplot and a leaflet using the 
# descrete score data instead of the decile data.
# Try colorNumeric and scale_fill_continuous