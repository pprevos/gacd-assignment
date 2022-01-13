# Peer-graded Assignment: Getting and Cleaning Data Course Project
# Peter Prevos

library(tidyverse)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "FUCI HAR Dataset.zip"

if (!file.exists(filename)) {
  download.file(url, destfile = filename)
  unzip(filename)
}

# Read activity labels + features
activity_labels <- read_delim("UCI HAR Dataset/activity_labels.txt", 
                              delim = " ", 
                              col_names = FALSE) %>% 
  rename(activity_id = 1, activity_name = 2)

features <- read_delim("UCI HAR Dataset/features.txt",
                       delim = " ", 
                       col_names = FALSE) %>% 
  rename(feature_id = 1, feature_name = 2)  

# Load Training Data
# 4. Appropriately labels the data set with descriptive variable names
subject_train <- read_table("UCI HAR Dataset/train/subject_train.txt")
names(subject_train) <- "subject_id"


x_train <- read_table("UCI HAR Dataset/train/X_train.txt")
names(x_train) <- features$feature_name

y_train <- read_table("UCI HAR Dataset/train/y_train.txt")
names(y_train) <- "activity_id"

# 2. Extract only the measurements on the mean and standard deviation for each measurement
# 3. Use descriptive activity names to name the activities in the data set
train_data <- bind_cols(subject_train, y_train, x_train) %>% 
  left_join(activity_labels) %>% 
  select(subject_id, activity_name, matches("(mean|std)\\(\\)"))

# Load Test Data
subject_test <- read_table("UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "subject_id"

x_test <- read_table("UCI HAR Dataset/test/X_test.txt")
names(x_test) <- features$feature_name

y_test <- read_table("UCI HAR Dataset/test/y_test.txt")
names(y_test) <- "activity_id"

test_data <- bind_cols(subject_test, y_test, x_test) %>% 
  left_join(activity_labels) %>% 
  select(subject_id, activity_name, matches("(mean|std)\\(\\)"))

# 1. Merge the training and the test sets to create one data set
all_data_tidy <- bind_rows(train_data, test_data) %>% 
  pivot_longer(-1:-2, names_to = "feature", values_to = "measurement") %>% 
  mutate(feature = str_remove_all(feature, "\\(\\)"))

# 5. Create a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.
means_data <- all_data_tidy %>% 
  group_by(subject_id, activity_name, feature) %>% 
  summarise(mean_measurement = mean(measurement))

write.table(means_data, "tidy_means.txt", row.names = FALSE)
