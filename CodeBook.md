---
title: "CodeBook"
author: "Stephanie_Lee_S"
date: "9/7/2020"
output: html_document
---

This codebook provides a brief explanation of a tidy data set I generate for further analysis.

## Study design
The data is from Human Activity Recognition Using Smartphones Dataset. There are 30 people involved in this study; they do 6 activities while wearing Samsung Galaxy S II on the waist. The device capture various signals, and the signals obtained are preprocessed to generate a total of 561 features in the raw data set. The raw data set is then partitioned into two parts, training set (which consists of data for 21 volunteers) and test set (consists data for 9 volunteers).

For more information about this study design, check the original description: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## Data source
Here are the original data for the project: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

## Transformation details
Firstly, both datasets (the training set and the test set) are merged. Then, variables of mean and standard deviation of each measurement are extracted from the merged data set. The data are already normalized and bounded between -1 and 1 inclusive. 

Then, I add two columns which identify the activities and subjects (in that order) for each observation. The vector of activities is processed first (changing numbers into words to make it clearer) before added to the data set. 

The final step to produce the tidy data set is to group by activity and subjects, making 180 groups of data, then calculate the average for all measurements. 

A step-by-step instruction of obtaining the tidy data set can be looked at the script file `run_analysis.R`

## Tidy data set description
The tidy data set has 66 variables and 180 observations (the combination of 30 subjects and 6 activities). The variables are variables from the raw data set which contains word "mean()" or "std()".