library(dplyr)
library(tidyr)

cnames<-sub("\\d+ ", "",readLines(".\\UCI HAR Dataset\\features.txt"))

data<-rbind(read.table(".\\UCI HAR Dataset\\train\\X_train.txt"),
            read.table(".\\UCI HAR Dataset\\test\\X_test.txt"))
            
user<-rbind(read.table(".\\UCI HAR Dataset\\train\\subject_train.txt"),
            read.table(".\\UCI HAR Dataset\\test\\subject_test.txt"))

activity<-rbind(read.table(".\\UCI HAR Dataset\\train\\y_train.txt"),
                read.table(".\\UCI HAR Dataset\\test\\y_test.txt"))

colnames(user)<-"user_id"
colnames(activity)<-"activity"
colnames(data)<-cnames

outcol<-grepl("mean|std",cnames)
data<-data[,outcol]

actlabels<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
activity<-data.frame(activity=factor(activity$activity,labels=actlabels))

data<-cbind(user,activity,data)

write.table(data,file="data1.txt",row.name=FALSE,quote=FALSE)

tmp<-aggregate(data,list(data$user_id,data$activity),mean)

tmp$user_id<-NULL
tmp$activity<-NULL

colnames(tmp)[1]<-"user_id"
colnames(tmp)[2]<-"activity"

write.table(tmp,file="data2.txt",row.name=FALSE,quote=FALSE)
