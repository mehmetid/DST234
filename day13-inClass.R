### DST 234, Day 13
# Working with strings and dates

# Load up our usual library:
library(tidyverse)

# PART 1: Working with text data


### STRING BASICS
# Task 1: Define your first strings:
first <- 'Hello world'
second <- 'I said "hello" '  # Notice the use of quotes

# We can combine strings with c():
x <- c("Apple", "Banana", "Pear")
x <- c(first,second)

# str_c will also vectorize collections of strings
str_c("prefix-", c("a", "b", "c"), "-suffix")


# but working with entries that are NAs can be tricky:
x <- c("abc", NA)  # The second entry is not a string


# We use str_sub to get pieces of strings:
x <- c("Apple", "Banana", "Pear")
str_sub(x, start=1, end=7)

# negative numbers count backwards from end
str_sub(x, start=-3, end=-1)

# To get the length of each individual entry, we use str_length:
str_length(x)

# Compare this with length()
length(x)


### MATCHING REGULAR EXPRESSIONS (regex)

x <- c("apple", "banana", "pear")

x %>% str_view("an")   # Makes a highlighted version of matches (helpful for just viewing results)

# In practice you probably will use str_subset returns pieces that match:
x %>% str_subset("an")

# The period (.) returns pieces of strings around your match which matches any character (except a newline):

x %>% str_view(".a.")  # Find the a and match 1 character left and right
x %>% str_view("..a..")  # Two characters L and R
x %>% str_view("..a")  #  Two characters L

# The next step up in complexity is figuring out how to match special characters (in particular a period (.) and slash (\) ):

# We to define a \ in our string we need two instance (it is a special character:)
y <- c("apple.good", "ban.ana", "pe\\ar")

# Let's match the period (.):
y %>% str_view('.')  # FAIL
y %>% str_view('\.')  # FAIL
y %>% str_view('\\.')  # SUCCESS

# Matching the slash (\) needs 4 (!) slashes
y %>% str_view("\\\\")

# String functions: matching start / end
x %>% str_view("^a")   # match the start
x %>% str_view("a$")   # match the end

x <- c("apple pie", "apple", "apple cake")
x %>% str_view("apple")
x %>% str_view("^apple$")   # Exact matches


# YOUR TURN!
# Use the data frame “words”.  Develop regular expressions to find all words that:
# 1. Start with “y”.
# 2. End with “x”
# 3. Are exactly three letters long. (But don't use str_length())
# 4. Have seven letters or more.

# (we will just use str_view())

# 1. Solution:
#start
words %>%
  str_view("^y", match = TRUE) ### INSERT CODE INSIDE str_view()

# 2. Solution
words %>%
  str_view("x$", match = TRUE) ### INSERT CODE INSIDE str_view()

# 3. Solution
words %>%
  str_view("^...$", match = TRUE) ### INSERT CODE INSIDE str_view()

# 4. Solution
words %>%
  str_view("^.......", match = TRUE) ### INSERT CODE INSIDE str_view()


# YOUR TURN!
# Create regular expressions to find all words that:
# 5. Start with a vowel (a, e, i, o, u).
# 6. That only contain consonants. (Hint: thinking about matching “not”-vowels.)
# 7. End with ed, but not with eed.
# 8. End with ing or ise.

# 5. Solution
words %>%
  str_view(c("^a", "^e", "^i", "^o", "^u"), match = TRUE) ### INSERT CODE INSIDE str_view() FIX THIS!!!!!!!!

# 6. Solution - we need the plus to account for one or more.
words %>%
  str_view() ### INSERT CODE INSIDE str_view()

# 7. Solution
words %>%
  str_view() ### INSERT CODE INSIDE str_view()


# 8. Solution
words %>%
  str_view() ### INSERT CODE INSIDE str_view()




########## Let's work with sentences (so these are lists of strings)

# How many sentences have the string "the"?
sentences %>% str_detect("the")  # returns TRUE or FALSE
sentences %>% str_detect("the") %>% sum()  # Adds up how many cases

# str_count is a little different from str_detect - it will count repeats
sentences %>% str_count("the")
sentences %>% str_count("the") %>% sum()

# How would we find the sentences that have the color red?
sentences %>% str_subset(pattern='red')  # Returns some false matches


sentences %>% str_subset(pattern='\\sred\\s')  # Returns a smaller vector


sentences %>% str_extract(pattern='\\sred\\s') # Returns a vector of same length and just the first match

### PART 2: Working with dates

library(lubridate)

# Sometimes reading in data can be parsed automatically
climate_data <- read_csv('https://raw.githubusercontent.com/jmzobitz/DST234Datasets/master/MSP-snow.csv')

# First we need to fix the date - I have two columns: Date and long_date
climate_data_new <- climate_data %>%
  mutate(Date = mdy(Date),
         long_date = ymd(long_date))

# Getting date components
lubridate::year(climate_data_new$Date)  # Pulls out the year
lubridate::month(climate_data_new$Date) # Pulls out the month
lubridate::yday(climate_data_new$Date)  # Pulls out the day of the year

# Let's do some tasks:
#  (1) Compute the total annual precipitation and snow.
#  (2) Plot the interannual variation of each measurement.

# First, let's make sure the quantitative data are not strings - we will replace "T" with 0
climate_revised <- climate_data_new %>%
  mutate(across(.cols=c("Precipitation (inches)":"Snow Depth (inches)"),
                .fns=~str_replace_all(.x,pattern="T",replacement="0"))) %>%  # Replace T w/ 0
  mutate(across(.cols=c("Precipitation (inches)":"Snow Depth (inches)"),
                .fns=~as.numeric(.x)))  # Make these columns numeric

# NOTE: sometimes you may introduce NAs with as.numeric().  Not a problem necessarily, unless you are doing aggregate calculations (which we are here).  I recommend just setting NA as 0 (but be cautious that doesn't bias your analysis)

# Looks like we have some NAs - since we will be computing the annual sum, we need to remove them
climate_revised_no_na <- climate_revised %>%
  mutate(across(.cols=c("Precipitation (inches)":"Snow Depth (inches)"),
                .fns=~if_else(is.na(.x),0,.x)))

# Task (1): Compute the total annual precipitation and snow.
climate_annual_precip <- climate_revised_no_na %>%
  mutate(year = as.factor(year(Date)),  # We need to get the year - I am making it a factor variable
         jday = yday(Date)) %>%
  group_by(year) %>%
  mutate(across(.cols=c("Precipitation (inches)":"Snow (inches)"),
                .fns=~cumsum(.x))) %>%
  ungroup()

# Task (2): Plot the interannual variation of each measurement.
climate_annual_precip %>%  # We are going to pivot so we can do a facet_grid
  pivot_longer(cols=c("Maximum Temperature degrees (F)":"Snow Depth (inches)"),
               names_to = "measurement",
               values_to = "value") %>%
  ggplot(aes(x=jday,y=value,color=year)) +
  geom_line() +
  facet_grid(measurement~.,scales="free_y")



