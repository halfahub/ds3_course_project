#' ---
#' title: "Getting and Cleaning Data Course Project"
#' output: html_document
#' author: "Aleksandr Laburenko"
#' date: "10/19/2017"
#' ---
#' 
## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

if (!require(data.table)) {
install.packages("data.table")
}

#' 
#' ### Loading Data
#' 
#' Download and unpack files 
#' 
## ----data, cache = TRUE--------------------------------------------------
if (!file.exists("./tmp")) {
        dir.create("./tmp")
}

if (!file.exists("./data")) {
dir.create("./data")
}

if(!file.exists("./tmp/dataset.zip")) {
        download.file(
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
        destfile = "./tmp/dataset.zip"
        )
}

unzip("./tmp/dataset.zip", exdir = ".")

#' 
#' Observing unpacked directories
#' 
## ----obs_data------------------------------------------------------------
dir("./UCI HAR Dataset")
dir("./UCI HAR Dataset/test")
dir("./UCI HAR Dataset/train")

#' 
#' ### 1. Merging the training and the test sets to create one data set.
#' 
#' Observe datasets
## ----features_and_labes--------------------------------------------------
features <-
        fread(
        "./UCI HAR Dataset/features.txt",
        sep = " ",
        header = FALSE,
        col.names = c("feature_id", "feature"),
        stringsAsFactors = FALSE,
        encoding = "UTF-8"
        )
dim(features)
str(features)
        
activity_labels <-
        fread(
        "./UCI HAR Dataset/activity_labels.txt",
        col.names = c("activity_id", "activity_name"),
        stringsAsFactors = FALSE,
        encoding = "UTF-8"
        )
dim(activity_labels)
str(activity_labels)


#' 
#' Load and skim Train data
## ----train_set-----------------------------------------------------------
x_train <-
        fread("./UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
        dim(x_train)
        str(x_train)
        
y_train <-
        fread("./UCI HAR Dataset/train/y_train.txt",
        col.names = c("activity_id"))
dim(y_train)
str(y_train)


#' 
#' Add Subjects dimension 
## ----train_subjects------------------------------------------------------
train_subjects <-
        fread("./UCI HAR Dataset/train/subject_train.txt",
        col.names = c("subject"))
dim(train_subjects)
table(train_subjects)

if (dim(x_train)[1] == dim(train_subjects)[1]) {
        train_data <- cbind(train_subjects, x_train)
        dim(train_data)
        }

#' 
#' Add Activities dimension 
## ----train_activity------------------------------------------------------
y_train$activity_factor <-
        factor(
                y_train$activity_id,
                levels = activity_labels$activity_id,
                labels = activity_labels$activity_name
        )
str(y_train)
        
if (dim(train_data)[1] == dim(y_train)[1]) {
        train_data <- cbind(y_train[, 2], train_data)
        dim(train_data)
        }

#' 
#' 
#' Load and observe Test data
## ----test_set------------------------------------------------------------
x_test <-
  fread("./UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
  dim(x_test)

#  Add Subjects dimension 
test_subjects <-
        fread("./UCI HAR Dataset/test/subject_test.txt",
        col.names = c("subject"))
dim(test_subjects)
table(test_subjects)

if (dim(x_test)[1] == dim(test_subjects)[1]) {
        test_data <- cbind(test_subjects, x_test)
        dim(train_data)
        }
#  Add Activities dimension   
y_test <- fread("./UCI HAR Dataset/test/y_test.txt")
names(y_test)[1] <- "activity_id"

y_test$activity_factor <-
factor(
        y_test$activity_id,
        levels = activity_labels$activity_id,
        labels = activity_labels$activity_name
)
str(y_test)

if (dim(test_data)[1] == dim(y_test)[1]) {
        test_data <- cbind(y_test[, 2], test_data)
        dim(test_data)
}

#' 
#' Merge Training and Test datasets in one
#' 
## ----merged_set----------------------------------------------------------
if (dim(test_data)[2] == dim(train_data)[2]) {
        all_data <- rbind(train_data, test_data)
        all_data$subject <-factor(all_data$subject)
        write.table(all_data, "./data/all_data.txt")
} else stop("Udable to join training and test datasets")

dim(all_data)

#' 
#' ### 2. Extracting only the measurements on the mean and standard deviation for each measurement.
#' 
#' Using the RegExp filter *features* dataset, containing features list to find Mean and SD measurements
#' 
## ----mean_sd_columns-----------------------------------------------------
mean_sd_cols <- grepl("std|mean", as.character(features$feature))
mean_sd_cols <- c(TRUE, TRUE, mean_sd_cols)
mean_sd_data <- all_data[, ..mean_sd_cols]

dim(mean_sd_data)
str(mean_sd_data)


#' 
#' Remember that features was augmented by activity and subject in first two columns, 
#' so include two TRUE values for them in the resulting logical vector
#' 
## ----save_mean_sd_columns------------------------------------------------
write.table(mean_sd_data,"./data/mean_sd_data.txt")

#' 
#' ### 3. Setting descriptive activity names to name the activities in the data set.
#' 
#' This requirement is fulfilled on step 1, when Activities column is attached as a factor
#' 
## ----activity_factor-----------------------------------------------------
class(mean_sd_data$activity_factor)
table(mean_sd_data$activity_factor)
str(mean_sd_data$activity_factor)

#' 
#' ### 4. From the data set in step 2, creating a second, independent tidy data set with the average of each variable for each activity and each subject.
#' 
## ----tidy_averaged_by_subject--------------------------------------------
averaged_by_subjectactivity <- aggregate(. ~subject + activity_factor, mean_sd_data, mean)


names(averaged_by_subjectactivity) <- gsub("sd\\(\\)","SD", names(averaged_by_subjectactivity))
names(averaged_by_subjectactivity) <- gsub("mean\\(\\)","Mean", names(averaged_by_subjectactivity))
names(averaged_by_subjectactivity) <- gsub("meanFreq\\(\\)","Mean_Freq", names(averaged_by_subjectactivity))
names(averaged_by_subjectactivity)[-1] <- paste("Avg", names(averaged_by_subjectactivity)[-1], sep = "_")
names(averaged_by_subjectactivity)[1] <- "Subject"
names(averaged_by_subjectactivity)[2] <- "Activity"

dim(averaged_by_subjectactivity) 

str(averaged_by_subjectactivity)

write.table(averaged_by_subjectactivity,"./data/averaged_by_subjectactivity.txt", row.name=FALSE)

