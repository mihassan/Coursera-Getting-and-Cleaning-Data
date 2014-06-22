Getting and Cleaning Data - CodeBook
====================================
This file describes the original data, any transformations or work that I have performed to clean up the data, and the final variables.  

Original Data
-------------
The original data[^1] is collected from "Human Activity Recognition Using Smartphones Dataset"[^2].
The dataset was collected from experiments performed by Smartlab - Non Linear Complex Systems Laboratory.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

Transformations
---------------
The run_analysis.R script performs the following steps to clean the data:

1. Merges the training and the test sets to create one data set.
  1. Read subject_train.txt files from "./data/train" and "./data/test" folders and merge them in to `subject.data` variable.
  2. Read y_train.txt and y_test.txt files from "./data/train" and "./data/test" folders and merge them in to `activity.data` variable.
  3. Read X_train.txt and X_test.txt files from "./data/train" and "./data/test" folders and merge them in to `ssensor.data` variable.

2. Extracts only the measurements on the mean and standard deviation for each measurement.
  1. Read the features.txt file from the "./data/" folder and store the data in a variable called `feature.data`.
  2. Find the index of the features related to the mean and standard deviation and store that in a variable called `feature.idx`.
  3. From `sensor.data` extract only columns indicated by `feature.idx` and we are left with a 66 column data.frame.
  4. Finally, rename the columns of `sensor.data` with the features.
  
3. Uses descriptive activity names to name the activities in the data set.
  1. Read descriptive activity labels from "./data/activity_labels.txt" and store them in a variable called `activity.labels`.
  2. Rename the activity labels by removing "_" and camel casing the activity labels. For example, "WALKING_UPSTAIRS" would be renamed as "Walking Upstairs".
  3. Join `activity.data` with `activity.labels` and store them in `activity.data`, so that each activity in the `activity.data` now has descriptive name. Not that, while joining two data.frames care was taken to ensure that the order of rows in `activity.data` does not change.

4. Appropriately labels the data set with descriptive names. 
  1. Merge `subject.data`, `activity.data`, and `sensor.data` together to create the first merged data set called `merged.data`.
  2. Appropriately label the columns of `merged.data`.
  3. Write `merged.data` to the "merged_data.txt" file in the current working directory.

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
  1. Convert `merged.data` from wide to tall/long format using and store it in a variable called `long.data` for each "subject" and "activity".
  2. Generate a tidy data set, `tidy.data` with the average of each measurement for each activity and each subject. 
     We have 30 unique subjects and 6 unique activities, which result in a 180 combinations of the two.
     We also have 66 total features which results in 11880 rows in total in the `tidy.data` data.frame.
  3. Use the `feature_extract()` method from "feature_extract.R" script supplied here to split the feature/variable column in to 7 columns:
     1. "domain"
     2. "source"
     3. "sensor"
     4. "jerk"
     5. "magnitude"
     6. "statistic"
     7. "axis"
  4. Rebind the "subject", "activity"columns with the columns extracted from previous step and "mean" obseravation in to `tidy.data`.
  5. Write `tidy.data` to the "tidy_data.txt" file in the current working directory.

Variables
---------
The final tidy data set generated following the above steps, has 10 columns/variables and 11880 (=6x30x66) rows/observations. The variables are described below:

1. __subject__: 1..30 a number representing the subject
2. __activity__: The activity (out of 6 possible activities) the subject was performing
  1. Walking
  2. Walking Upstairs
  3. Walking Downstairs
  4. Sitting
  5. Standing
  6. Laying
3. __domain__: Time, Frequency
4. __source__: Body, Gravity
5. __sensor__: Acceleration, Gyroscopic
6. __jerk__: Yes, No
7. __magnitude__: Yes, No
8. __statistics__: Mean, Standard Deviation
9. __axis__: X, Y, Z
10. __mean__: Mean value of such reading accross all time/frequency

[^1]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
[^2]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
