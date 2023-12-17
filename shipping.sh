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

dnf install maven -y &>>$Logfile

Validate $? "Maven install" 

useradd roboshop &>>$Logfile

Validate $? "user creation" 

mkdir /app &>>$Logfile

Validate $? "directory creation" 

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$Logfile

Validate $? "downloadinf zip file" 

cd /app

unzip /tmp/shipping.zip &>>$Logfile

Validate $? "unzipping file" 

cd /app

mvn clean package  &>>$Logfile

Validate $? "installting dependencies" 

mv target/shipping-1.0.jar shipping.jar &>>$Logfile

Validate $? "rename" 

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$Logfile

Validate $? "coping to shipping.service" 

systemctl daemon-reload &>>$Logfile

Validate $? "daemon reload" 

systemctl enable shipping  &>>$Logfile

Validate $? "enabling shipping" 

systemctl start shipping &>>$Logfile

Validate $? "starting shipping" 

dnf install mysql -y &>>$Logfile

Validate $? "installing mysql client" 

mysql -h mysql.saanvi.website -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$Logfile

Validate $? "reload data to mysql" 

systemctl restart shipping &>>$Logfile

Validate $? "restart shipping" 

