library(tidyverse)
library(sf)
library(AmesHousing)

ames <- read.csv("data/engineered.csv")

# Get PID's school district where possible------------------------------------

ames_sf <- st_as_sf(ames, coords = c("longitude", "latitude"),
                    crs = st_crs(ames_school_districts_sf))

district_sf <- ames_sf %>%
  mutate(
    intersection = as.integer(st_intersects(geometry, ames_school_districts_sf)),
    district = if_else(is.na(intersection),
                       '',
                       as.character(ames_school_districts_sf$district[intersection]))
  ) %>%
  select(PID, district)

districts <- st_drop_geometry(district_sf) %>%
  mutate(district = word(district, 1))

write_csv(districts, "data/districts.csv")
