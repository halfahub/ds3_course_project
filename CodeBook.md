# CodeBook

## Prerequisites 

* If you do not have *data.table* package it will be installed.

## Source data

The data set splitted in two parts: train set and test set, each of them contains:

1. the measured data (X_train.txt and X_train.txt) - set of 561 parameter, labeled in file features.txt.
2. the markers for activities (y_train.txt and y_train.txt) labeled in file activity_labels.txt. 
3. the markers for subjects (subject_train.txt and subject_test.txt).
4. additional suplimentaly measurements (in "Internal Signals" subfolders) which will not be a part of this work. 

## Processing structures

Common parameters are stored in 

* features -- 561 x 2 data frame, containing integer *feature_id* and character *feature* name. 
* activity_labels -- 6 x 2 data frame, containing integer *activity_id* and character *activity_name*.

Original training data set stores to 

* x_train -- original measures data frame as 7352 x 561 numeric matrix. 
* y_train -- 7352 x 2 dataframe, which column "activity_factor" contains 6-level factor of activities, labeled by activity names.
* train_subjects -- 7352 x 1 dataframe, containing 21-levels factor of subjects.

Tidy TRAINING data set is stored to 

* train_data -- 7352 x 563 data frame, which includes Activities and Subject factors.

Original training data set stores to 

* x_test -- original measures data frame as 2947 x 561 numeric matrix. 
* y_test -- 2947 x 2 dataframe, which column "activity_factor" contains 6-level factor of activities, labeled by activity names.
* test_subjects -- 2947 x 1 dataframe, containing 9-level factor of subjects.

Tidy TEST data set is stored to 

* test_data - tidy Training 2947 x 563 data frame, which includes Activities and Subject factors.

Joined tidy data set

* **all_data** -- 10299 x 563 data frame obtained as result of merge *test_data* with *train_data*. 'Subject' column contains 30-levels factor of subjects. This structure is also stored in the file /data/all_data.txt for further analysis. 

Data frame, containing only *Mean* and *Standard deviation* of registered parameters for each measurement. 

* **mean_sd_data** -- 10299 x 81 data frame, containing activvity, subject, and 79 features with presence of *Mean* and *Std* in their names. Stored in the file /data/mean_sd_data.txt for future use.

Resulting data set

Intependant data set with the average of each variable for each activity and each subject.

* **averaged_by_subjectactivity** -- 180 x 81 data set where *mean_sd_data* values averaged by 6 activities of 30 subjects.
 Note that names of columns are different from that of *mean_sd_data*, order the same.