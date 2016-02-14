library(dplyr)
library(tidyr)

test.acc.x<-read.table(".\\UCI HAR Dataset\\test\\Inertial Signals\\body_acc_x_test.txt")
test.acc.y<-read.table(".\\UCI HAR Dataset\\test\\Inertial Signals\\body_acc_y_test.txt")
test.acc.z<-read.table(".\\UCI HAR Dataset\\test\\Inertial Signals\\body_acc_z_test.txt")
test.gyro.x<-read.table(".\\UCI HAR Dataset\\test\\Inertial Signals\\body_gyro_x_test.txt")
test.gyro.y<-read.table(".\\UCI HAR Dataset\\test\\Inertial Signals\\body_gyro_y_test.txt")
test.gyro.z<-read.table(".\\UCI HAR Dataset\\test\\Inertial Signals\\body_gyro_z_test.txt")
test.user<-read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
test.type<-read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
colnames(test.user)<-"user"
colnames(test.type)<-"activity"

test.acc.x<-mutate(cbind(test.user,test.type,test.acc.x),measurement='acc.x')
test.acc.y<-mutate(cbind(test.user,test.type,test.acc.y),measurement='acc.y')
test.acc.z<-mutate(cbind(test.user,test.type,test.acc.z),measurement='acc.z')
test.gyro.x<-mutate(cbind(test.user,test.type,test.gyro.x),measurement='gyro.x')
test.gyro.y<-mutate(cbind(test.user,test.type,test.gyro.y),measurement='gyro.y')
test.gyro.z<-mutate(cbind(test.user,test.type,test.gyro.z),measurement='gyro.z')

train.acc.x<-read.table(".\\UCI HAR Dataset\\train\\Inertial Signals\\body_acc_x_train.txt")
train.acc.y<-read.table(".\\UCI HAR Dataset\\train\\Inertial Signals\\body_acc_y_train.txt")
train.acc.z<-read.table(".\\UCI HAR Dataset\\train\\Inertial Signals\\body_acc_z_train.txt")
train.gyro.x<-read.table(".\\UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_x_train.txt")
train.gyro.y<-read.table(".\\UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_y_train.txt")
train.gyro.z<-read.table(".\\UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_z_train.txt")
train.user<-read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
train.type<-read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
colnames(train.user)<-"user"
colnames(train.type)<-"activity"

train.acc.x<-mutate(cbind(train.user,train.type,train.acc.x),measurement='acc.x')
train.acc.y<-mutate(cbind(train.user,train.type,train.acc.y),measurement='acc.y')
train.acc.z<-mutate(cbind(train.user,train.type,train.acc.z),measurement='acc.z')
train.gyro.x<-mutate(cbind(train.user,train.type,train.gyro.x),measurement='gyro.x')
train.gyro.y<-mutate(cbind(train.user,train.type,train.gyro.y),measurement='gyro.y')
train.gyro.z<-mutate(cbind(train.user,train.type,train.gyro.z),measurement='gyro.z')

alldata<-rbind(train.acc.x,train.acc.y,train.acc.z,train.gyro.x,train.gyro.y,train.gyro.z,
               test.acc.x,test.acc.y,test.acc.z,test.gyro.x,test.gyro.y,test.gyro.z)

typedef<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

alldata<-gather(alldata,meas.id,meas,V1:V128)
alldata$meas.id<-NULL

final <- data.frame(user=integer(),activity=character(),measurement=character(),mean=numeric(),std=numeric())

for(iii in unique(alldata$user)) {
  for(jjj in unique(alldata$activity)) {
    for(kkk in unique(alldata$measurement)) {
      print(iii)
      tmp<-filter(alldata,user==iii,activity==jjj,measurement==kkk)
      final<-rbind(final,data.frame(user=iii,activity=typedef[jjj],measurement=kkk,mean=mean(tmp$meas),std=sd(tmp$meas)))
    }
  }
}
write.table(final,file="final.txt",row.name=FALSE)
