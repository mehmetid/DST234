### DST 234, Day 15
# Working with linear regression

# install.packages("broom")  # <-- If you don't have this package installed already

# Load up our usual libraries + broom
library(tidyverse)
library(broom)


# Construct a scatterplot of wt and mpg from the dataset
mtcars %>%
  ggplot(aes(x = wt, y = mpg)) +
  geom_point()

# Add in the smoothing equation:
mtcars %>%
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm")

# Do do linear regression we use the function lm:
lmfit <- lm(mpg ~ wt, data = mtcars)

lmfit

summary(lmfit)



# To get some the results easier, we can use the broom package! (make sure it is loaded)
# tidy, augment, and glance are all part of broom

# tidy gives you the coefficients
tidy(lmfit)


# augment gives you the fitted values and residuals
augment(lmfit)


# glance gives you the summary statistics
glance(lmfit)


# YOUR TURN: For the mpg data frame, create a plot with the variable wt on the x axis, mpg on the y axis, with the variable cyl distinguishing the different colors.

#Hint: to make a quantitative variable categorical, use as.factor(VARIABLE)
# mpg## ENTER IN CODE HERE:
mtcars %>%
  ggplot(aes(x = wt, y= mpg, color = as.factor(cyl))) +
  geom_point() + geom_smooth(method = "lm")


# When you are done, then add a geom smooth


# Next task: how do we obtain the linear regression stats for each group? We do this by creating a nested data frame:

# STEP 1: Group the data together and nest
df1 <- mtcars %>%
  group_by(cyl) %>%
  nest()  # puts each of the groups in a bucket


# Explore:
df1$cyl

df1$data

df1$data[[1]]


# STEP 2: Compute a linear regression for each of the different groups:
df2 <- df1 %>%
  mutate(lmfit = map(.x=data,
                     .f=~lm(mpg~wt, data = .x)
                     )
         )

# STEP 3: Apply another map function this again to tidy up the coefficients:
df3 <- df2 %>%
  mutate(tidy_vals = map(.x=lmfit,.f=tidy)
         )

# STEP 4: Unpack the list column
fitted_coefficients <- df3 %>%
  select(tidy_vals) %>%  # Select the columns we want
  unnest(cols = c(tidy_vals))  # Unnest as a tidy data frame

