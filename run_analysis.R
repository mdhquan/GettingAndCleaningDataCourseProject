## 
##You should create one R script called run_analysis.R that does the following. 
##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement. 
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##Good luck!
##

## Set wd
getwd()
setwd("C:\\Users\\Quan\\Desktop\\Getting Cleaning Data\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\")

## 1. Read in the data
test.label <- read.table("test\\y_test.txt", col.names="label")
test.subject <- read.table("test\\subject_test.txt", col.names="subject")
test.data <- read.table("test\\X_test.txt")
train.label <- read.table("train\\y_train.txt", col.names="label")
train.subject<- read.table("train\\subject_train.txt", col.names="subject")
train.data <- read.table("train\\X_train.txt")

	# binding the pieces together to create a large dataset
dataset <- rbind(cbind(test.subject, test.label, test.data),cbind(train.subject, train.label, train.data))

## 2. 
	# read in the features
features <- read.table("features.txt", stringsAsFactors=FALSE)
	# only keep mean and standard deviation
features.mean.sd <- features[grep("mean\\(\\)|sd\\(\\)", features$V2), ]

# only keeping dataset's mean and standard deviation
data.mean.sd <- dataset[, c(1, 2, features.mean.sd$V1+2)]

## 3.
	# read the activities' labels
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
	# replace labels in dataset with label names
data.mean.sd$label <- labels[data.mean.sd$label, 2]

## 4.
	# make a list of the column names and feature names
g.colnames <- c("subject", "labels", features.mean.sd$V2)
	# tidy-fy that list
g.colnames <- tolower(gsub("[^[:alpha:]]", "", g.colnames))
	# update column names for data by using the names gotten from the previous step
colnames(data.mean.sd) <- g.colnames

## 5.
	# find the mean for combinations of label and subjects
aggr.data <- aggregate(data.mean.sd[, 3:ncol(data.mean.sd)],
                       by=list(subject = data.mean.sd$subject, 
                               label = data.mean.sd$label),
                       mean)

## Write out the file
	
write.table(format(aggr.data, scientific=T), "tidy_dataset.txt",
            row.names=F, col.names=F, quote=2)

