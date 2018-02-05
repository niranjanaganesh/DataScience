# Getting and Cleaning Data Final Project # 

######################################################################################

# GET LIBRARY 
library(reshape2)

# PREPARE WORKSPACE 
rm(list=ls())
setwd('/Users/niranjanaganesh/Downloads/UCI HAR Dataset')

# DOWNLOAD DATA 
filename <- "UCI HAR Dataset"

if(!file.exists(filename)){
	fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileURL, filename, method="curl")
}

if(!file.exists("UCI HAR Dataset")){
	unzip(filename)
}


# READ TABLE AND GET ONLY MEAN/STDEV
features <- read.table('./features.txt');
features[,2] <- as.character(features[,2]);
activities <- read.table('./activity_labels.txt', header=FALSE);
activities[,2] <- as.character(activities[,2]);
meanAndStdev <- grep(".*mean.*|.*std.*", features[,2]); 
meanAndStdev.names <- features[meanAndStdev, 2];
meanAndStdev.names = gsub('-mean', 'Mean', meanAndStdev.names);
meanAndStdev.names = gsub('-std', 'Stdev', meanAndStdev.names);
meanAndStdev.names <- gsub('[-()]', '', meanAndStdev.names);

# LOAD DATA 
train <- read.table("./train/X_train.txt")[meanAndStdev];
test <- read.table("./test/X_test.txt")[meanAndStdev];
yTrain <- read.table("./train/y_train.txt");
yTest <- read.table("./test/y_test.txt");
subjectTrain <- read.table("./train/subject_train.txt");
subjectTest <- read.table("./test/subject_test.txt");

# MERGE DATA & FACTORS 
train <- cbind(subjectTrain, yTrain, train); 
test <- cbind(subjectTest, yTest, test); 
fullDataset <- rbind(train, test);
colnames(fullDataset) <- c("subject", "activity", meanAndStdev.names);
fullDataset$activity <- factor(fullDataset$activity, levels = activities[,1], labels = activities[,2]); 
fullDataset$subject <- as.factor(fullDataset$subject);
melted <- melt(fullDataset, id = c("subject", "activity")); 
fullDataset.melted <- melted; 
mean <- dcast(fullDataset.melted, subject + activity ~ variable, mean);
fullDataset.mean <- mean; 

# FINAL WRITE
write.table(fullDataset.mean, "tidyDataset.txt", row.names = FALSE, quote = FALSE); 






