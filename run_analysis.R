#First create a new folder and download the file
# Generate unique name for the folder
library(lubridate)
newFolder <- gsub(':', '', gsub('-', '', gsub(' ', '', now())))
dir.create(newFolder)
setwd(newFolder)

# Download and extract the zip file
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', 'dataset.zip')
unzip('dataset.zip')
setwd('UCI HAR Dataset')

# Create a data frame from data set of features
features <- read.table("features.txt")

# Create a data frame from data set of activity labels
activityLabel <- read.table("activity_labels.txt")

# Create a function helper that converts a number to a label
convertLabel <- function(numCode){
  activityLabel$V2[numCode]
}

folders <- c("train", "test")

for(folder in folders) {
  # Create an empty data frame that will be filled up with the data from
  # the files
  t <- data.frame()
  
  # Create a regex to remove the folder name
  folderPrefixRegx <- paste0('^(',folder, .Platform$file.sep, ')')
  
  for(localFile in list.files(folder, pattern = '*.txt', recursive = FALSE, full.names = TRUE)){
    
    # Remove everything until the path separator
    fileName <- sub(folderPrefixRegx, '', localFile)
    
    if (fileName == paste0('X_', folder, '.txt')) {
      X <- read.table(localFile)
      
      # Modify the column names with the names from the features data set
      colnames(X) <- features$V2
    } else if (fileName == paste0('y_', folder, '.txt')) {
      y <- read.table(localFile)
      y <- sapply(y, convertLabel)
    }
    else if (fileName == paste0('subject_', folder, '.txt')) {
      subject <- read.table(localFile)
    }
  }
  
  df <- X
  df[, 'activity'] <- y[,1]
  df[, 'subject'] <- subject
  
  if (folder == "train"){
    training <- df
  } else if (folder == "test")
  {
    testing <- df
  }
  
  
}

# Merge train and test data frames
mergedDF <- rbind(training, testing)

# Load the dplyr library
library(dplyr)

# Select only the column of the average and standdard deviation of the measurements
mean_and_std_df <- select(mergedDF, grep('(mean)|(std)|(activity)|(subject)', colnames(mergedDF)))

# Get the average by activity and subject
# Remove the first and second columns because they are duplicated
tidy_df <- aggregate(mean_and_std_df, by=list(activity=mean_and_std_df$activity, subject=mean_and_std_df$subject), mean)[-c(1,2)]

print(colnames(tidy_df))

# Serialize the tidy data frame into a file
write.table(tidy_df, "tidy_df.txt")