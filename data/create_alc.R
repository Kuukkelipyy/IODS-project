################################################################################

# Hans Hämäläinen
# 10.11.2021

# Introduction to Open Data Science 2021:
## RStudio Exercise 3: Data wrangling

## Data: Student Performance Data
## Data source: UCI Machine Learning Repository (https://archive.ics.uci.edu/ml/datasets/Student+Performance)

################################################################################

library(dplyr) #access the dplyr -package

################################################################################

# read data sets por' and 'math' from local .csv-files 
por_data <- read.table("data/student-por.csv", sep = ";", header = TRUE)
math_data <- read.table("data/student-mat.csv", sep = ";", header = TRUE)

# por data frame consists of 649 observations (respondents) of  33 variables
# i.e. 649 rows and 33 columns
str(por_data) 
dim(por_data)
#math data frames consist of 395 observations (respondents) of  33 variables'
# i.e. 395 rows and 33 columns
str(math_data)
dim(math_data)

# both data set have the same variables/columns
identical(colnames(por_data), colnames(math_data))

#-------------------

# Join the data sets

# First: define columns that vary in data sets
vary_cols <- c("failures","paid","absences","G1","G2","G3")

# Second: pick the columns which are used as identifiers of respondents
join_cols <- setdiff(colnames(math_data), vary_cols)

# Third: merge the two data sets with inner_join verb
math_por <- inner_join(math_data, por_data, by = join_cols, suffix = c(".math", ".por"))

# the joined data 'math_por' has:
## 370 rows and 39 columns; i.e. 370 observations (students) of 39 variables
## the varying 6 variables have suffixes .por and .math identifying from which data set their are
dim(math_por)
str(math_por)
colnames(math_por)

# structure of the variables that WERE NOT joined
select(math_por, !one_of(join_cols)) %%
  str(not_joined)

#-----------------

# create a new data frame with only the joined variables
alc <- select(math_por, one_of(join_cols))

# combine the duplicate/varying variables and add them to the alc-data.frame

for(var_name in vary_cols) {
  both_columns <- select(math_por, starts_with(var_name)) #select vars which have the same name without the suffix
  first_column <- select(both_columns, 1)[[1]] # [[1]] -> forms vector instead of data.frame
  
  if(is.numeric(first_column)) {
    alc[var_name] <- round(rowMeans(both_columns))
    } else {
      alc[var_name] <- both_columns[1]
    }
  }

## NOTE: regarding characters it does not make sense here to take the value of the first one
### e.g. math.paid = NO, por.paid = YES
### however probably the var is not used, and would be better to just drop out from the data
### anycase, it will be included here because it was kind of instructed

# create the variable combining weekday and weekend alcohol consumption
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
# create a dummy/logical variable whether the respondent is high user
alc <- mutate(alc, high_use = alc_use > 2)

# examine the new data set (seems OK)
summary(alc)
str(alc)
glimpse(alc)

#-----------------------

# save the data to 'data' folder in the working directory
write.table(alc, file = "data/alc.csv", sep = ";")

################################################################################

# NOTE!:
## The constructed data is a bit different compared to the data provided in GitHub (https://github.com/rsund/IODS-project/raw/master/data/alc.csv)
### GitHub data have the same number of observations but more variables ('dublicates' and constructed id-variables), which are probably useless in the exercise!
### Those variables are not in the DataCamp data either. Instead DataCamp-file have more observations, but that is said to be an error

### in short: I think the data constructed here is correctly constructed ;)

################################################################################

