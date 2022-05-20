# Day 8, DST 234: Pipe operator + data wrangling verbs

# We will just be using the tidyverse library today
library(tidyverse)

### PART 1: Algorithmic thinking and the pipe operator
# Task: Write code that produces a plot of the function y = sin (√x) from 0 ≤ x ≤ 10

# First storyboard
# x=2 --> sqrt(2) --> sin (sqrt(2) ) --> 0.9878
# Then write the code  (we will do this 3 times! )

# a. Step-by-step
x <- seq(0,10,length.out=100)  # Write a sequence starting at 0, ending at 10, 100 points.

z <- sqrt(x)

y <- sin(z)

my_data <- tibble(x,y)

ggplot(data=my_data, aes(x=x,y=y)) + geom_line()

# b. writing a function

# Notation for writing a function:
# NAME  <-  function(INPUT_VAR1,INPUT_VAR2) {}

sinSqrt <- function(x) {

  z <- sqrt(x)
  y <- sin(z)

  return(y)

}


x <- seq(0,10,length.out=100)  # Write a sequence starting at 0, ending at 10, 100 points.

y <- sinSqrt(x)  # Collapsed the intermediate step into one line

my_data <- tibble(x,y)

ggplot(data=my_data, aes(x=x,y=y)) + geom_line()

# Differences between { } or [ ] or ( ):
# {}  --> Use these for loops or building functions
# []  --> Use these to refer to indices of a vector or data frame x[1] - the first element of x
# ()  --> Mathematical operations (order of operations), defining input variables to a function f(x)
# f(x)  - the function f evaluated at x.  y*(x) -- denotes y times x


# c. Pipe operator  (%>%)

y <- x %>% sqrt() %>% sin()

# OR #

y <- x %>%
  sqrt() %>%
  sin()

# Make data frame
my_data <- tibble(x,y)

# Make the ggplot
ggplot(data=my_data, aes(x=x,y=y)) + geom_line()


# Alternatively: Piping into ggplot

my_data %>%
  ggplot(aes(x=x,y=y)) +
  geom_line()


### PART 2: Data wrangling verbs


# I am going to link you to a data file on my github page.
# First we are going to define the link:
github_url <- "https://github.com/jmzobitz/DST234Datasets/raw/master/KidsFeet.Rda"

# Then we are going to load the data frame kids feet:
load(url(github_url))

# Information about the dataset can be found here:
# https://rdrr.io/cran/mosaicData/man/KidsFeet.html

# See what we have here:
glimpse(KidsFeet)

# TASK 1: (I have starter code that you need to fill in)

# Create a new data frame (df1) that selects the columns “Name”, “birthmonth” and “birthyear”  (FILL IN BELOW)
df1 <- KidsFeet %>%
  select(name, birthmonth, birthyear)


# Create a second data frame (df2) that filters on girls born in July (FILL IN BELOW)
df2 <- KidsFeet %>%
  filter(sex == "G", birthmonth == 7)



# Create a third data frame that filters on boys born Jan-March (FILL IN BELOW)
df3 <- KidsFeet %>%
  filter(sex == "B", birthmonth < 4 & birthmonth >= 1 )
  ## different way ---> filter(birthmonth %in% c(1,2,3) & sex == "B")


# TASK 2
# Create a new data frame (df4) that adds a column for the average of length and width columns, sorted in descending order.  Call this new column “my_average”.  Try to pipe this code.

df4 <- KidsFeet %>%
  mutate(my_average = (length + width) / 2)
KidsFeet %>%arrange(desc(my_average))
  


# Then create a new data frame (df5) that renames the column “my_average” from df4 to “foot_average”
df5 <- df4 %>%
  rename(foot_average = my_average)


# TASK 3: Let's do together
# Create a new data frame (df6) that determines the average width and average length of the data set. Try to pipe this code.

df6 <- KidsFeet %>%
  summarize(ml = mean(length),
            mw = mean(width))



# Create a new data frame (df7) that determines the average width and average length, separated by sex. Try to pipe this code.
df7 <- KidsFeet %>%
  summarize(mean(length),mean(width),group_by(sex))  # FAIL

df7 <- KidsFeet %>%
  summarize(mean(length),mean(width)) %>%
  group_by(sex)  # FAIL

df7 <- KidsFeet %>%
  group_by(sex) %>%
  summarize(N=n(),
            width=mean(width),
            length=mean(length)
            )  # Success ---> tidyverse approach

# Here is code that would accomplish the same thing, using the non-tidyverse way
# Pull out the entries of the data frame that are B
b_df <-KidsFeet[which(KidsFeet$sex=="B"),]

# Build a data frame that summarizes the data
b_summary <- data.frame(sex="B",
                        N=dim(b_df)[1],
                        width=mean(b_df$width),
                        length=mean(b_df$length))

# Pull out the entries of the data frame that are G
g_df <-KidsFeet[which(KidsFeet$sex=="G"),]

# Build a data frame that summarizes the data
g_summary <- data.frame(sex="G",
                        N=dim(g_df)[1],
                        width=mean(g_df$width),
                        length=mean(g_df$length))

# Bind the two data frames together
df_long <- rbind(b_summary,g_summary)

