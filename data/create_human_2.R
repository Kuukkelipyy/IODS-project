################################################################################

# Hans Hämäläinen
# 16.11.2021

# Introduction to Open Data Science 2021:
## RStudio Exercise 5: Data wrangling
## week 4 data wrangling exercise: rows 22-61

## Data sets used here:
### 1) Human development index (HDI) data
### 2) Gender inequality index (GII) data
## Data source:  source: http://hdr.undp.org/en/content/human-development-index-hdi

################################################################################

library(dplyr) 

################################################################################

# read HDI data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
# read GII data
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# explore the data sets
## HDI
dim(hd)
str(hd)
summary(hd)
## GII
dim(gii)
str(gii)
summary(gii)

# rename variables with shorter and descriptive names
hd <- hd %>%
  rename(HDI = Human.Development.Index..HDI.,
         LifeExp = Life.Expectancy.at.Birth,
         ExpEdu = Expected.Years.of.Education,
         MeanEdu = Mean.Years.of.Education,
         GNIperCap = Gross.National.Income..GNI..per.Capita,
         GNIminusHDI = GNI.per.Capita.Rank.Minus.HDI.Rank)

gii <- gii %>%
  rename(GII = Gender.Inequality.Index..GII.,
         MatMortalityRate = Maternal.Mortality.Ratio,
         AdoBirthRate = Adolescent.Birth.Rate,
         FemalesParliament = Percent.Representation.in.Parliament,
         FemaleSecondEdu = Population.with.Secondary.Education..Female.,
         MaleSecondEdu = Population.with.Secondary.Education..Male.,
         FemaleLabourPart = Labour.Force.Participation.Rate..Female.,
         MaleLabourPart = Labour.Force.Participation.Rate..Male.) %>%
  mutate(SecondEduRatio = FemaleSecondEdu / MaleSecondEdu,
         LabourRatio = FemaleLabourPart / MaleLabourPart)

# join the GII and HDI data sets
human <- inner_join(hd, gii, by = "Country")

# save the combined data:
write.table(human, file = "data/human.csv", sep = ";")

################################################################################
################### BELOW WEEK 5 DATA WRANGLING ################################
################################################################################

#load the human data
human <- read.table("data/human.csv", sep = ";")
#examine the structure and dimensions of the data
## 195 observations of 19 variables
str(human)
dim(human)

# transform the Gross National Income (GNI) variable to numeric
library(stringr) # access to needed package
human$GNIperCap <- str_replace(human$GNIperCap, pattern = ",", replace = "") %>%
  as.numeric()

# Select the variables instructed
## it is really stupid that in the last wrangling exercise it was instructed to rename the variables as wished!
human <- human %>%
  select(Country, GNIperCap, LifeExp, ExpEdu, MatMortalityRate, AdoBirthRate,
         FemalesParliament, LabourRatio, SecondEduRatio)

# Remove all rows with missing values; i.e. keep only complete cases
human <- human %>%
  filter(complete.cases(human) == TRUE)

# remove the last 7 observations, which are other regions than single countries
last_obs = nrow(human) - 7
human <- human[1:last_obs,]

# Define the row names of the data by the country names 
rownames(human) <- human$Country
# remove the country variable from the data
human <- select(human, -Country)

# save the data to file
write.table(human, "data/human.csv", sep = ";")

# Shorth description of variables in the prepared data set:
'
# Varibbles
"Country" = Country name
"GNIperCap" = Gross National Income per capita
"LifeExp" = Life expectancy at birth
"ExpEdu" = Expected years of schooling 
"MatMortalityRate" = Maternal mortality ratio
"AdoBirthRate" = Adolescent birth rate
"FemalesParliament" = Percetange of female representatives in parliament
"SecondEduRatio" = Edu2.F / Edu2.M
"LabourRatio" = Labo2.F / Labo2.M

'

