#Create a directory for the project files
if (!dir.exists("./GettingAndCleaningDataProject")) {
    dir.create("./GettingAndCleaningDataProject")
}
setwd("./GettingAndCleaningDataProject")

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_url, "data_file.zip")
unzip("data_file.zip")

#Create dataframes for features & activity labels
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

#Consolidate Test data
dataTestX <- read.table("UCI HAR Dataset/test/X_test.txt")
names(dataTestX) <- features[,2]
dataTestY <- read.table("UCI HAR Dataset/test/y_test.txt")
names(dataTestY) <- "activity"
dataTestSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(dataTestSubject) <- "subject"
dataTest <- cbind(dataTestSubject, dataTestY, dataTestX)
dataTest$subjectType <- "Test"

#Consolidate Train data
dataTrainX <- read.table("UCI HAR Dataset/train/X_train.txt")
names(dataTrainX) <- features[,2]
dataTrainY <- read.table("UCI HAR Dataset/train/y_train.txt")
names(dataTrainY) <- "activity"
dataTrainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(dataTrainSubject) <- "subject"
dataTrain <- cbind(dataTrainSubject, dataTrainY, dataTrainX)
dataTrain$subjectType <- "Train"

#Merge Test and Training data sets
fullData <- rbind(dataTest, dataTrain)

#Extract only mean & sd for each measurement
meanStdColN <- grep("mean\\()|std\\()", names(fullData))
extractedData <- fullData[,c(1:2, meanStdColN)]

#Rename activity with descrptive name instead of code
extractedData$activity <- activity_labels[,2][extractedData$activity]

#Descriptive variable names
names(extractedData) <- gsub("^t", "time", names(extractedData))
names(extractedData) <- gsub("^f", "frequency", names(extractedData))
names(extractedData) <- gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData) <- gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData) <- gsub("Mag", "Magnitude", names(extractedData))
names(extractedData) <- gsub("BodyBody", "Body", names(extractedData))

#Create a summary dataset with average of each variable
library(dplyr)
summaryData <- group_by(extractedData, subject, activity)
summaryData <- summarise_at(summaryData, 1:66, mean)

setwd("./..")