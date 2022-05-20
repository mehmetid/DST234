### DST 234, Day 10: Introduction to joins
### (Chapter 5: Data Wrangling on multiple tables from MDSR)

library(tidyverse)
library(nycflights13)


### PART 1: JOINING
# Here is some sample code that define some small vectors for joins
x<-tribble(
  ~key, ~val_x,
  1,"x1",
  2,"x2",
  3,"x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)


inner_join(x,y,by="key")  # by = the name of the column you are joining OR

x %>% inner_join(y, by="key")

#########

# YOUR TURN!  In the nycflights13 dataset, do an inner_join of the flights and planes data table, specified by the tailnum variable.  What is the oldest plane that flew out of the airport in 2013?

yt_1 <- flights %>%  ### FILL IN CODE HERE
  inner_join(planes, by = "tailnum") %>%
  arrange(year.y) %>%
  slice(1) # or top_n(1)
  
  



# YOUR TURN: Do an inner_join of the airports and flights data table, specified by the dest variable.  What is the usual name for the top destination airport for flights from New York City?
# First determine out the top destinations first, and then join on the name of the airport.

yt_2 <- flights %>% ### FILL IN CODE HERE
  inner_join(airports, by = c("dest" = "faa")) %>%
  filter(!is.na(dest)) %>%
  group_by(dest) %>%
  summarize(tot = n())%>%
  arrange(desc(tot))%>%
  top_n(5) %>%
  inner_join()
  

# Lesson learned - you can use "col.x" = "col.y" to link differently named columns.

# Also note you can join on more than one variable, in the join command:
# by = c("col1.x" = "col1.y", "col2.x" = "col2.y")


#### You do a left join
left_join(x,y,by="key")

### Duplicate keys example - repeated in one table
x1 <- tribble( ~key, ~val_x, 1, "x1", 2, "x2", 2, "x3", 1, "x4" )
y1 <- tribble( ~key, ~val_y, 1, "y1", 2, "y2" )

left_join(x1, y1, by = "key")


### Duplicate keys example - repeated in both tables
x2 <- tribble( ~key, ~val_x, 1, "x1", 2, "x2", 2, "x3", 1, "x4" )
y2 <- tribble( ~key, ~val_y, 1, "y1", 2, "y2", 2, "y3", 3, "y4" )

inner_join(x2, y2, by = "key")

