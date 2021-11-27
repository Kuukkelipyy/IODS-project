################################################################################

# Hans Hämäläinen
# 27.11.2021

# Introduction to Open Data Science 2021:
## RStudio Exercise 6: Data wrangling

## Source of the data sets used here: https://github.com/KimmoVehkalahti/MABS  

################################################################################

library(dplyr) 
library(tidyr)

################################################################################

# BPRS DATA

# download the data sets in wide format
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE)

# let's have quick look at the data
str(bprs)
summary(bprs)

# treatment variable defines two distinct treatment groups
# subject variable identifies the participants who all belong to treatment group 1 or 2 (20 males in each group)
# the rest of the variables (starting with 'week') are measurements conducted each week during the experiment (i.e. 9 measurement over time)

# transform treatment and subject variables to factors
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)

# convert bprs data from wide to long format
bprs_long <-  bprs %>% 
  gather(key = weeks, value = bprs, -treatment, -subject)

# Transform the values of 'weeks' variable: extract the number of week
bprs_long <- mutate(bprs_long, week = as.integer(substr(weeks, 5,5)))

# let's take a look at the wide and long data sets
str(bprs)
str(bprs_long)
glimpse(bprs_long)
glimpse(bprs)
## wide: every subject in a treatment group is one observation with multiple measurements over time (i.e. variables/columns; weeks)
## long: every measurement is observation; every subject in a treatment group has total of 9 observations (one for every week/measurement)
## thus, in wide format the data consists of 40 rows/observations and 11 variables
## and in long format 360 rows/observations (40 participants * 9 measurements) of 5 observations (of which 'weeks is the old varible of measurements, and its information is now split into 'week' and 'bprs' variables)

# save the data in long format
write.table(bprs_long, "data/bprs_long.csv", sep = ";")

#-------------------------------------------------------------------------------

# RATS data

# download the data
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE)

# transform ID and Group variables to factors
rats <- rats %>%
  mutate(ID = as.factor(ID),
         Group = as.factor(Group))

# let's have a look at the rats data
str(rats) 
head(rats)
glimpse(rats)
## the data consists of 16 observations of 13 variables
## ID is the unique identifier of participants, that is rats
## Group is the treatment group; rats were divided into 3 groups with different diets
## rest of the variables are the weight measurements conducted during the experiment

# transform the data from wide to long format
rats_long <- rats %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3,4)))

# let's have a look at the rats data in long format
str(rats_long) 
head(rats_long)
glimpse(rats_long)
## when rats data is transformed to long format by the measurements
### it has 176 observations instead of 16
### in wide format each rat is one observation (16 rats)
### in long format each measurement is one observation and thus every rat has as many observations as there are measurements

# for instance the rat number 1 has a total of 11 observations in the long data
filter(rats_long, ID == 1) %>%
  glimpse()
# respective in the wide format there is only one observation conserning the rat number 1:
filter(rats, ID == 1) %>%
  glimpse()

write.table(rats_long, "data/rats_long.csv", sep = ";")

################################################################################
################################################################################
######################### THAT'S ALL DOCS! #####################################
################################################################################
################################################################################