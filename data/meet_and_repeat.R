################################################################################

# Hans Hämäläinen
# 25.11.2021

# Introduction to Open Data Science 2021:
## RStudio Exercise 6: Data wrangling

## Data sets used here:
### 1) 
### 2) 
## Source: https://github.com/KimmoVehkalahti/MABS  

################################################################################

library(dplyr) 
library(tidyr)

################################################################################

# download the data sets in wide format
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE)

# BPRS DATA
# Let's first work with the BPRS data
str(bprs)
summary(bprs)

# treatment variable define two distinct treatment groups
# subject variable identifies the participants who all belong to treatment group 1 or 2
# the rest of the variables (starting with 'week') are measurements conducted each week during the experiment (i.e. 9 measurement over time)

# transform treatment and subject variables to factors
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)

# convert bprs data from wide to long format
## wide:
## long: 
bprs_long <-  bprs %>% 
  gather(key = weeks, value = bprs, -treatment, -subject)

# Transform the values of 'weeks' variable: extract the number of week
bprs_long <- mutate(bprs_long, weeks = as.integer(substr(weeks, 5,5)))



################################################################################
################################################################################
######################### THAT'S ALL DOCS! #####################################
################################################################################
################################################################################