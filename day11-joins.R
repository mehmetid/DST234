### Exercises for practice on joining tables
### Adapted from Wickham's R for Data Science, http://r4ds.had.co.nz/relational-data.html#mutating-joins

library(mdsr)
library(nycflights13)
library(maps) 
library(tidyverse)
# You might need to install.packages("maps")

### Instructions: the following exercises have you work with joining data tables using the nycflights13 dataset.

### TASK 0: Define a base plot map of the United States. You will add onto this plot for the different tasks
airport_plot <- ggplot() +
  borders("state") + 
  coord_quickmap() +
  geom_point() 
  

### TASK 1: Make a map for the destinations for each flight in the dataset
### Step 1: glimpse the flights data frame:
glimpse(flights)
glimpse(airports)

### Step 2: So we will need to join up flights and airport - which will be the key that we join them on?  Once you've identified them, use a semi_join.
destinations <- semi_join(airports, flights, by = c("faa" = "dest")) ### ADD CODE HERE

### Step 3: Add this information to airport_plot
airport_plot +
  geom_point(data = destinations,
             aes(x = lon, y= lat))

### TASK 2: Determine the average delay by destination in this dataset.

### Step 1: First determine the average flight delay by destination (call this average_delay) - use the data verbs from Chapter 4
average_delay <- flights %>%
  group_by(arr_delay, dest)%>%
  summarize(N = n(), mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(N))
  ### ADD CODE HERE

### Step 2: Join the information to the airport information
airport_delays <- average_delay  ### Pipe the remaining code

### Step 3: Add this information to airport_plot - use your variable for the average delay time as the color aesthetic
airport_plot +
  geom_point(data = airport_delays,
             aes(x = lon, y= lat,color=delayTime))

### TASK 3: An event happened on June 13, 2013. Make a plot of the average delay and destinations of the flights (what you will have is two separate plots).

