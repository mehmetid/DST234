# DST 234: Day 25 - Machine learning

# Load up our usual libraries
library(tidyverse)
library(mdsr)
library(mclust)  # You may need to install this library

### EXAMPLE 1: Clustering by longitude and latitude
# Let's look at the 4000 largest cities - we will be re-using this data frame
big_cities <- world_cities %>%
  arrange(desc(population)) %>%
  head(4000)

glimpse(big_cities)

# Now we do a 6-means cluster.
city_clusts <- big_cities %>%
  select(longitude, latitude) %>% # Variables we are clustering
  kmeans(centers = 6) %>%
  fitted("classes") %>%
  as.character()

# Add the clusters onto the big_cities data frame
big_cities_clust <- big_cities %>%
  mutate(cluster = city_clusts)

# Then we plot the clusters
big_cities_clust %>%
  ggplot(aes(x = longitude, y = latitude)) +
  geom_point(aes(color = cluster), alpha = 0.5)  +
  scale_color_brewer(palette = "Set2")

### EXAMPLE 1A: Clustering by population

# Step 1: Do the clustering, and extract out a vector of each cluster:
population_clusts <- big_cities %>%
  select(population) %>% # The variable we are clustering by
  kmeans(centers = 6) %>% # The number of clusters
  fitted("classes") %>% # Just extract the classes for each data point
  as.character()

# Step 2: Add the clustering back to your data frame
population_mutated <- big_cities %>%
  mutate(cluster = population_clusts)

# Step 3: Make your plot
population_mutated %>%
  ggplot(aes(x = longitude, y = latitude)) +
  geom_point(aes(color = cluster), alpha = 0.5)


### EXAMPLE 2: SAT Scores: does more per-pupil spending lead to higher scores?

# Exploratory data plot:
SAT_2010 %>%
  ggplot(aes(x = expenditure, y = total)) +
  geom_point()

# Step 1: Do the clustering, and extract out a vector of each cluster:
SAT_clusts <- SAT_2010 %>%
  select(total,expenditure) %>% # The variables we are clustering by
  kmeans(centers = 2) %>%  # Split this up into two groups
  fitted("classes") %>%  # The number of clusters
  as.character() # Just extract the classes for each data point

# Step 2: Add the clustering back to your data frame
SAT_mutated <- SAT_2010 %>%
  mutate(cluster = SAT_clusts)

# Step 3: Make your plot
SAT_mutated %>%
  ggplot(aes(x = expenditure, y = total)) +
  geom_point(aes(shape = cluster, color = sat_pct)) 

# Why would this be the case? Explore the variables:
glimpse(SAT_2010)

