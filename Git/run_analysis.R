#Reading Data

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("/UCI HAR Dataset/train/subject_train.txt")
View(subject_train)
View(x_train)
View(y_train)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
View(features)
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Applying column names to train and test data 
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2]
colnames(y_test) <-"activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

#Merging the test and train data
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
merge_data <- rbind(mrg_train, mrg_test)

#Getting only columns having either mean or standard deviation data
column_names <- colnames(merge_data)
mean_and_std <- (grepl("activityId" , column_names) | grepl("subjectId" , column_names) | grepl("mean.." , column_names) |grepl("std.." , column_names) )
data_mean_sd <- merge_data[ , mean_and_std == TRUE]
View(data_mean_sd)

#Final data
Final_data<-merge(data_mean_sd,activityLabels,by='activityId',all.x=TRUE)

#Final average data group by subjectid and activityid
avg_final <- aggregate(. ~subjectId + activityId, Final_data, mean) 
avg_final <- avg_final[order(avg_final$subjectId, avg_final$activityId),]
View(avg_final)
write.table(avg_final, "tidy.txt", row.name=FALSE)
