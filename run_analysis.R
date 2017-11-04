# Loading data.table package
library(data.table)

#Merges the training and the test sets to create one data set
##############################################################

#Loading features
features <- read.table("./UCI HAR Dataset/features.txt",sep="")
feature_label <- as.character(features[,2])

#Loading training data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",sep="")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",sep="")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",sep="")
merged_train <- cbind(subject_train, y_train, x_train)

#Loading testing data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",sep="")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",sep="")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",sep="")
merged_test <- cbind(subject_test, y_test, x_test)

#Merging trainingf and testing data
merged_train_test <- rbind(merged_train, merged_test)

 
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Appropriately labels the data set with descriptive variable names
########################################################################################
colnames(merged_train_test) <- c("SubjectNumber","ActivityNumber", feature_label) 
lst_mean <- grep("mean", colnames(merged_train_test))
lst_std <- grep("std", colnames(merged_train_test))
mean_and_standard_col_list <- sort(c(1,2,lst_mean, lst_std))
mean_and_standard <- merged_train_test[mean_and_standard_col_list]


#Uses descriptive activity names to name the activities in the data set
#1-WALKING, 2-WALKING_UPSTAIRS, 3-WALKING_DOWNSTAIRS, 4-SITTING, 5-STANDING, 6-LAYING
#####################################################################################
activity_labels <- c(WALKING=1, WALKING_UPSTAIRS=2, WALKING_DOWNSTAIRS=3, SITTING=4, STANDING=5, LAYING=6)
mean_and_standard$ActivityNumber <- names(activity_labels)[match(mean_and_standard$ActivityNumber, activity_labels)]


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each
#activity and each subject
####################################################################################################################
mean_and_standard.dt <-data.table(mean_and_standard)
final_tidy_data <- mean_and_standard.dt[, lapply(.SD, mean), by=c("SubjectNumber","ActivityNumber")]
write.csv(final_tidy_data, file="final_tidy_data.csv", row.names=FALSE)
