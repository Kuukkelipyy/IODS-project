################################################################################

# Hans Hämäläinen
# 4.11.2021

# Introduction to Open Data Science 2021:
## RStudio Exercise 2: Data wrangling

################################################################################

library(dplyr) #access the dplyr -package

################################################################################

# read data from URL
lrn14 <- read.table("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt",
                    sep = "\t", header = TRUE)

# examine the structure and dimensions of the dataset
str(lrn14)  # data frame consists of 183 observations of 60 variables;
dim(lrn14)  # i.e. 183 rows and 60 columns

# Create combination variables: deep, stra and surf
## 1. define the names of the variables needed
deep_vars <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
stra_vars <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
surf_vars <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

## 2. select only the named variables/columns from the data
deep_cols <- select(lrn14, one_of(deep_vars)) 
stra_cols <- select(lrn14, one_of(stra_vars))
surf_cols <- select(lrn14, one_of(surf_vars))

## 3. calculate the row means of the selected variables and add it into the data frame as a new variable
lrn14$deep <- rowMeans(deep_cols) 
lrn14$stra <- rowMeans(stra_cols)
lrn14$surf <- rowMeans(surf_cols)

# create a new data set 'learning2014' by using dplyr-package
learning2014 <- lrn14 %>% 
  select(gender, Age, Attitude, deep, stra, surf, Points) %>%   #select the variables
  filter(Points > 0) %>%  #exclude observations with zero exam points
  rename(age = Age, attitude = Attitude, points = Points) #rename variables (uppercase -> lowercase letters)

# check that the working directory is correct (if not use setwd() to define it):
getwd()

# save the new data frame to folder 'data' in the working directory:
write.table(learning2014, file = "data/learning2014.csv")

# test that you are able to read the data from the file and it is as it should be
saved_data <- read.table("data/learning2014.csv")
str(saved_data)
head(saved_data)
summary(saved_data)

################################################################################