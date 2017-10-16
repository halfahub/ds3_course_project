if (!require(data.table)) {
  install.packages("data.table")
}

if (!file.exists("./tmp")) {
  dir.create("./tmp")
}

### Loading and unpacking Data

download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  destfile = "./tmp/dataset.zip"
)

unzip("./tmp/dataset.zip", exdir = ".")


if (file.exists("./UCI HAR Dataset")) {
  setwd("./UCI HAR Dataset")
} else
  exit("Unable to unzip data.")

## Creating output dir

if (!file.exists("./data")) {
  dir.create("./data")
}

## 1. Merging the training and the test sets to create one data set.

features <-
  fread(
    "./features.txt",
    sep = " ",
    header = FALSE,
    col.names = c("feature_id", "feature"),
    stringsAsFactors = FALSE,
    encoding = "UTF-8"
  )

activity_labels <-
  fread(
    "./activity_labels.txt",
    col.names = c("activity_id", "activity_name"),
    stringsAsFactors = FALSE,
    encoding = "UTF-8"
  )

### Load Training data

x_train <-
  fread("./train/X_train.txt", col.names = features$feature)

activity_labels <- fread("./activity_labels.txt")
names(activity_labels) <- c("activity_id", "activity_name")

y_train <- fread("./train/y_train.txt")
names(y_train)[1] <- "activity_id"


### Add Activities dimension

y_train$activity_factor <-
  factor(
    y_train$activity_id,
    levels = activity_labels$activity_id,
    labels = activity_labels$activity_name
  )

if (dim(x_train)[1] == dim(y_train)[1]) {
  train_data <- cbind(y_train[, 2], x_train)
  dim(train_data)
}

### Load Test data

x_test <-
  fread("./test/X_test.txt", col.names = features$feature)

y_test <- fread("./test/y_test.txt")
names(y_test)[1] <- "activity_id"

y_test$activity_factor <-
  factor(
    y_test$activity_id,
    levels = activity_labels$activity_id,
    labels = activity_labels$activity_name
  )

if (dim(x_test)[1] == dim(y_test)[1]) {
  test_data <- cbind(y_test[, 2], x_test)
  dim(test_data)
}

## Merge Training and Test datasets in one and save tidy set

if (dim(test_data)[2] == dim(train_data)[2]) {
  all_data <- rbind(train_data, test_data)
  dim(all_data)
  write.table(all_data, "./data/all_data.txt")
}

### 2. Extracting only the measurements on the mean 
###    and standard deviation for each measurement.

mean_sd_cols <- grepl("std|mean", as.character(features$feature))

### Remember that features was augmented by activity in 1st column,
### so include one mo TRUE value for it in the resulting logical vector

mean_sd_cols <- c(TRUE, mean_sd_cols)
mean_sd_data <- all_data[, ..mean_sd_cols]

write.table(mean_sd_data, "./data/mean_sd_data.txt")

### 3. From the data set in step 2, creating a second, independent 
###    tidy data set with the average of each variable for each activity and each subject.

averaged_by_activity <- mean_sd_data[, lapply(.SD, mean), by = "activity_factor"]
names(averaged_by_activity) <- gsub("sd\\(\\)", "SD", names(averaged_by_activity))
names(averaged_by_activity) <- gsub("mean\\(\\)", "Mean", names(averaged_by_activity))
names(averaged_by_activity) <- gsub("meanFreq\\(\\)", "Mean_Freq", names(averaged_by_activity))
names(averaged_by_activity)[-1] <- paste("Avg", names(averaged_by_activity)[-1], sep = "_")
names(averaged_by_activity)[1] <- "Activity"

write.table(averaged_by_activity, "./data/averaged_by_activity.txt",row.name=FALSE)

setwd("..")