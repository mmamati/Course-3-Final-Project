# Course-3-Final-Project
Repository for files for final project for John Hopkins Course 3
Created by M. Amati Mar 2018
Process Overview and Codebook below

# Background
The run_analysis.R file executes the analysis to produce the final output, which is a tidy data set summarizing measurements by participant from the UC Irvine repository of data collected from the accelerometers from the Samsung Galaxy S smartphone. 

More information about this data can be found here
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data is stored here
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The analysis accomplished 5 tasks:
1 - Merges the training and the test sets to create one data set.
2 - Extracts only the measurements on the mean and standard deviation for each measurement.
3 - Uses descriptive activity names to name the activities in the data set
4 - Appropriately labels the data set with descriptive variable names.
5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Process Overview
The process in run_analysis.r takes the following steps.

Step 1:  Downloads the raw data from the above site and unzips the files.  The directory to save the files and store output is set here.

Step 2: The features.txt file from the data contains a list of 561 feature names for the X-data in the set.  This file is opened
        and the features assigned to a vector for use in final data set
        Also in this step the labels for the y-data, which is one of 6 activities, are extracted from the activity_labels.txt file.

Step 3: The Training Set is appended to the bottom of the Test set. 
        The Training Set and test set each consist of 3 parts:  1.) X-data which is the measurements from the accelerometers 
        2.) Y-data which is a number indicating one of 6 activities the user was undertaking when the data was gathered.
        3.) Subject ID which is an integer from 1 to 30 representing which of the 30 participants generated the data

        For each of these parts, the corresponding test and training set data is opened and appended, with the test data on top.
        A unique ID is created starting at 1 for the top row.  Since order is preserved these IDs are used to join the data.
        
        After the data is joined, a subset of X-data is retained.  The raw data contained several tranformation to the data, such as             skewness, kurtosis, etc.  For the purposes of this data, only mean and std measurements were preserved.  meanFreq variables             were not kept.

Step 4  The X-data retained was given new variable names to make them more readable.  See the Code Book below for an explanation of             variable names and more details on the variables

Step 5  The data was sumarized by Subject_ID, creating a smaller table with one row for ever subject for every activity.  (30 subjects x          6 activities for 180 rows).  The average of the data for each meaururement by subject and activity was calculated.  Altough,            atypical Standard Deviation was averaged.  This data set was output to the file Course_3_Final_Project_Outset.txt

# Codebook
## Data variables
There are 66 variables that represent transformations of data from the accelerometer and gyroscope.  Each variable is given a name comprised of 6 parts which describe the type of data it is.  Those parts are put together in the following order to make the variable names. 

Notes:  These names are used in output file to represent the average of all the data in the raw files downloaded above. 
Also, with 6 parts there are 2*2*2*2*4*2 = 128 possible combinations, but only 66 are meaningful and present
### Part 1: Time or Frequency:  

Time represents a direct signal from the sensor captured at a constant rate of 50Hz.  As explained in the ReadMe file from UCI these signals have been filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.

Frequency represents a measurement of the time signal produced by applyling a Fast Fourier Transform to the time signals.  Some, but not all of the time signals were processed this way.

### Part 2: Body or Gravity

Acceleration Signals were separated into body and gravity acceleratin portions using a low pass Butterworth filter with a corner frequency of 0.3 Hz. 

### Part 3:  Acc or Gyro

This part of the name indicates whether the signal was captured from the accelerometer (Acc) or the gyroscope (Gyro)

### Part 4: Signal or Jerk
For some of the signals, the body linear and angular velovity were derived to obtain Jerk signals.  For data representing these Jerk Signals "Jerk" is used in part 4 of the name.  For the data that has not been further processed this way "Signal" is used

### Part 5: Direction
For each signal, data in the X,Y, and Z directions was obtained and indicated here as such.  Further, the magnitude of the signals was calculated using the Euclidean Norm.  For these measurements, Mag is used for this part of the name

### Part 6: Measurement
The final part indicates whether the data is the Mean od Standard Deviation (Std of the signal)

### Examples
FreqBodyAccSignalMagMean - Frequency data from the Body acceleration from the acceleromoter without Jerk Processing.  The mean of the magnitude is reported

TimeBodyGyroJerkXMean - The Jerk time signal from the body acceleration repored from the gyroscope.  The mean of the X-direction movement has been calculated

### Other variables
Two other variables are present in the output file
Subject_ID - an integer from 1 to 30 representing the subject
Activity - a description of one of 6 activities the participant was undertaking at the time the data was collected

### Units
All features are normalized and boundedn [-1 to 1]
