

run_analysis <- function(){
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
    df[, 'labels'] <- y
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
  
  # Print the merged data frame
  print(head(mergedDF, 10))
  
  # Load dplyr library
  library(dplyr)
  
  # How many columns are we interested in?
  # All columns minus the two last which are the labels and subjects
  numCol <- length(mergedDF) - 2
  
  # Select the first numCol-th columns and apply the mean function
  newDF <- sapply(select(mergedDF,1:numCol), mean)
  
  print(newDF)
  
}




