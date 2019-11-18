
# Correspondences


# Clear environment and restart

rm(list = ls())
.rs.restartR()



# Load packages

library(readxl)
library(tidyverse)




# Read in SA2 IRSD

irsd <- read_excel(
  path  = "data/SA2 SEIFA.xls",
  sheet = "Table 1",
  range = "A6:D2197"
)




# Clean IRSD

names(irsd) <- c(
  "SA2_MAIN16", 
  "SA2_NAME16", 
  "Score",      
  "Decile"      
)

irsd <- irsd %>% 
  select(-SA2_NAME16) %>% 
  mutate_all(as.numeric)




# Read in remoteness area correspondance

ra <- read_excel(
  path  = "data/CG_SA2_2016_RA_2016.xlsx",
  sheet = "Table 3",
  range = "A6:E2602"
)




# Clean remoteness areas

ra <- ra %>% 
  select(-SA2_NAME_2016, -RA_CODE_2016) %>% 
  rename(SA2_MAIN16 = SA2_MAINCODE_2016) %>% 
  filter(!is.na(SA2_MAIN16))
  



# Join data

irsd <- irsd %>% 
  left_join(ra)




# Weight when summarising

irsd %>% 
  group_by(RA_NAME_2016) %>% 
  summarise(
    `Weighted average` =
      sum(
        (Score * RATIO) / sum(RATIO, na.rm = T),
        na.rm = T
      )
  )