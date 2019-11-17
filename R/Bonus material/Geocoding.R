
# Geocoding


# Clear environment and restart

rm(list = ls())
.rs.restartR()



# Load packages

library(ggmap)
library(leaflet)




# Load your google API key 
# This is an EXAMPLE ONLY and wont work

register_google(
  key = "mQkzTpiaLYjPqXQBotesgif3EfGL2dbrNVOrogg"
)




# Create some data to geocode

locations <- c(
    "Hotel Realm, Canberra",     # Business
    "4 National Circuit Barton", # Address
    "Canberra",                  # City
    "Mooseheads, Canberra"       # Dives
)



# Geocode
# Note plyr isn't great for multiple
# column assignment

locations <- locations %>% 
  geocode() %>% 
  cbind(locations)




# Plot 

leaflet(locations) %>% 
  addTiles() %>% 
  addMarkers(
    label = ~locations
  )




# Make it cool

moose <- makeIcon(
  "https://image.flaticon.com/icons/svg/2301/2301587.svg",
  iconWidth  = 50,
  iconHeight = 50
)
marker <- makeIcon(
  "https://image.flaticon.com/icons/svg/126/126470.svg",
  iconWidth  = 50,
  iconHeight = 50
)


leaflet(locations) %>% 
  addProviderTiles("Esri.WorldGrayCanvas") %>% 
  addMarkers(
    label = ~locations,
    icon  = iconList(marker, marker, marker, moose)
  )


