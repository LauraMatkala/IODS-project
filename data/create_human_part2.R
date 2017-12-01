#Laura Matkala/IODS course
#30.11.2017
#Data wrangling for R exercise 5, human development index of different countries, part 2.

#link to the original data wrangling file in Gihub: https://github.com/LauraMatkala/IODS-project/blob/master/data/create_human.R

#setting the working directory and reading in the data that I already have on my computer
setwd("C:/HY-Data/MATKALA/GitHub/IODS-project")
human <- read.csv(file = "data/human.csv", header = TRUE, sep = ",")

#Transforming GNI to a numeric variable (string manipulation)
library(stringr)
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
str(human$GNI) #checking the structure, and indeed the variable GNI is now numeric 

#choosing which columns to keep for analysis 

library(dplyr)
keep_columns <- c("Country", "SecoEd_FM", "LaboFor_FM", "ExpEdu", "LifeEx", "GNI", "MatMort", "AdoBirth", "ParlRep")
human <- select(human, one_of(keep_columns))

#removing rows with missing values
complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human <- filter(human, complete.cases(human)==TRUE)

#removing observations related to regions instead of countries
human <- human [1:155,]

#Define the row names of the data by the country names and remove the country name column from the data
rownames(human) <- human$Country
human <- select(human, -Country)

#saving the data as csv, this time with rownames
write.csv(human, file = "data/human.csv", row.names = TRUE)