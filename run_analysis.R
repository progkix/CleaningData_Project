#===================================================================================================
# Coursera Getting and Cleaning Data Course Project 2
# Charlie Smith
# 2015-01-31
#
# run_analysis.R File Description:
#
# This script will perform the following steps on the UCI HAR Dataset downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 1. Merge the test and train data sets to create one data set
# 2. Extract only the measurements on the mean and standard deviation for each measurement
# 3. Apply descriptive column names to name the activities in the data set
# 4. Label the data set with descriptive activity names
# 5. Create a second tidy data set with the average of each variable for each subject / activity
#===================================================================================================
#    Folder Layout
#    +-- RWD
#        +-- data
#            +-- UCI HAR Dataset
#                +-- README.txt
#                +-- activity_labels.txt
#                +-- features.txt
#                +-- features_info.txt
#                +-- test
#                    +-- Inertial Signals (Not used)
#                    +-- subject_test.txt
#                    +-- X_test.txt
#                    +-- y_test.txt
#                +-- train
#                    +-- Inertial Signals (Not used)
#                    +-- subject_train.txt
#                    +-- X_train.txt
#                    +-- y_train.txt
#        +-- run_analysis.R
#===================================================================================================
# File definitions
SourceFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

DownloadFile <- "./data/HumanActivity.zip"

ActivityFile <- "./data/UCI HAR Dataset/activity_labels.txt"
FeaturesFile <- "./data/UCI HAR Dataset/features.txt"

TestXFile <- "./data/UCI HAR Dataset/test/X_test.txt"
TestYFile <- "./data/UCI HAR Dataset/test/y_test.txt"
TestSubjectFile <- "./data/UCI HAR Dataset/test/subject_test.txt"

TrainXFile <- "./data/UCI HAR Dataset/train/X_train.txt"
TrainYFile <- "./data/UCI HAR Dataset/train/y_train.txt"
TrainSubjectFile <- "./data/UCI HAR Dataset/train/subject_train.txt"

TidyFile <- "./data/tidy.txt"
#===================================================================================================
# Download source file if it doesn't exist
if (!file.exists(DownloadFile))
{
	cat("Downloading source file\n")

	download.file(SourceFile, DownloadFile, quiet = TRUE)
}

# Extract contents of source file if it exists
if (file.exists(DownloadFile))
{
	cat("Extracting source data\n")

	file <- unzip(DownloadFile, overwrite = T, exdir = "./data")
}

# Verify all required files are present and process
if (file.exists(ActivityFile) & file.exists(FeaturesFile) &
    file.exists(TestXFile) & file.exists(TestYFile) & file.exists(TestSubjectFile) &
    file.exists(TrainXFile) & file.exists(TrainYFile) & file.exists(TrainSubjectFile))
{
    #===============================================================================================
    # 1. Merge the test and train data sets to create one data set
    #===============================================================================================

    # Read in the Features and Activity Type files
    cat("Loading Features and Activity Types\n")

    FeaturesData = read.table(FeaturesFile, header = FALSE)
    ActivityTypeData = read.table(ActivityFile, header = FALSE)

    # Assign column names to the data imported above
    colnames(ActivityTypeData)  = c('activityId', 'activityType')

    # Read in the X, Y and Subject Test files
    cat("Loading Test Data\n")

    TestXData = read.table(TestXFile, header = FALSE)
    TestYData = read.table(TestYFile, header = FALSE)
    TestSubjectData = read.table(TestSubjectFile, header = FALSE)

    # Assign column names to the test data imported above
    colnames(TestXData) = FeaturesData[,2]
    colnames(TestYData) = "activityId"
    colnames(TestSubjectData) = "subjectId"

    # Create the final test set by merging TestXData, TestYData and TestSubjectData
    TestData = cbind(TestYData, TestSubjectData, TestXData)

    # Read in the X, Y and Subject Train files
    cat("Loading Train data\n")

    TrainXData = read.table(TrainXFile, header = FALSE)
    TrainYData = read.table(TrainYFile, header = FALSE)
    TrainSubjectData = read.table(TrainSubjectFile, header = FALSE)

    # Assign column names to the data imported above
    colnames(TrainXData) = FeaturesData[,2]
    colnames(TrainYData) = "activityId"
    colnames(TrainSubjectData) = "subjectId"

    # Create the final train set by merging TrainXData, TrainYData and TrainSubjectData
    TrainData = cbind(TrainYData, TrainSubjectData, TrainXData)

    # Combine training and test data to create a final data set
    cat("Merging Train and Test data\n")

    AllData = rbind(TrainData, TestData)

    # Create a vector for the column names from AllData which will be used to select the desired mean() & stddev() columns
    ColumnNames  = colnames(AllData)

    #===============================================================================================
    # 2. Extract only the measurements on the mean and standard deviation for each measurement
    #===============================================================================================
    cat("Extracting measurement data\n")

    # Create a LogicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
    LogicalVector = (grepl("activity..", ColumnNames) | grepl("subject..", ColumnNames) | grepl("-mean..", ColumnNames) & !grepl("-meanFreq..", ColumnNames) & !grepl("mean..-", ColumnNames) | grepl("-std..", ColumnNames) & !grepl("-std()..-", ColumnNames))

    # Subset finalData table based on the logicalVector to keep only desired columns
    AllData = AllData[LogicalVector == TRUE]

    #===============================================================================================
    # 3. Apply descriptive column names to name the activities in the data set
    #===============================================================================================
    cat("Applying descriptive column names\n")

    # Merge the finalData set with the acitivityType table to include descriptive activity names
    AllData = merge(AllData, ActivityTypeData, by = 'activityId', all.x = TRUE)

    # Update the colNames vector to include the new column names after merge
    ColumnNames  = colnames(AllData)

    #===============================================================================================
    # 4. Label the data set with descriptive activity names
    #===============================================================================================
    cat("Cleaning up variable names\n")

    # Clean up the variable names
    for (i in 1:length(ColumnNames))
    {
        ColumnNames[i] = gsub("\\()", "", ColumnNames[i])
        ColumnNames[i] = gsub("-std$", "StdDev", ColumnNames[i])
        ColumnNames[i] = gsub("-mean", "Mean", ColumnNames[i])
        ColumnNames[i] = gsub("^(t)", "time", ColumnNames[i])
        ColumnNames[i] = gsub("^(f)", "freq", ColumnNames[i])
        ColumnNames[i] = gsub("([Gg]ravity)", "Gravity", ColumnNames[i])
        ColumnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)", "Body", ColumnNames[i])
        ColumnNames[i] = gsub("[Gg]yro", "Gyro", ColumnNames[i])
        ColumnNames[i] = gsub("AccMag", "AccMagnitude", ColumnNames[i])
        ColumnNames[i] = gsub("([Bb]odyaccjerkmag)", "BodyAccJerkMagnitude", ColumnNames[i])
        ColumnNames[i] = gsub("JerkMag", "JerkMagnitude", ColumnNames[i])
        ColumnNames[i] = gsub("GyroMag", "GyroMagnitude", ColumnNames[i])
    }

    # Reassigning the new descriptive column names to AllData
    colnames(AllData) = ColumnNames;

    #===============================================================================================
    # 5. Create a second tidy data set with the average of each variable for each subject / activity
    #===============================================================================================
    cat("Creating second tidy data set\n")

    # Create a new table, AllDataNoActivityType without the activityType column
    AllDataNoActivityType = AllData[,names(AllData) != 'activityType']

    # Summarize the AllDataNoActivityType table to include just the mean of each variable for each activity and each subject
    TidyData = aggregate(AllDataNoActivityType[,names(AllDataNoActivityType) != c('activityId', 'subjectId')], by = list(activityId = AllDataNoActivityType$activityId, subjectId = AllDataNoActivityType$subjectId), mean)

    # Merge the tidyData with activityType to include descriptive activity names
    TidyData = merge(TidyData, ActivityTypeData, by = 'activityId', all.x = TRUE)

    # Export the TidyData set
    write.table(TidyData, TidyFile, row.names = TRUE, sep = '\t')
}