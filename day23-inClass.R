# DST 234: Day 23 - Functional programming

# Load up the usual packages
library(tidyverse)

##### PART 1: Functional programming

# Define a data frame: 
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10),
)

glimpse(df)


# Method 1: Compute mean individually

mean(df$a)
mean(df$b)
mean(df$c)
mean(df$d)


# Method 2: Pivot w/ data verbs
df %>% 
  pivot_longer(cols=everything(),
                    names_to="name",
                    values_to="val") %>%
  group_by(name) %>%
  summarize(mean_val=mean(val))

# Method 3: Use summarize + across
df %>% 
  summarize(across(.cols=everything(),.f=fav_stats))

# For more info on the across command, uncomment the following vignette:
# vignette("colwise")

# Method 4: Write a for loop
out <- vector("numeric", dim(df)[2])

for (i in seq_along(df)) {
  out[i] <- mean(df[[i]])
}


dim(df)[2]
summary(df)

# Method 5: Use the apply function
df %>% apply(MARGIN=2,FUN=mean)



# Method 6: Use the map function
df %>% map(mean)  # Returns a list

df %>% map(mean) %>% bind_rows()
df %>% map(mean) %>% bind_cols()

# Variant on the map function: map_df(mean)
df %>% map_df(mean)


## Lists:

n = c(2, 3, 5) 
s = c("aa", "bb", "cc", "dd", "ee") 
b = c(TRUE, FALSE, TRUE, FALSE, FALSE) 
x = list(x1=n, s, b, 3)   # x contains copies of n, s, b

# List slicing
x[2]   # Second member of the list
x[c(2,4)]  # Second and fourth members of the list

# Member reference - use double brackets
z <- x[[2]]
z2 <- x[2]
# Modification
x[[2]][1] <- "ta"

### Group_by --> nest()  --> mutate

### Method 7: Group_by --> nest()  --> mutate

df_nest <- df %>%
  pivot_longer(cols=everything(),
               names_to="name",
               values_to="val") %>%
  group_by(name) %>%
  nest()

# Use the mutate data verbs to create a new column
mean_nest <- df_nest %>%
  mutate(mean_val = purrr::map(.x = data, .f=~mean(.x$val)))


