library(dplyr)
library(tidyr)

#read the column name.
cnames<-sub("\\d+ ", "",readLines(".\\UCI HAR Dataset\\features.txt"))

#read the data
data<-rbind(read.table(".\\UCI HAR Dataset\\train\\X_train.txt"),
            read.table(".\\UCI HAR Dataset\\test\\X_test.txt"))
            
#read the subject id
user<-rbind(read.table(".\\UCI HAR Dataset\\train\\subject_train.txt"),
            read.table(".\\UCI HAR Dataset\\test\\subject_test.txt"))

#read the activity
activity<-rbind(read.table(".\\UCI HAR Dataset\\train\\y_train.txt"),
                read.table(".\\UCI HAR Dataset\\test\\y_test.txt"))

colnames(user)<-"subject_id"
colnames(activity)<-"activity"
colnames(data)<-cnames

#remove unwanted columns
outcol<-grepl("mean|std",cnames)
data<-data[,outcol]

#put comprehensive labels
actlabels<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
activity<-data.frame(activity=factor(activity$activity,labels=actlabels))

data<-cbind(user,activity,data)

#output step 4.
write.table(data,file="data1.txt",row.name=FALSE,quote=FALSE)

#calculate the average for each subject and each activity.
data2<-aggregate(data,list(data$subject_id,data$activity),mean)
data2$subject_id<-NULL
data2$activity<-NULL

colnames(data2)[1]<-"subject_id"
colnames(data2)[2]<-"activity"

#output step 5.
write.table(data2,file="data2.txt",row.name=FALSE,quote=FALSE)
