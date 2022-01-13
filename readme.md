# Getting and Cleaning Data Course Project

This is the submission for the course project for the _Getting and Cleaning Data_ course by John Hopkins University. The R script, `course_project.R` loads, extracts and transforms the raw data and undertakes a simple analysis in the following steps:

1. Download and unzip the data, if not already available on the drive
2. Load training and test data
    - Appropriately labels the data set with descriptive variable names
    - Extract only the measurements on the mean and standard deviation for each measurement
    - Use descriptive activity names to name the activities in the data set
3. Merge the training and the test sets to create one data set
4. Create a second, independent tidy data set with the average of each variable for each activity and each subject

The results are saved in the `tidy_means.csv` file. The `codebook.md` file describes the variables in this file.