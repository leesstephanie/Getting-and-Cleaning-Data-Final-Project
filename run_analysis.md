



This report was automatically generated with the R package **knitr**
(version 1.29).


```r
setwd("R/ds3/FinalProject")
```

```
## Error in setwd("R/ds3/FinalProject"): cannot change working directory
```

```r
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
  summarise(across(3:last_col(), mean))
```

```
## `summarise()` regrouping output by 'activity' (override with `.groups` argument)
```

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.6.0 (2019-04-26)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 19041)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252 LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] dplyr_1.0.2 readr_1.3.1 tidyr_1.1.1 knitr_1.29 
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.5       rstudioapi_0.11  magrittr_1.5     hms_0.5.3        tidyselect_1.1.0
##  [6] R6_2.4.1         rlang_0.4.7      stringr_1.4.0    highr_0.8        tools_3.6.0     
## [11] xfun_0.15        tinytex_0.25     htmltools_0.5.0  ellipsis_0.3.1   assertthat_0.2.1
## [16] yaml_2.2.1       digest_0.6.25    tibble_3.0.1     lifecycle_0.2.0  crayon_1.3.4    
## [21] purrr_0.3.4      vctrs_0.3.2      glue_1.4.1       evaluate_0.14    rmarkdown_2.3   
## [26] stringi_1.4.6    compiler_3.6.0   pillar_1.4.4     generics_0.0.2   pkgconfig_2.0.3
```

```r
Sys.time()
```

```
## [1] "2020-09-08 17:49:17 +07"
```

