#Laura Matkala/IODS course
#28.11.2017
#Data wrangling for R exercise 5, human development index of different countries

#setting the working directory
setwd("C:/HY-Data/MATKALA/GitHub/IODS-project")

#reading in data from online sources
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd) #hd is a dataframe with 2 integer, 4 numeric and 2 character variables
str(gii) # gii is a dataframe with 2 integer, 7 numeric and 1 character variable 

dim(hd) # 195 rows, 8 columns
dim(gii) # 195 rows, 10 columns

summary(hd)
summary(gii)

#changing the variable names of datasets into something shorter
names(hd) <- c("HDI_rank","Country","HDI", "LifeEx", "ExpEdu", "MeanEdu", "GNI", "GNI_HDI_rank")
names(gii) <- c("GII_rank", "Country","GII", "MatMort", "AdoBirth", "ParlRep", "SecoEd_F", "SecoEd_M", "LaboFor_F", "LaboFor_M")

#creating two new variables to dataset gii, "SecoEd_F/SecoEd_M" and "LaboFor_F/LaboFor_M"
library(dplyr)
gii <- mutate(gii, SecoEd_FM = (SecoEd_F / SecoEd_M))
gii <- mutate(gii, LaboFor_FM = (LaboFor_F / LaboFor_M))

#joining the two datasets together by variable "Country"

hd_gii<-inner_join(hd, gii, by = "Country", suffix = c(".hd", ".gii"))
human <- hd_gii
glimpse(human) #195 observations, 19 variables

write.csv(human, file = "data/human.csv", row.names = FALSE)