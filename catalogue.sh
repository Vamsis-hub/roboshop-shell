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

Validate $? "disbaling nodejs"

dnf module enable nodejs:18 -y &>>$Logfile

Validate $? "enabling nodejs" 

dnf install nodejs -y &>>$Logfile

Validate $? "Installation nodejs" 

useradd roboshop &>>$Logfile

Validate $? "User created" 

mkdir /app &>>$Logfile

Validate $? "App directory created" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$Logfile


Validate $? "Downloading catalogue" 

cd /app  

unzip -o /tmp/catalogue.zip &>>$Logfile

Validate $? "unzipping catalogue" 

cd /app

npm install  &>>$Logfile

Validate $? "installing dependencies" 

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$Logfile

Validate $? "copying catalogue.service file"

systemctl daemon-reload &>>$Logfile

Validate $? "catalogue daemon reload"

systemctl enable catalogue &>>$Logfile

Validate  $? "Enable catalogue"

systemctl start catalogue  &>>$Logfile

Validate  $? "Starting catalogue"

cp /home/centos/roboshop-shell/Mongo.repo /etc/yum.repos.d/mongo.repo &>>$Logfile

Validate $? "COPYING Mongo.repo" 

dnf install mongodb-org-shell -y &>>$Logfile

Validate $? "Installing mongo client" 

mongo --host mongodb.saanvi.website </app/schema/catalogue.js &>>$Logfile

Validate $? "loading catalogue into mongodb"









