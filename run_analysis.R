## Load required libraries
library(plyr)
library(reshape2)
source("feature_extract.R")

## Step1. Merges the training and the test sets to create one data set.
subject.files <- c("./data/train/subject_train.txt", 
                   "./data/test/subject_test.txt")
subject.data <- ldply(subject.files, read.table)

activity.files <- c("./data/train/y_train.txt", 
                    "./data/test/y_test.txt")
activity.data <- ldply(activity.files, read.table)

sensor.files <- c("./data/train/X_train.txt", 
                  "./data/test/X_test.txt")
sensor.data <- ldply(sensor.files, read.table)

## Step2. Extracts only the measurements on the mean and standard 
## deviation for each measurement. 
feature.data <- read.table("./data/features.txt")
feature.idx <- grep("mean\\(|std\\(", feature.data[, 2])
sensor.data <- sensor.data[, feature.idx]
colnames(sensor.data) <- feature.data[feature.idx, 2]

## Step3. Uses descriptive activity names to name the activities in 
## the data set.
activity.labels <- read.table("./data/activity_labels.txt")
labels <- as.character(activity.labels[,2])
labels <- sapply(labels, function(s) {
    s <- strsplit(s, "_")[[1]]
    paste(toupper(substring(s, 1, 1)), 
          tolower(substring(s, 2)), 
          sep = "", collapse=" ")
  }
)
activity.labels[,2] <- labels
activity.data <- join(activity.data, activity.labels, "V1")

## Step4. Appropriately labels the data set with descriptive names. 
merged.data <- data.frame(subject=subject.data[,1],
                          activity=activity.data[,2],
                          sensor.data, check.names=F)
write.table(merged.data, "merged_data.txt", row.names=F)
 
## Step5. Creates a second, independent tidy data set with the average of 
## each variable for each activity and each subject. 
long.data <- melt(merged.data, id.vars=c("subject", "activity"))
tidy.data <- ddply(long.data, .(subject, activity, variable), summarize, 
                   mean=mean(value))

feature.columns <- feature_extract(as.character(tidy.data[,3]))
tidy.data <- cbind(tidy.data[,1:2], feature.columns, mean=tidy.data[,4])
write.table(tidy.data, "tidy_data.txt", row.names=F)