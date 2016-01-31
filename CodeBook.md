## Getting and Cleaning Data Project

Charlie Smith

### Description
This file contains additional information about the variables, data and transformations used in the course project for the Johns Hopkins Getting and Cleaning Data course.

### Source Data
A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source data for this project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Data Set Information
The experiments were carried out on a group of 30 volunteers between the ages of 19 and 48.

Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on their waist.

Using the embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity data was captured at a constant rate of 50Hz. The experiments were video-recorded to label the data manually.

The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window).

The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity.

The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.

From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

- README.txt
- features_info.txt: Shows information about the variables used on the feature vector
- features.txt: List of all features
- activity_labels.txt: Links the class labels with their activity name
- train/subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- train/X_train.txt: Training set
- train/y_train.txt: Training labels
- test/subject_test.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30
- test/X_test.txt: Test set
- test/y_test.txt: Test labels

The following files are available for the train and test data. Their descriptions are equivalent.

- train/Inertial Signals/total_acc_x_train.txt: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
- train/Inertial Signals/body_acc_x_train.txt: The body acceleration signal obtained by subtracting the gravity from the total acceleration.
- train/Inertial Signals/body_gyro_x_test.txt: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

- test/Inertial Signals/total_acc_x_test.txt: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
- test/Inertial Signals/body_acc_x_test.txt: The body acceleration signal obtained by subtracting the gravity from the total acceleration.
- test/Inertial Signals/body_gyro_x_test.txt: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.


### Attribute Information
Each record in the dataset provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

### 1. Merge the test and train data sets to create one data set

After downloading the source archive and extracting the files, the following data files are read into corresponding tables for processing:
- features.txt
- activity_labels.txt
- subject_train.txt
- X_train.txt
- y_train.txt
- subject_test.txt
- X_test.txt
- y_test.txt

Assign column names and merge to create one data set.

### 2. Extract only the measurements on the mean and standard deviation for each measurement

Create a logical vector that contains TRUE values for the ID, mean and stdev columns and FALSE values for the others.
Subset this data to keep only the necessary columns.

### 3. Apply descriptive column names to name the activities in the data set
Merge data subset with the activityType table to include the descriptive activity names.

### 4. Label the data set with descriptive activity names
Use gsub function for pattern replacement to clean up the data labels.

### 5. Create a second tidy data set with the average of each variable for each subject / activity
Per the project instructions, generate a data set with the average of each veriable for each activity and subject.