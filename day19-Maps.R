### DST 234, Day 19: Making maps with R
### (Chapter 17 from MDSR)

# Install these packages if you haven't already  (you may need to uncomment)
#install.packages(c("maps", "mapdata"))

library(tidyverse)
library(maps)
library(mapdata)

# NOTE: This file contains blank spaces for code that you will need to fill in

### Example 0: Maps are polygons!
# Define our polygon
polygon_example <- tibble(
  x = c(1, 2, 2, 3, 4, 4),
  y = c(1, 1, 2, 2, 2, 3),
  which_poly = c("a", "a", "a", "b", "b", "b")
)


polygon_example %>%
  ggplot() +
  geom_point(aes(x = x, y = y, color = which_poly)) +
  geom_polygon(aes(x = x, y = y, group = which_poly))

# What happens when you leave out the group?
polygon_example %>%
  ggplot() +
  geom_polygon(aes(x = x, y = y))



# Task 1: Let's make some simple maps.  We need to first determine the polygons, using the command map_data

usa <- map_data("usa") # creates a map polygon of the USA
glimpse(usa)   # Let's see what is in this data frame

#the filled one
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) +
  coord_fixed(ratio = 1.3)

# Task 1a: Make a map of the USA - note the connections to ggplot.
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat)) +
  coord_fixed(ratio = 1.3)

# coord_fixed is the aspect ratio, expressed as x / y.  An aspect ratio of 1.3 usually gives a good scaling.

### Task 1b: Let's make the border fixed:
ggplot() +
  geom_polygon(data = usa, aes(x=long, y = lat), fill = NA, color = "red") +
  coord_fixed(1.3)

# Why was that plot so bad?  Partly because the polygons are connecting points that shouldn't be.  We need to add a group aesethetic:

ggplot() +
  geom_polygon(data = usa, aes(x=long, y = lat,group=group), fill = NA, color = "red") +
  coord_fixed(1.3)

# Task 1c: Let's change the fill and adjust the transparency (alpha)

### --> FILL IN THE CODE WITH YOUR SOLUTION
ggplot() +
  geom_polygon(data = usa, aes(x = long, y = lat, group = group), fill = "orange", color = "brown", alpha = 0.8) + 
  coord_fixed(1.5)
                 


# YOUR TURN: Change the fill, color, and alpha levels to your choice.


# Task 2: Let's make a map of the US states.
states <- map_data("state")
head(states)

# Make a map that shows the outlines of all the states

ggplot() + geom_polygon(data = states, aes(x=long, y = lat,group=group),fill=NA,color="red") +
  coord_fixed(ratio = 1.3)

# Task 2b: Let's make your first chloropleth map:
ggplot(data = states) +
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") +
  coord_fixed(1.3) +
  guides(fill="none")  # do this to leave off the color legend

# Task 2c: Make a chloropleth map of population
# To color code by population we are going to use the data frame state.x77.  Let's investigate this first:
?state.x77

# Ok, it looks like the population of the US in 1977 (?, random - whatever)
# To get this connected here we will need to:
# (1) Make state.x77 into a data frame
# (2) join to our states map data frame
# (3) add a fill level to our ggplot statement


# Notice that if we join on the states, we need to do some tidying:
glimpse(states)
glimpse(state.x77)

state_x77_df <- state.x77 %>%
  data.frame() %>%
  rownames_to_column(var="state") %>%
  mutate(state=str_to_lower(state))  # Convert the state names to lowercase (so we can join together)

# Now let's join this up!
states_joined <- inner_join(states,state_x77_df,by=c("region"="state"))

# We are now ready to make a chloropleth map:
ggplot(data = states_joined) +
  geom_polygon(aes(x = long, y = lat, fill = Population, group = group), color = "white") +
  coord_fixed(1.3) +
  ggtitle('US Population in 1977')


# Task 2d: Let's make a US map of all the counties:
counties <- map_data("county")


### --> FILL IN THE CODE WITH YOUR SOLUTION
ggplot(data = counties) +
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") +
  coord_fixed(1.3) +
  guides(fill="none")

# Task 3: Let's make a map of Minnesota
mn <- map_data("state", "Minnesota")

ggplot() + geom_polygon(data = mn, aes(x=long, y = lat, group = group), color = "white") +
  coord_fixed(1.3)

# YOUR TURN: Make a map of the counties in Minnesota
### --> FILL IN THE CODE WITH YOUR SOLUTION
counties %>%
  filter(region == "minnesota") %>%
ggplot() + 
  geom_polygon(aes(x = long, y = lat, fill = subregion, group = group)) +
  coord_fixed(1.3) +
  guides(fill="none")
  


# Task 4: Let's make a map of Minnesota & Wisconsin
mnwi <- map_data('state',region=c('minnesota','wisconsin'))  # Notice upper case or lower case doesn't matter

ggplot() + geom_polygon(data = mnwi, aes(x=long, y = lat, group = group)) +
  coord_fixed(1.3)


# Task 5: Now let's zoom out and make a boundary map of the world:
world <- map_data("world")


### --> FILL IN THE CODE WITH YOUR SOLUTION
ggplot() + geom_polygon(data = world, aes(x = long, y = lat, group = group), fill = NA, color = "purple") +
  coord_fixed(1.5)


# Also compare this to world2:
world2 <- map_data("world2")

ggplot() +
  geom_polygon(data = world2, aes(x=long, y = lat,group=group),fill=NA,color="purple") +
  coord_fixed(ratio = 1.3)

# Map is centered on the "anti - meridian"
# See: https://en.wikipedia.org/wiki/Prime_meridian
# Why can't we recenter to an arbitrary location?
# Turns out it is tricky - see this website:
# https://stackoverflow.com/questions/10620862/use-different-center-than-the-prime-meridian-in-plotting-a-world-map


# Task 6: YOUR TURN: Make a map of a country you would like to visit
### --> FILL IN THE CODE WITH YOUR SOLUTION
world %>%
  filter(region == "Kosovo") %>%
  ggplot() + 
  geom_polygon(aes(x = long, y = lat, group = group), fill = "yellow", color = "blue") +
  coord_fixed(ratio = 1.3) 

world %>%
  filter(region == "Albania") %>%
  ggplot() + 
  geom_polygon(aes(x = long, y = lat, group = group), fill = "red", color = "black") +
  coord_fixed(ratio = 1.3) 


  


