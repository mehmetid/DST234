

library(tidyverse)
library(lubridate)
install.packages("devtools")
library(devtools)
library(shiny)
library(neonUtilities)

acquire_neon_data(site_name ="SJER", start_date = "2020-06", end_date = "2020-06", file_name = "my-file-2020-06.Rda")
devtools::install_github("jmzobitz/NEONSoils", build = TRUE, build_opts = c("--no-resave-data", "--no-manual"),force=TRUE)

