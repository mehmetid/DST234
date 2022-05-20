### DST 234, Day 12: Pivoting wider and longer
### (Chapter 6: Tidy data from MDSR)


library(tidyverse)

# PIVOTING
BP_narrow <- tribble(~subject, ~when, ~sbp,
                     "BHO","before",160,
                     "GWB","before",120,
                     "WJC","before",105,
                     "BHO","after",115,
                     "GWB","after",135,
                     "WJC","after",145)


BP_wide <- tribble(~subject, ~before, ~after,
                   "BHO", 160, 115,
                   "GWB", 120, 135,
                   "WJC", 105, 145)

# These two tables represent the same thing, so lets use the commands pivot_longer and pivot_wider to convert one from another

BP_wide %>%
  pivot_longer(cols=c("before","after"),
               names_to="when",
               values_to = "sbp"
               )


BP_narrow %>%
  pivot_wider(names_from = "when",
              values_from="sbp"
              )


# YOUR TURN!
# 1. Type table2
# 2. What data verb would you do to transform table2 into the result?
# 3. Apply that command in R transform table2

table2%>%
  pivot_wider(names_from = "type",
              values_from = "year")
  ### <--- Now try coding ## DOUBLE CHECK THE POWERPOINT FOR THE CORRECT ANSWER


# YOUR TURN! - PART 2
# 1. Type table4a
# 2. What data verb would you do to transform table4a into the result?
# 3. Apply that command in R transform table4a

table4a %>%
  pivot_longer(cols=c("1999","2000"),
               names_to="year",
               values_to = "cases")### <--- Now try coding


# Case Study Cleaning and Pivoting Data

 



