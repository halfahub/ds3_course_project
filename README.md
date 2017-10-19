## Getting and Cleaning Data Course Project

The purpose of this project is to prepare tidy data that can be used for later analysis. 


### The Project directiry contains:

* README.md -- this description.
* run_analysis.R -- data processing script.
* CodeBook.md -- code book that describes the variables, the data, and transformations.
* averaged_by_activity.txt -- tidi data set ready for further analysis.


## Dataset

The data for the project cuold be downloaded using following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Provided script run_analysis.R includes data loading and extracting steps.

### Data summary

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data set represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

More details on the data set and the subject could be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


### Data processing script run_analysis.R does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

More details coud be found in the code book.