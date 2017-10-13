if (!file.exists("./data")) {
  dir.create("./data")
}

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/dataset.zip")

unzip("./data/dataset.zip",exdir = "./data")

setwd("./data/UCI HAR Dataset")

getwd()

dir("./test")
dir("./train")

