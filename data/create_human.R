################################################################################

# Hans Hämäläinen
# 16.11.2021

# Introduction to Open Data Science 2021:
## RStudio Exercise 4: Data wrangling

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
################################################################################
######################## THAT'S ALL FOLKS! #####################################
################################################################################
################################################################################