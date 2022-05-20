# DST 234: Day 22 - Making interactive maps


# Review through this list - you may need to install some packages
library(tidyverse)
library(maps)
library(mapdata)
library(leaflet) # Making dynamic maps
library(leaflet.extras)   # For leaflet heatmaps
library(leaflet.providers)


# Task 1: Make an interactive map from a data frame

# Define data:
kuopio_data <- tibble(lat = 62.8980, lon = 27.6782)

# A very basic interactive map of Kuopio
kuopio_data %>%
  leaflet() %>%
  addTiles() %>%  # Puts in the geographic map
  addMarkers(lng = ~lon, lat = ~lat)

# YOUR TURN: Look up the latitude and longitude of an interesting place to you.
# Display that map.

gjilan_data <- tibble(lat = 42.4635, lon = 21.4694)

gjilan_data %>%
  leaflet() %>%
  addTiles() %>%  # Puts in the geographic map
  addMarkers(lng = ~lon, lat = ~lat)

# Task 1b
# Let's add some more data for context:
uef_data <- tibble(lat = c(62.8980,62.6010),
                   lon = c(27.6782,29.7636),
                   place = c("Kuopio","Joensuu"),
                   place_color = c("blue","red"))


# Dynamic map with cool popups
uef_data %>%
leaflet() %>%
  addTiles() %>%
  addMarkers(lng = ~lon,
             lat = ~lat) %>%
  addPopups(lng = ~lon,
            lat = ~lat,
            popup = ~place)

# Or you can do a city with a dot, and have the popup come up with the
uef_data %>%
leaflet() %>%
  addTiles() %>%
  addCircles(lng = ~lon,
             lat = ~lat,
             popup=~place,
             radius = 5000,
             color = ~place_color)  # Radius specified in meters!


uef_data %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lng = ~lon,
             lat = ~lat,
             popup=~place,
             radius = 5)  # Radius specified in pixels!

# YOUR TURN: Add 2 or 3 distinguishing features to your plot.
gjp_data <- tibble(lat = c(42.4635,42.6629),
                   lon = c(21.4694,21.1655),
                   place = c("Gjilan","Prishtina"),
                   place_color = c("purple","orange"))


gjp_data %>%
  leaflet() %>%
  addTiles() %>%
  addCircles(lng = ~lon,
             lat = ~lat,
             popup=~place,
             radius = 5000,
             color = ~place_color)  # Radius specified in meters!

#2nd example
gjptsh_data <- tibble(lat = c(42.6026,41.1533, 46.8182, 38.9637, 19.8563,15.8700,5.152149, 23.885942, 25.2866667,37,39.0742,60.1282),
                    lon = c(20.9030,20.1683, 8.2275, 35.2433, 102.4955, 100.9925, 46.199616,45.079162,51.5333333,127.5, 21.8243,18.6435),
                    place = c("Kosovo","Albania", "Switzerland", "Turkey","Laos","Thailand","Somalia","Saudi Arabia", "Qatar","South Korean", "Greece", "Sweden"),
                    capital = c("Prishtina", "Tirana", "Bern", "Ankara", "Vientiane","Bangkok", "Muqdisho","Riyadh","Doha","Seoul","Athens", "Stockholm"),
                    place_color = c("purple","orange", "red", "blue", "green", "yellow", "brown", "black", "pink", "white", "grey", "gold"))

gjptsh_data %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(lng = ~lon,
             lat = ~lat) %>%
  addCircles(lng = ~lon,
             lat = ~lat,
             popup=~place,
             radius = 100000,
             color = ~place_color)%>%
  addPopups(lng = ~lon,
            lat = ~lat,
            popup = ~place)%>%
  addCircleMarkers(lng = ~lon,
                   lat = ~lat,
                   popup=~paste("Name: ", place, "</br> Capital: ", capital),
                   radius = 5)# Radius specified in meters!


# Task 1c: adding even more context:
# The popup is an html code:
map2 <- uef_data %>%
  leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lng = ~lon,
             lat = ~lat,
             popup=~paste("Name: ", place, "</br> UEF campus"),
             radius = 5)

# Print the map to your screen by running this code
map2

# We can set the view - define the longitude, latitude, and zoom level
map2 %>%
  setView(lng=28,lat = 62, zoom=5)

# Zoom goes from 1 (world) to 18 (local)

# You can change them theme of the plot as well:
map2 %>%
  addProviderTiles(providers$OpenTopoMap)

# Go to: http://leaflet-extras.github.io/leaflet-providers/preview/index.html (NOTE: some require registration: https://github.com/leaflet-extras/leaflet-providers#providers)

# YOUR TURN: Add some more context to your map.

