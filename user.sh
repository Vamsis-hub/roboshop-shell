#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIME=$(date +%F-%H-%M-%S)

Logfile="/tmp/$0-$TIME.log"


Validate(){

if [  $1 -ne 0 ]
then
    echo -e"$2....$R Failed $N"
    exit 1
else
    echo -e "$2....$G Success $N"
fi



}


if [ $ID -ne 0 ]
then
    echo "$R Error please run with root user $N"
    exit 1
else
    echo "$G I am a root user $N"
fi

dnf module disable nodejs -y &>>$Logfile

Validate $? "diable nodejs"

dnf module enable nodejs:18 -y &>>$Logfile

Validate $? "enabling nodejs" 

dnf install nodejs -y &>>$Logfile

Validate $? "installation of nodejs"

useradd roboshop &>>$Logfile

Validate $? "create user"

mkdir /app &>>$Logfile

Validate $? "creation of directory" 

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$Logfile

Validate $? "downloading zipfile"

cd /app 

unzip /tmp/user.zip  &>>$Logfile

Validate $? "unzipping user file"

cd /app 

npm install &>>$Logfile

Validate $? "installing dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$Logfile

Validate $? "copying to user service"

systemctl daemon-reload &>>$Logfile

Validate $? "daemon reload"

systemctl enable user  &>>$Logfile

Validate $? "enable user"

systemctl start user &>>$Logfile

Validate $? "starting user"

cp /home/centos/roboshop-shell/Mongo.repo /etc/yum.repos.d/mongo.repo &>>$Logfile

Validate $? "coping mongo repo"

dnf install mongodb-org-shell -y &>>$Logfile

Validate $? "installation of mongo repo"

mongo --host mongodb.saanvi.website </app/schema/user.js &>>$Logfile

Validate $? "loading data to mongodb"