#install.packages("plyr")
#install.packages("dplyr")

library(plyr)
library(data.table)
library(dplyr)

##############################################################################################################################
# Function to append training and test files. 
#it accepts the directory and name of the training file and the test file and a vector for the features of the tables to be read
# The the test file will be on top of the combined tables
# The function also adds a new field, $Record_ID, which is sequential starting at 1 and serves as a unique indicator.
Append<-function(testfile, trainfile,features){
  test<-read.table(testfile,sep="",col.names=features)
  train<-read.table(trainfile,sep="",col.names=features)
  comb<-rbind(test,train)
  comb$Record_ID<-seq(1:nrow(comb))
  combined_set<-comb
}
################################################################################################################################


################################# Step 1:  Download data from website ############################################################
# This step downloads the raw data and unzips it

# Set the working directory where the final project is stored.
FinalDir<-  "C:/Users/Mike/Documents/Coursera/JohnsHopkinsDataScience/Course3GettingandCleaningData/FinalProject"
setwd(FinalDir)
#set the link to the data
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#set the name of the outfile
zipfile<-paste(FinalDir,"Wearables_data",sep="/")
#download the data
download.file(fileURL,zipfile)
#unzip
unzip(zipfile, files = NULL, list = FALSE, overwrite = TRUE)

########################################  End Step 1 Downloading Data ############################################################

########################################### Step 2 Set Features of X,Y, and Subject tables #######################################
# This step takes the features for the X-data from the provided features file
# It also chooses names for the y-labels and the subject labels

#The name of the file director where the features is stored.  
#UHCwd= "C:/Users/Mike/Documents/Coursera/JohnsHopkinsDataScience/Course3GettingandCleaningData/FinalProject/UCI HAR Dataset"
#setwd(UHCwd)
#Load the table and take only the second column, which contains the features names
features<-read.table("./UCI HAR Dataset/features.txt",sep="")[,2]

#Choose the names for the activity (y-labels) features and read the table
Activity_features<-c("Activity_Num","Activity")
activities<-read.table("./UCI HAR Dataset/activity_labels.txt",col.names=Activity_features)

##########################################  End Step 2 - Feature Names ###########################################################

#################################  Step 3  - Combine the test and train sets for X,Y, and Subject data  #########################

## Step 3a Open X file, append then, and add a unique ID
Xtest_file="./UCI HAR Dataset/test/X_test.txt"
Xtrain_file="./UCI HAR Dataset/train/X_train.txt"
Xcombined<-Append(Xtest_file,Xtrain_file,features)

## Step 3b Open Y file, append then, and add a unique ID
ylabel<-activities[1]
Ytest_file="./UCI HAR Dataset/test/Y_test.txt"
Ytrain_file="./UCI HAR Dataset/train/Y_train.txt"
Ycombined<-Append(Ytest_file,Ytrain_file,Activity_features[1])

## Step 3c Open Subject files, append then, and add a unique ID
Sublabel<-c("Subject_ID")
Subtest_file="./UCI HAR Dataset/test/subject_test.txt"
Subtrain_file="./UCI HAR Dataset/train/subject_train.txt"
Subcombined<-Append(Subtest_file,Subtrain_file,Sublabel)


#Step3d - Merge Subject, X, and Y combined sets.  Add readable labels to Activities
joinlist<-list(Subcombined,Xcombined,Ycombined)
Master_Set<-join_all(joinlist)
Master_Set<-join(Master_Set,activities,by=Activity_features[1])
# Select "Mean" and "Std" lables.  Note that MeanFreq has been ommitted.
Select_Set<-select(Master_Set,Sublabel,"Record_ID",contains(".mean."),contains("std"),Activity_features[2])

############################  End Step 3 - Combining Test and Train sets ######################################

#############################  Step 4 Rename X- Features ####################################################
##### See ReadMe file for information on X-feature names 


#This is a list of names to be changed.  These are the remaining data fields after Selecting the desired fields in the previous 
#Step.  The order is important, and if step 3d is changed, this must also be changed.
names_to_change<-c( 
  "tBodyAcc.mean...X",   "tBodyAcc.mean...Y",   "tBodyAcc.mean...Z",   "tGravityAcc.mean...X",   "tGravityAcc.mean...Y",
  "tGravityAcc.mean...Z",   "tBodyAccJerk.mean...X",   "tBodyAccJerk.mean...Y",   "tBodyAccJerk.mean...Z",   "tBodyGyro.mean...X",
  "tBodyGyro.mean...Y",   "tBodyGyro.mean...Z",   "tBodyGyroJerk.mean...X",   "tBodyGyroJerk.mean...Y",   "tBodyGyroJerk.mean...Z",
  "tBodyAccMag.mean..",   "tGravityAccMag.mean..",   "tBodyAccJerkMag.mean..",   "tBodyGyroMag.mean..",   "tBodyGyroJerkMag.mean..",
  "fBodyAcc.mean...X",   "fBodyAcc.mean...Y",   "fBodyAcc.mean...Z",   "fBodyAccJerk.mean...X",   "fBodyAccJerk.mean...Y",
  "fBodyAccJerk.mean...Z",   "fBodyGyro.mean...X",   "fBodyGyro.mean...Y",   "fBodyGyro.mean...Z",   "fBodyAccMag.mean..",
  "fBodyBodyAccJerkMag.mean..",   "fBodyBodyGyroMag.mean..",   "fBodyBodyGyroJerkMag.mean..",   "tBodyAcc.std...X",
  "tBodyAcc.std...Y",   "tBodyAcc.std...Z",   "tGravityAcc.std...X",   "tGravityAcc.std...Y",   "tGravityAcc.std...Z",
  "tBodyAccJerk.std...X",   "tBodyAccJerk.std...Y",   "tBodyAccJerk.std...Z",   "tBodyGyro.std...X",   "tBodyGyro.std...Y",
  "tBodyGyro.std...Z",   "tBodyGyroJerk.std...X",   "tBodyGyroJerk.std...Y",   "tBodyGyroJerk.std...Z",   "tBodyAccMag.std..",
  "tGravityAccMag.std..",   "tBodyAccJerkMag.std..",   "tBodyGyroMag.std..",   "tBodyGyroJerkMag.std..",   "fBodyAcc.std...X",
  "fBodyAcc.std...Y",   "fBodyAcc.std...Z",   "fBodyAccJerk.std...X",   "fBodyAccJerk.std...Y",   "fBodyAccJerk.std...Z",
  "fBodyGyro.std...X",   "fBodyGyro.std...Y",   "fBodyGyro.std...Z",   "fBodyAccMag.std..",   "fBodyBodyAccJerkMag.std..",
  "fBodyBodyGyroMag.std..",   "fBodyBodyGyroJerkMag.std.." )

#This is a list of the new names.  See ReadMe file for logic.  The order is important.  If the names to change list above
#changes then this list must change accordingly.  
newnames<-c( 
  "TimeBodyAccSignalXMean",  "TimeBodyAccSignalYMean",  "TimeBodyAccSignalZMean",  "TimeGravityAccSignalXMean",
  "TimeGravityAccSignalYMean",  "TimeGravityAccSignalZMean",  "TimeBodyAccJerkXMean",  "TimeBodyAccJerkYMean",
  "TimeBodyAccJerkZMean",  "TimeBodyGyroSignalXMean",  "TimeBodyGyroSignalYMean",  "TimeBodyGyroSignalZMean",  "TimeBodyGyroJerkXMean",
  "TimeBodyGyroJerkYMean",  "TimeBodyGyroJerkZMean",  "TimeBodyAccSignalMagMean",  "TimeGravityAccSignalMagMean",
  "TimeBodyAccJerkMagMean",  "TimeBodyGyroSignalMagMean",  "TimeBodyGyroJerkMagMean",  "FreqBodyAccSignalXMean",
  "FreqBodyAccSignalYMean",  "FreqBodyAccSignalZMean",  "FreqBodyAccJerkXMean",  "FreqBodyAccJerkYMean",  "FreqBodyAccJerkZMean",
  "FreqBodyGyroSignalXMean",  "FreqBodyGyroSignalYMean",  "FreqBodyGyroSignalZMean",  "FreqBodyAccSignalMagMean",
  "FreqBodyAccJerkMagMean",  "FreqBodyGyroSignalMagMean",  "FreqBodyGyroJerkMagMean",  "TimeBodyAccSignalXStd",
  "TimeBodyAccSignalYStd",  "TimeBodyAccSignalZStd",  "TimeGravityAccSignalXStd",  "TimeGravityAccSignalYStd",
  "TimeGravityAccSignalZStd",  "TimeBodyAccJerkXStd",  "TimeBodyAccJerkYStd",  "TimeBodyAccJerkZStd",  "TimeBodyGyroSignalXStd",
  "TimeBodyGyroSignalYStd",  "TimeBodyGyroSignalZStd",  "TimeBodyGyroJerkXStd",  "TimeBodyGyroJerkYStd",
  "TimeBodyGyroJerkZStd",  "TimeBodyAccSignalMagStd",  "TimeGravityAccSignalMagStd",  "TimeBodyAccJerkMagStd",
  "TimeBodyGyroSignalMagStd",  "TimeBodyGyroJerkMagStd",  "FreqBodyAccSignalXStd",  "FreqBodyAccSignalYStd",  "FreqBodyAccSignalZStd",
  "FreqBodyAccJerkXStd",  "FreqBodyAccJerkYStd",  "FreqBodyAccJerkZStd",  "FreqBodyGyroSignalXStd",  "FreqBodyGyroSignalYStd",
  "FreqBodyGyroSignalZStd",  "FreqBodyAccSignalMagStd",  "FreqBodyAccJerkMagStd",  "FreqBodyGyroSignalMagStd",
  "FreqBodyGyroJerkMagStd")
#Use dplyr to change names all at once
setnames(Select_Set,old=names_to_change, new=newnames)

#####Summarize by Subject and Activity
Summary_Set<-Select_Set %>% group_by(Subject_ID,Activity) %>% summarise_all(funs(mean))
setwd(FinalDir)
write.table(Summary_Set,file="Course_3_Final_Project_Outset.txt",row.names=FALSE)

