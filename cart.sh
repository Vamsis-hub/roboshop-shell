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
    echo -e "$R Error please run with root user $N"
    exit 1
else
    echo "I am a root user"
fi

dnf module disable nodejs -y &>>$Logfile

Validate $? "disable nodejs"

dnf module enable nodejs:18 -y &>>$Logfile

Validate $? "enable nodejs"

dnf install nodejs -y &>>$Logfile

Validate $? "install nodejs"

useradd roboshop &>>$Logfile

Validate $? "create user"

mkdir /app &>>$Logfile

Validate $? "creation of directory" 

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$Logfile
 
Validate $? "downloading zip file" 

cd /app  

unzip /tmp/cart.zip &>>$Logfile

Validate $? "unzipping file" 

cd /app 

npm install  &>>$Logfile

Validate $? "installing dependencies" 

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$Logfile

Validate $? "coping cart service file" 

systemctl daemon-reload &>>$Logfile

Validate $? "daemon reload" 

systemctl enable cart  &>>$Logfile

Validate $? "enabling cart" 

systemctl start cart &>>$Logfile

Validate $? "start cart" 