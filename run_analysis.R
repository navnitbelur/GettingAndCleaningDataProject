# Requirements of script:
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr) # load the dplyr library

#----------------------------------------------------------------
# Requirement 1:
# Merge both (test and train) raw data into the data frames
# there are 3 data frames here:
# the actual dataSet gathered from X_test.txt
# the corresponding labels gathered from y_test.txt
# the corresponding subjects gathered from subject_test

subjects_raw <- rbind(read.table("UCI HAR Dataset/test//subject_test.txt"),
                     read.table("UCI HAR Dataset/train//subject_train.txt"))
dataSet_raw <- rbind(read.table("UCI HAR Dataset/test//X_test.txt"),
               read.table("UCI HAR Dataset/train//X_train.txt"))
labels_raw <- rbind(read.table("UCI HAR Dataset/test//y_test.txt"),
               read.table("UCI HAR Dataset/train//y_train.txt"))

# create the unified tidy dataset table
dataSet <- tbl_df(dataSet_raw)

#----------------------------------------------------------------
# Requirement 2:
# keep only the columns from the data set that correspond to mean() or std() readings

# get all the measurements labels in a vector by 
# reading the features data (the 561 column variables)
measurements <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)$V2

# get logical vectors to determine which measurements are mean() or std()
meanLogical <- grepl("-mean()", measurements)   # logical vector on measurements for mean()
stdLogical <- grepl("-std()", measurements)     # logical vector on measurements for std()

is_mean_or_std <- meanLogical | stdLogical

# Now SELECT the dataSet so that it contains only 
# columns that are either mean() or std() using which
dataSet <- select(dataSet, which(is_mean_or_std))

#----------------------------------------------------------------
# Requirement 4:
# Appropriately labels the data set with descriptive variable names.
#
# keep only the columns from the data set that correspond to mean() or std() readings
# set the column names of the data set from the measurements data
columnNames <- measurements[which(is_mean_or_std)]
# set columnNames after removing all the invalid chars
colnames(dataSet) <- gsub("[^a-zA-Z0-9]", "_", columnNames)

#----------------------------------------------------------------
# Requirement 3: add meaningful activity names to the dataSet

# add a column to the data set called "Activity" 
Activity <- labels_raw$V1
dataSet <- cbind(Activity, dataSet)

for(i in 1:length(dataSet$Activity)) {
        if (dataSet$Activity[i] == 1) dataSet$Activity[i] = "WALKING"
        else if (dataSet$Activity[i] == 2) dataSet$Activity[i] = "WALKING_UPSTAIRS"
        else if (dataSet$Activity[i] == 3) dataSet$Activity[i] = "WALKING_DOWNSTAIRS"
        else if (dataSet$Activity[i] == 4) dataSet$Activity[i] = "SITTING"
        else if (dataSet$Activity[i] == 5) dataSet$Activity[i] = "STANDING"
        else if (dataSet$Activity[i] == 6) dataSet$Activity[i] = "LAYING"
        else dataSet$Activity[i] = NA
}

# Add the Subjects to the data set as well
Subject <- subjects_raw$V1
dataSet <- cbind(Subject, dataSet)

#----------------------------------------------------------------
# Print the required summary ordered by subject and activity 
# and the mean of each measurement
dataSet <- arrange(group_by(dataSet, Subject, Activity ))
summary <- summarize(dataSet, 
                "avg(tBodyAcc_mean___X)" = mean(tBodyAcc_mean___X),
                "avg(tBodyAcc_mean___Y)" = mean(tBodyAcc_mean___Y),
                "avg(tBodyAcc_mean___Z)" = mean(tBodyAcc_mean___Z),
                "avg(tBodyAcc_std___X)" = mean(tBodyAcc_std___X),
                "avg(tBodyAcc_std___Y)" = mean(tBodyAcc_std___Y),
                "avg(tBodyAcc_std___Z)" = mean(tBodyAcc_std___Z),
                "avg(tGravityAcc_mean___X)" = mean(tGravityAcc_mean___X),
                "avg(tGravityAcc_mean___Y)" = mean(tGravityAcc_mean___Y),
                "avg(tGravityAcc_mean___Z)" = mean(tGravityAcc_mean___Z),
                "avg(tGravityAcc_std___X)" = mean(tGravityAcc_std___X),
                "avg(tGravityAcc_std___Y)" = mean(tGravityAcc_std___Y),
                "avg(tGravityAcc_std___Z)" = mean(tGravityAcc_std___Z),
                "avg(tBodyAccJerk_mean___X)" = mean(tBodyAccJerk_mean___X),
                "avg(tBodyAccJerk_mean___Y)" = mean(tBodyAccJerk_mean___Y),
                "avg(tBodyAccJerk_mean___Z)" = mean(tBodyAccJerk_mean___Z),
                "avg(tBodyAccJerk_std___X)" = mean(tBodyAccJerk_std___X),
                "avg(tBodyAccJerk_std___Y)" = mean(tBodyAccJerk_std___Y),
                "avg(tBodyAccJerk_std___Z)" = mean(tBodyAccJerk_std___Z),
                "avg(tBodyGyro_mean___X)" = mean(tBodyGyro_mean___X),
                "avg(tBodyGyro_mean___Y)" = mean(tBodyGyro_mean___Y),
                "avg(tBodyGyro_mean___Z)" = mean(tBodyGyro_mean___Z),
                "avg(tBodyGyro_std___X)" = mean(tBodyGyro_std___X),
                "avg(tBodyGyro_std___Y)" = mean(tBodyGyro_std___Y),
                "avg(tBodyGyro_std___Z)" = mean(tBodyGyro_std___Z),
                "avg(tBodyGyroJerk_mean___X)" = mean(tBodyGyroJerk_mean___X),
                "avg(tBodyGyroJerk_mean___Y)" = mean(tBodyGyroJerk_mean___Y),
                "avg(tBodyGyroJerk_mean___Z)" = mean(tBodyGyroJerk_mean___Z), 
                "avg(tBodyGyroJerk_std___X)" = mean(tBodyGyroJerk_std___X),
                "avg(tBodyGyroJerk_std___Y)" = mean(tBodyGyroJerk_std___Y),
                "avg(tBodyGyroJerk_std___Z)" = mean(tBodyGyroJerk_std___Z),
                "avg(tBodyAccMag_mean__)" = mean(tBodyAccMag_mean__),
                "avg(tBodyAccMag_std__)" = mean(tBodyAccMag_std__),
                "avg(tGravityAccMag_mean__)" = mean(tGravityAccMag_mean__),
                "avg(tGravityAccMag_std__)" = mean(tGravityAccMag_std__),
                "avg(tBodyAccJerkMag_mean__)" = mean(tBodyAccJerkMag_mean__),
                "avg(tBodyAccJerkMag_std__)" = mean(tBodyAccJerkMag_std__),
                "avg(tBodyGyroMag_mean__)" = mean(tBodyGyroMag_mean__),
                "avg(tBodyGyroMag_std__)" = mean(tBodyGyroMag_std__),
                "avg(tBodyGyroJerkMag_mean__)" = mean(tBodyGyroJerkMag_mean__),
                "avg(tBodyGyroJerkMag_std__)" = mean(tBodyGyroJerkMag_std__),
                "avg(fBodyAcc_mean___X)" = mean(fBodyAcc_mean___X),
                "avg(fBodyAcc_mean___Y)" = mean(fBodyAcc_mean___Y),
                "avg(fBodyAcc_mean___Z)" = mean(fBodyAcc_mean___Z),
                "avg(fBodyAcc_std___X)" = mean(fBodyAcc_std___X),
                "avg(fBodyAcc_std___Y)" = mean(fBodyAcc_std___Y),
                "avg(fBodyAcc_std___Z)" = mean(fBodyAcc_std___Z),
                "avg(fBodyAcc_meanFreq___X)" = mean(fBodyAcc_meanFreq___X),
                "avg(fBodyAcc_meanFreq___Y)" = mean(fBodyAcc_meanFreq___Y),
                "avg(fBodyAcc_meanFreq___Z)" = mean(fBodyAcc_meanFreq___Z),
                "avg(fBodyAccJerk_mean___X)" = mean(fBodyAccJerk_mean___X),
                "avg(fBodyAccJerk_mean___Y)" = mean(fBodyAccJerk_mean___Y),
                "avg(fBodyAccJerk_mean___Z)" = mean(fBodyAccJerk_mean___Z),
                "avg(fBodyAccJerk_std___X)" = mean(fBodyAccJerk_std___X),
                "avg(fBodyAccJerk_std___Y)" = mean(fBodyAccJerk_std___Y),
                "avg(fBodyAccJerk_std___Z)" = mean(fBodyAccJerk_std___Z),
                "avg(fBodyAccJerk_meanFreq___X)" = mean(fBodyAccJerk_meanFreq___X),
                "avg(fBodyAccJerk_meanFreq___Y)" = mean(fBodyAccJerk_meanFreq___Y),
                "avg(fBodyAccJerk_meanFreq___Z)" = mean(fBodyAccJerk_meanFreq___Z),
                "avg(fBodyGyro_mean___X)" = mean(fBodyGyro_mean___X),
                "avg(fBodyGyro_mean___Y)" = mean(fBodyGyro_mean___Y),
                "avg(fBodyGyro_mean___Z)" = mean(fBodyGyro_mean___Z),
                "avg(fBodyGyro_std___X)" = mean(fBodyGyro_std___X),
                "avg(fBodyGyro_std___Y)" = mean(fBodyGyro_std___Y),
                "avg(fBodyGyro_std___Z)" = mean(fBodyGyro_std___Z),
                "avg(fBodyGyro_meanFreq___X)" = mean(fBodyGyro_meanFreq___X),
                "avg(fBodyGyro_meanFreq___Y)" = mean(fBodyGyro_meanFreq___Y),
                "avg(fBodyGyro_meanFreq___Z)" = mean(fBodyGyro_meanFreq___Z),
                "avg(fBodyAccMag_mean__)" = mean(fBodyAccMag_mean__),
                "avg(fBodyAccMag_std__)" = mean(fBodyAccMag_std__),
                "avg(fBodyAccMag_meanFreq__)" = mean(fBodyAccMag_meanFreq__),
                "avg(fBodyBodyAccJerkMag_mean__)" = mean(fBodyBodyAccJerkMag_mean__),
                "avg(fBodyBodyAccJerkMag_std__)" = mean(fBodyBodyAccJerkMag_std__),
                "avg(fBodyBodyAccJerkMag_meanFreq__)" = mean(fBodyBodyAccJerkMag_meanFreq__),
                "avg(fBodyBodyGyroMag_mean__)" = mean(fBodyBodyGyroMag_mean__),
                "avg(fBodyBodyGyroMag_std__)" = mean(fBodyBodyGyroMag_std__),
                "avg(fBodyBodyGyroMag_meanFreq__)" = mean(fBodyBodyGyroMag_meanFreq__),
                "avg(fBodyBodyGyroJerkMag_mean__)" = mean(fBodyBodyGyroJerkMag_mean__),
                "avg(fBodyBodyGyroJerkMag_std__)" = mean(fBodyBodyGyroJerkMag_std__),
                "avg(fBodyBodyGyroJerkMag_meanFreq__)" = mean(fBodyBodyGyroJerkMag_meanFreq__)
                )
write.table(summary, file = "summary.txt", row.name=FALSE)

