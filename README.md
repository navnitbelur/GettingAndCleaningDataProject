# GettingAndCleaningDataProject
Repo for Getting and Cleaning Data Project

Following is the description of the program "run_analysis.R" submitted for the Getting and Cleaning Data course project.

Requirements of script:
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The RAW data is first read from each of the "test" and "train" directories and merged using the "rbind" command. 
The RAW dataSet contains all measurements (10299 observations of 561 variables)

In section 2, the measurements that contain "mean()" or "std()" (mean and standard deviation) are extracted
from the raw data
To do this first the features.txt is read in and two logical vectors that determine whether mean() or std() is present
in the measurement name using a regular expression, for e.g.:
  # get logical vectors to determine which measurements are mean() or std()
  meanLogical <- grepl("-mean()", measurements)   # logical vector on measurements for mean()
  stdLogical <- grepl("-std()", measurements)     # logical vector on measurements for std()
  is_mean_or_std <- meanLogical | stdLogical
  # Now SELECT the dataSet so that it contains only 
  # columns that are either mean() or std() using which
  dataSet <- select(dataSet, which(is_mean_or_std))
Using the select dplyr function, the necessary measurements are selected

Steps 3 and 4:

Appropriately labels the data set with descriptive variable names.
Keep only the columns from the data set that correspond to mean() or std() readings
Set the column names of the data set from the measurements data (from features.txt)
All the non alphanumeric characters are replaced with "_" using a regular expression substitution:
  colnames(dataSet) <- gsub("[^a-zA-Z0-9]", "_", columnNames)

In order to provide "meaningful" activity names, the activity column is first added to the data set using cbind
and then replacing each of the 1-6 values with corresponding string values using if statements.

The subject is also added at this point and we have the actual dataSet as required except for the average values

Step 5: Creating the summary

To create the summary, the dataSet is first grouped by subject and activity and then arranged
The summary for each of the mean of mean() and std() measurements is then added

The file is then exported using the write.table command:
write.table(summary, file = "summary.txt", row.name=FALSE)
