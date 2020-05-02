#Download the data for the project
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"./data4/five.zip")

#Unzip the file to /data1 directory
unzip(zipfile="./data4/five.zip",exdir="./data1")

#list.files("./data1")
#read the files and store it as an object
x_train <- read.table("./data1/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data1/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data1/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data1/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data1/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data1/UCI HAR Dataset/test/subject_test.txt")

activity_labels <- read.table("./data1/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

#Assign the column names
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

#1.Merge the training and the test sets to create one data set.
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
mrg_data <- rbind(mrg_train,mrg_test)


#2.Extract only the measurements on the mean and standard deviation for each measurement.

mean_std <- (grepl("activityId" , Colnames) | 
                             grepl("subjectId" , Colnames) | 
                             grepl("mean\\(\\)" , Colnames) | 
                             grepl("std" , Colnames) )

mean_std_data <- mrg_data[ , mean_std == TRUE]

#3.Use descriptive activity names to name the activities in the data set

data_activitynames <- merge( activity_labels,mean_std_data,
                              by='activityId',
                              all.x=TRUE)

#4.Appropriately label the data set with descriptive variable names.
names(data_activitynames)<-gsub("^t","times",names(data_activitynames))
names(data_activitynames)<-gsub("^f","frequency",names(data_activitynames))
names(data_activitynames)<-gsub("Acc","Accelerometer",names(data_activitynames))
names(data_activitynames)<-gsub("Gyro","Gyroscope",names(data_activitynames))
names(data_activitynames)<-gsub("Mag","Magnitude",names(data_activitynames))
names(data_activitynames)<-gsub("BodyBody","Body",names(data_activitynames))
#names(data_activitynames)

#5.From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

secondTidySet <- aggregate(. ~subjectId + activityType, data_activitynames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$activityId),]

write.table(secondTidySet, "secondTidySet.txt", row.names =FALSE)




