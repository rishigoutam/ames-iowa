# We want to do eda visually by location

library(tidyverse)
library(usmap)
library(ggmap)
library(RgoogleMaps)
library(leaflet)

ames <- read.csv("data/housing_geolocation.csv")
ames <- ames %>%
  select("PID", "SalePrice", "latitude", "longitude", "Neighborhood") %>%
  relocate(any_of(c("longitude", "latitude"))) %>%
  drop_na()  # we don't have lat/long for all PIDs

length(ames$PID)

# Plot using usmap
# Story county, Iowa FIPS code 19169
ames_t <- usmap_transform(ames)
plot_usmap("counties", include = c("IA")) +
  geom_point(data = ames_t,
             aes(x = longitude.1, y = latitude.1, color = SalePrice),
             shape = ".", alpha = 0.9) +
  theme(legend.position = "right")

plot_usmap("counties", include = c("19169")) +
  geom_point(data = ames_t,
             aes(x = longitude.1, y = latitude.1, color = SalePrice),
             shape = ".", alpha = 0.9) +
  scale_colour_gradient(low = "lightyellow", high = "darkred") +
  theme(legend.position = "right")

# Plot using google maps need API key
# center = c(mean(ames$longitude), mean(ames$latitude))
# gmap <- get_map(location = center, zoom = 12,
#                       maptype = "satellite", scale = 2)
# ggmap(gmap) +
#   geom_point(data = ames,
#              aes(x = longitude, y = latitude, fill = "red", alpha = 0.8),
#              size = 5, shape = 21) +
#   guides(fill=FALSE, alpha=FALSE, size=FALSE)


# Using RgoogleMaps
center = c(mean(ames$latitude), mean(ames$longitude))
terrmap <- GetMap(center=center, zoom=12, type= "satellite", destfile = "terr.png")
PlotOnStaticMap(terrmap, lat = ames$latitude, lon = ames$longitude)

# Plot using ggplot
ggplot() +
geom_point(data = ames,
           aes(x = longitude, y = latitude, color = SalePrice),
           shape = 19, alpha = 0.7) +
  scale_color_gradient(low = "lightyellow", high = "darkred") +
  theme(legend.position = "right")

## TODO get CollapsedNeighboor (max six types)
# ggplot(data = ames, aes(shape = Collapsed_Neighborhood)) +
#   geom_point(aes(x = longitude, y = latitude, color = SalePrice),
#              alpha = 0.7) +
#   scale_color_gradient(low = "lightyellow", high = "darkred") +
#   theme(legend.position = "right")

# Plot using leaflet
# TODO bin SalePrice and pass it as color to addCircles
leaflet(ames) %>% addCircles() %>% addTiles()

