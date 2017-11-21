#Laura Matkala 21.11.2017/IODS course
# R exercise three: data wrangling related to student alcohol consumption data
#data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#setting the working directory
setwd("C:/HY-Data/MATKALA/GitHub/IODS-project")

#reading in the csv files, which have been downloaded from the source page above, from the working directory

student_mat<-read.csv(file = "data/student-mat.csv", header = TRUE, sep=";")
student_por<-read.csv(file = "data/student-por.csv", header = TRUE, sep=";")

#checking the structures of both files
str(student_mat) # a data frame of 359 observations of 33 variables, factors with different amounts of levels and integers
str(student_por) # a data frame of 649 observations of 33 variables, factors with different amounts of levels and integers

#checking the dimensions of both files
dim(student_mat) # 395 rows and 33 columns
dim(student_por) # 649 rows and 33 columns

#Calling the package dplyr that is used for joining the two datasets
library(dplyr) 

#choosing the common columns that will be used for joining
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

#joining the two datasets 
math_por<-inner_join(student_mat, student_por, by = join_by, suffix = c(".math", ".por"))

#checking the structure and dimensions of the joined dataset
str(math_por) # 382 observations of 53 variables, factors with different amounts of levels and integers
dim(math_por) # 382 rows and 53 columns

#combine duplicated answers into one (copied from Datacamp, modified data set names)

#print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc) # 382 obs of 33 variables

#creating a column alc_use 
#first call package ggplot2. Also dplyr is needed, but it has been called already before
library(ggplot2)

#define a new column alc_use by taking the average of answers related to weekday and weekend alcohol consumption
alc<-mutate(alc, alc_use = (Dalc + Walc)/2)

#then creating a column high_use so that alc_use>2 is TRUE and alc_use<2 FALSE

alc <- mutate(alc, high_use = alc_use > 2)

# glimpse at the dataset again
glimpse(alc) #382 observations of 35 variables

# write and save the data in a csv file
write.csv(alc, file = "data/alc.csv", row.names = FALSE)

#check that everything is ok with the csv file
alc<-read.csv(file = "data/alc.csv", header = TRUE, sep=",")
glimpse(alc) # yes, still 382 obs of 35 variables

