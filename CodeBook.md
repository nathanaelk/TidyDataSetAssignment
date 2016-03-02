## CodeBook for the Programming Assignment of the Week 4

WARNING: There is a dependency on the dplyr library

Download the zip file
Unzip the file 
Set the root of the file as working directory

Load data frames from the files: features.txt, activity_labels.txt,
X_train.txt, y_train.txt, subject_train.txt, X_test.txt, y_test.txt,
subject_test.txt

Process the files formated X_*.txt, y_*.txt and subject_*.txt the same way and create
train and test data frames. Replace data frames from y_*.txt with the labels with the
data from activity_labels.txt

Rename the column name using the data from the data frame created from features.txt


Merge the 2 data frames and then select the measurements columns and apply the mean
function to those measurements.