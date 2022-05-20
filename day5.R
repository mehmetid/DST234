### DST 234, Day 5

## load up the associated libraries
library(mdsr)
library(tidyverse)

### Part 1: Facetting plots
## Facetting plots
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

# Compare to:
ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(cyl ~ drv)

### Part 2: Data Intake
memorization_data_csv <- read_csv('C:/Users/dijon/Desktop/DST234')

# read_csv()  --> tidyverse function to import files  PREFERRED
# read.csv()  --> baseR function
# read.csv2()

# For Excel data, need to have the readxl library installed
memorization_data_excel <- readxl::read_xlsx('memorizaton_data.csv')

### Creating ggplot "sentences"
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(cyl~drv)

p1 <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

p1 + facet_grid(cyl ~ drv)




### Part 3: Canonical ggplots
glimpse(diamonds)
g<-ggplot(head(diamonds, n=100), aes(y=price, x=carat)) + 
  geom_point(color = "red") + ggtitle("Prive vs Carat") +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3), se = TRUE, color = "green") + 
  facet_wrap(price ~ carat)

g


