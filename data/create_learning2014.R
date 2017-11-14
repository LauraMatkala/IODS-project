#Laura Matkala, November 14th, IODS course, R exercise number two

#reading the data into "learning2014"
learning2014<-read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header = TRUE) 

#the structure of learning2014
str(learning2014) # there are 183 observations of 60 different variables. 59 variables are integers, one is a factor with 2 levels

#dimension of learning2014
dim(learning2014) # learning2014 has 183 columns and 60 rows

#Create an analysis dataset 

library(dplyr) #accessing library dplyr

#extracting different types of qustions from learning2014
deep_q<-c("D03", "D06", "D07","D11","D14", "D15", "D19", "D22", "D23", "D27", "D30", "D31")
stra_q<-c("ST01", "ST04", "ST09", "ST12", "ST17", "ST20", "ST25", "ST28")
surf_q<-c("SU02", "SU05", "SU08", "SU10", "SU13", "SU16", "SU18", "SU21", "SU24", "SU26", "SU29", "SU32")

#selecting the columns related to differenct question types, 
#taking the means of the question columns and creating one column per question type to learning2014
deep_columns <- select(learning2014, one_of(deep_q))
learning2014$deep <- rowMeans(deep_columns)

stra_columns <- select(learning2014, one_of(stra_q))
learning2014$stra <- rowMeans(stra_columns)

surf_columns <- select(learning2014, one_of(surf_q))
learning2014$surf <- rowMeans(surf_columns)

#choose only the needed columns
keep_columns <- c("Age","Attitude", "Points", "gender", "deep", "stra", "surf")

# select those columns
learning2014 <- select(learning2014, one_of(keep_columns))

# scale column "Attitude" and replace it with the original values
learning2014$Attitude <- learning2014$Attitude / 10
learning2014$Attitude

#filtering out those values when exam points are zero
learning2014 <- filter(learning2014, Points >0)
str(learning2014)

#set working directory to IODS project folder
setwd("C:/HY-Data/MATKALA/GitHub/IODS-project")

#save the data set as csv file to folder "data"
write.csv(learning2014, file = "data/learning2014.csv", row.names = FALSE)

#reading the file and testing that the structure is the same
learning2014<-read.csv(file = "data/learning2014.csv", header = TRUE, sep=",")
str(learning2014)
head(learning2014)
