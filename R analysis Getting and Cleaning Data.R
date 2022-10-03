
library(tidyr)
library(dplyr)

trainingset<-read.table("~/R files/UCI HAR Dataset/train/X_train.txt")
testset<-read.table("~/R files/UCI HAR Dataset/test/X_test.txt")

features <- read.csv("~/R files/UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
columnnames <- features[2]

colnames(trainingset) <- columnnames$V2
colnames(testset) <- columnnames$V2

trainingset_labels <- read.table("~/R files/UCI HAR Dataset/train/y_train.txt", header = FALSE)
trainingset$activity = as.numeric(unlist(trainingset_labels))
trainingset_subject <- read.table("~/R files/UCI HAR Dataset/train/subject_train.txt")
trainingset$subject = as.numeric(unlist(trainingset_subject))

testset_labels <- read.table("~/R files/UCI HAR Dataset/test/y_test.txt", header = FALSE)
testset$activity = as.numeric(unlist(testset_labels))
testset_subject <- read.table("~/R files/UCI HAR Dataset/test/subject_test.txt")
testset$subject = as.numeric(unlist(testset_subject))

joinset<-bind_rows(trainingset,testset)

joinset$activity[joinset$activity == 1] <- "walking"
joinset$activity[joinset$activity == 2] <- "walking_upstairs"
joinset$activity[joinset$activity == 3] <- "walking_downstairs"
joinset$activity[joinset$activity == 4] <- "sitting"
joinset$activity[joinset$activity == 5] <- "standing"
joinset$activity[joinset$activity == 6] <- "laying"

finalData<-select(joinset,contains("mean"),contains("std"),contains("activity"),contains("subject"))
names(finalData)<-gsub("Acc", "Accelerometer", names(finalData))
names(finalData)<-gsub("Gyro", "Gyroscope", names(finalData))
names(finalData)<-gsub("-freq()", "Frequency", names(finalData))
names(finalData)<-gsub("angle", "Angle", names(finalData))
names(finalData)<-gsub("gravity", "Gravity", names(finalData))
names(finalData)<-gsub("subject", "Subject", names(finalData))
names(finalData)<-gsub("^f", "Frequency", names(finalData))
names(finalData)<-gsub("tBody", "TimeBody", names(finalData))
names(finalData)<-gsub("BodyBody", "Body", names(finalData))
names(finalData)<-gsub("Mag", "Magnitude", names(finalData))
names(finalData)<-gsub("^t", "Time", names(finalData))
names(finalData)<-gsub("activity", "Activity", names(finalData))
names(finalData)<-gsub("-mean()", "Mean", names(finalData))
names(finalData)<-gsub("-std()", "STD", names(finalData))

Tidydata<- finalData %>% group_by(Subject,Activity) %>%
  summarise_all(funs(mean))

write.table(Tidydata,"Tidydata.txt",row.name = FALSE)


