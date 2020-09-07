setwd("R/ds3/FinalProject")
library(tidyr); library(readr); library(dplyr)

#Step 1: merge two data sets: train set, then test set
combined_raw <- rbind(read.table("UCI HAR Dataset/train/X_train.txt"), 
                      read.table("UCI HAR Dataset/test/X_test.txt")) %>% tbl_df

#Step 2: load the feature names
features <- read_lines("UCI HAR Dataset/features.txt")

#Step 3: extract only the mean and the standard deviation for each measurements
combined_selected <- combined_raw %>% 
  select(paste0("V", grep("mean[()]|std", features)))

##use the descriptive names to set the activity names in the data set
#Step 4: load the activity labels, then take the words only
#So, instead of "1 WALKING", we get "WALKING"
activity_labels <- read_lines("UCI HAR Dataset/activity_labels.txt")
activity_labels <- strsplit(activity_labels, split = " ")
activity_labels <- sapply(activity_labels, function(x) x[[2]])

#Step 5: load the activities done for each observation, 
#both from the training set and the test set.
#The result would be a vector of numbers, ranging from 1 to 6.
activities <- c(read_lines("UCI HAR Dataset/train/y_train.txt"),
                read_lines("UCI HAR Dataset/test/y_test.txt"))
activities <- as.numeric(activities)

#Step 6: map the activity labels to the activity vector
actwords <- sapply(activities, function(x) activity_labels[x])

#Step 7: adding the column of activity words we just made to the data set
combined_with_act <- mutate(combined_selected, activity = actwords)

#Step 8: name the variables in the data set
features_selected <- grep("mean[()]|std", features, value = TRUE)
names(combined_with_act) <- c(features_selected, "activity")

#Step 9: produce a tiny data set
#Firstly, we add a column identifying the subjects in the study
#Then, we group the data set by activity and subject
#Lastly, we calculate the mean for all measurements
combined_new <- combined_with_act %>% 
  mutate(subject = c(read_lines("UCI HAR Dataset/train/subject_train.txt"),
                     read_lines("UCI HAR Dataset/test/subject_test.txt"))) %>%
  group_by(activity, subject) %>% 
  summarise(across(1:last_col(offset = 2), mean))