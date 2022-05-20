
# Day 7: Introduction to Annotations

library(tidyverse)
library(ggthemes)  # You may need to install this package first


# PART 1: THEMES & ANNOTATIONS


# Task 1: Use the data frame mpg (which represents the data from fuel efficiency of different cars) to generate a scatterplot with the following aesthetics:
# - x axis: engine size (displacement)
# - y axis: highway miles per gallon
# - Color: class (or type) of car.

# For your plot also do a smoothed fit, w/o showing the error

### --> FILL IN THE CODE WITH YOUR SOLUTION
p1 <- ggplot(data = mpg, aes(x=displ, y=hwy)) +
  geom_point( aes( color = class)) +
  geom_smooth(se = FALSE)+
  theme(legend.position = "bottom")

#Other solution
p1 <- ggplot(data = mpg) +
  geom_point( aes(x=displ, y=hwy, color = class)) +
  geom_smooth(aes(x=displ, y=hwy), se = FALSE)
  # Show the plot
  p1

# Task 2: Modify the plot theme (try out a few different themes, also try some from ggthemes)
p1 + theme_excel()
p1 +theme_classic()
p1 + theme_base()
p1 + theme_economist()

# Task 3: Adding Labels
# Title, subtitle, and caption add additional information:
p1 +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

# You can use labs() to add a label to any defined aesthetic:
p1 +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov",
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )

# NOTE: if you want to NOT label something, use NULL:
p1 +
  labs(
    x = NULL,
    y = "Highway fuel economy (mpg)",
    colour = NULL
  )


# Task 4: Changing the scales (breaks and axis labels)

# Tick marks:
p1 + scale_y_continuous(breaks=seq(15,40,by=5))

# Label notations:
p1 + scale_y_continuous(labels=NULL)  # Remove the numbers
p1 + scale_y_continuous(breaks=seq(15,40,by=5),
                        labels=NULL)  # Change the spacing, remove the numbers
p1 + scale_y_continuous(breaks=seq(15,40,by=5),
                        labels=c("a","b","c","d","e","f"))  # Change the spacing, customize the labels

# Task 4b: Transforming the scales
# Compare the following:
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()

# This option is the same as the second option, but retains the same label names:
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_log10()

# Task 4c: changing the color scales
p1 + scale_color_brewer(palette = "Set1")

# YOUR TURN: go to http://r4ds.had.co.nz/graphics-for-communication.html#fig:brewer and change the color scale to something different

### --> FILL IN THE CODE WITH YOUR SOLUTION
p1 + scale_color_brewer(palette = "RdPu")
p1 + scale_color_brewer(palette = "YlOrRd")

# Task 5: Changing the placement of legends:
p1 + theme(legend.position = "bottom")


# Your turn: change the placement of the legend to the top, right, and left
### --> FILL IN THE CODE WITH YOUR SOLUTION
p1 + theme(legend.position = "bottom")
p1 + theme(legend.position = "top")
p1 + theme(legend.position = "left")
p1 + theme(legend.position = "right")

# To remove the legend, it depends on if you want to remove:
# (1) Legend with an aesthetic
p1 + scale_color_discrete(guide=FALSE)

# (2) All legends
p1 + theme(legend.position = "none")


# Task 6: Adding additional notations

# Define a notation first
notation <- tibble(
  cutoff = c(10,20,30),
  x_axis = c(2,4,6),
  type = c("Gas Guzzler", "Average", "Eco-friendly"))

# Add horizontal lines
p1 + geom_hline(data = notation, aes(yintercept = cutoff),color = "Black")

# For vertical lines: use geom_vline
# Add text:
p1 + geom_text(data = notation, aes(x=x_axis,y=cutoff,label = type, vjust = "top"),nudge_y = 2)

# Now combine the two
p2 <- p1 +
  geom_hline(data = notation, aes(yintercept = cutoff),color = "darkgray") +
  geom_text(data = notation, aes(x=x_axis,y=1.01*cutoff,label = type, vjust = "left"))

p2

