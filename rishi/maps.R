# We want to do eda visually by location

library(tidyverse)
library(usmap)
library(ggmap)
library(RgoogleMaps)
library(leaflet)
library(AmesHousing)
library(sf)
library(scales)

# Read data and select columns ---------------------------------------------
ames_locations <- read.csv("data/ames_locations.csv")

ames <- read.csv("data/engineered.csv")
ames <- ames %>%
  relocate(any_of(c("longitude", "latitude"))) %>%
  drop_na()  # we don't have lat/long for all PIDs

# Plot using various libraries ---------------------------------------------
# Using usmap
# Story county, Iowa: FIPS code 19169
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

# Using ggplot
ggplot() +
geom_point(data = ames,
           aes(x = longitude, y = latitude, color = SalePrice),
           shape = 19, alpha = 0.8) +
  scale_color_gradient(low = "lightgreen", high = "darkred") +
  theme(legend.position = "right")

## TODO get CollapsedNeighbor (max six types)
# ggplot(data = ames, aes(shape = Collapsed_Neighborhood)) +
#   geom_point(aes(x = longitude, y = latitude, color = SalePrice),
#              alpha = 0.7) +
#   scale_color_gradient(low = "lightyellow", high = "darkred") +
#   theme(legend.position = "right")

# Plot using leaflet
# TODO bin SalePrice and pass it as color to addCircles
leaflet(ames) %>% addCircles() %>% addTiles()


# Plot on School Districts ---------------------------------------------------

# Districts alone
ggplot() +
  # Districts
  geom_sf(data = ames_school_districts_sf,
          fill = factor(ames_school_districts_sf$fill_color)) +
  geom_sf_label(data = ames_school_districts_sf,
                aes(label = word(district, 1))) +
  coord_sf(datum = NA) +
  xlab("") +
  ylab("") +
  theme(
    panel.background = element_rect(fill='transparent'), #transparent panel bg
    plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
    panel.grid.major = element_blank(), #remove major gridlines
    panel.grid.minor = element_blank(), #remove minor gridlines
    legend.background = element_rect(fill='transparent'), #transparent legend bg
    legend.box.background = element_rect(fill='transparent') #transparent legend panel
  )


# Overlay numerical feature on Districts
plot_feature_on_districts <- function(feature, title, label_title) {
  # Set level/shape for institution type (Type column)
  institution_levels = c("Preschool", "Elementary", "Middle School", "High School", "University", "Hospital")
  institution_shapes = c(18, 20, 17, 15, 14, 3)
  ames_locations$Type <- factor(ames_locations$Type, levels = institution_levels)

  ggplot() +
    # Districts
    geom_sf(data = ames_school_districts_sf,
            fill = factor(ames_school_districts_sf$fill_color)) +
    # Properties
    geom_point(data = ames,
               aes(x = longitude, y = latitude, color = feature),
               shape = 19, alpha = 0.8) +
    scale_color_gradient(low = "lightgreen", high = "darkred", labels = comma) +
    theme(legend.position = "right") +
    # Schools TODO create a df with schools (by type), uni, hospital
    geom_point(data = ames_locations,
               aes(x = Longitude, y = Latitude, shape = Type),
               size = 2) +
    scale_shape_manual(values = institution_shapes) +
    geom_text(data = ames_locations, label = ames_locations$Location,
              aes(x = Longitude, y = Latitude),
              vjust="bottom", hjust="left", size = 3) +
    labs(title = title, color = label_title, shape = "Public Institution") +
    xlab("Longitude") +
    ylab("Latitude")
}

# Overlay categorical feature on Districts
plot_cat_feature_on_districts <- function(feature, title, label_title) {
  # Set level/shape for institution type (Type column)
  institution_levels = c("Preschool", "Elementary", "Middle School", "High School", "University", "Hospital")
  institution_shapes = c(18, 20, 17, 15, 14, 3)
  ames_locations$Type <- factor(ames_locations$Type, levels = institution_levels)

  ggplot() +
    # Districts
    geom_sf(data = ames_school_districts_sf,
            fill = factor(ames_school_districts_sf$fill_color)) +
    # Properties
    geom_point(data = ames,
               aes(x = longitude, y = latitude, shape = feature, color = SalePrice),
               alpha = 0.8) +
    theme(legend.position = "right") +
    labs(title = title, shape = label_title) +
    xlab("Longitude") +
    ylab("Latitude")
}

# Numerical features
plot_feature_on_districts(ames$SalePrice, "Property Sale Prices (2006-2010)", "Sale Price")
plot_feature_on_districts(ames$Combine_Age, "Time Since Renovation", "Years")
plot_feature_on_districts(ames$YearBuilt, "Year Built", "Year")

# Categorical features
plot_cat_feature_on_districts(ames$MSZoning, "Zone", "Zone")
plot_cat_feature_on_districts(ames$IsPUD, "PUD", "PUD")

plot_cat_feature_on_districts(ames$LandContour, "Land Contour", "Land Contour")
ames$IsNearNegativeCondition <- as_factor(ames$IsNearNegativeCondition)
plot_cat_feature_on_districts(ames$IsNearNegativeCondition, "Near Roads of Railways", "Near Roads of Railways")
plot_cat_feature_on_districts(ames$LandContour, "Land Contour", "Land Contour")
ames$Collapse_MSSubClass <- as_factor(ames$Collapse_MSSubClass)
plot_cat_feature_on_districts(ames$Collapse_MSSubClass, "Subclass", "Subclass")
plot_cat_feature_on_districts(ames$district, "district", "district")
