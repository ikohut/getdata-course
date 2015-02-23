require(data.table)
require(dplyr)

run_analysis <- function() {
    # Set few variables which represents location of data files
    folderRoot <- paste(getwd(), "UCI HAR Dataset", sep="/")
    folderTest <- paste(folderRoot, "test", sep="/")
    folderTrain <- paste(folderRoot, "train", sep="/")
    
    # Load Activity Labels
    activityLabels <- tbl_dt(read.table(paste(folderRoot, "activity_labels.txt", sep="/")))
    setnames(activityLabels, c("V1", "V2"), c("ActivityId", "Activity"))
    
    # Load List of Columns (features)
    features <- tbl_dt(read.table(paste(folderRoot, "features.txt", sep="/")))
    
    # Filter out all features except mean and std calculation 
    meanORsd <- filter(
        features, 
        (grepl("-mean()", features$V2) | grepl("-std()", features$V2)) 
            & !grepl("-meanFreq()", features$V2))
    
    # Prepare tidied set from "test" folder
    testSet <- prepareSet(
        meanORsd,
        paste(folderTest, "X_test.txt", sep="/"),
        paste(folderTest, "y_test.txt", sep="/"),
        paste(folderTest, "subject_test.txt", sep="/")
    )
    
    # Prepare tidied set from "train" folder
    trainSet <- prepareSet(
        meanORsd,
        paste(folderTrain, "X_train.txt", sep="/"),
        paste(folderTrain, "y_train.txt", sep="/"),
        paste(folderTrain, "subject_train.txt", sep="/")
    )
    
    # Bind two sets of data together
    resultSet <- rbind(testSet, trainSet)
    
    # Append Activity column and arrange rows
    t <- merge(activityLabels, resultSet, by = "ActivityId") %>% arrange(ActivityId, Subject) %>% select(-ActivityId)   
    
    # Group data and apply mean to each column
    grouped <- group_by(t, Activity, Subject)
    tidy <- summarise_each(grouped, funs(mean))
    
    tidy
}

prepareSet <- function (meanORsd, Xfile, yfile, sfile){
    # Read X file and set column names
    X <- read.table(Xfile)
    X <- tbl_dt(X[, meanORsd$V1])
    setnames(X, names(X), as.character(meanORsd$V2))
    
    # Read y file
    y<- tbl_dt(read.table(yfile))
    setnames(y, "V1", "ActivityId")
    
    # Read subject file
    subject <- tbl_dt(read.table(sfile))
    setnames(subject, "V1", "Subject")
    
    # Combine 3 data tables
    cbind(subject, y, X)
    
}