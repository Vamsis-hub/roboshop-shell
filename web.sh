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


dnf install nginx -y &>>$Logfile

Validate $? "install nginx"

systemctl enable nginx &>>$Logfile

Validate $? "enable nginx"

systemctl start nginx &>>$Logfile

Validate $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$Logfile

Validate $? "remove files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$Logfile

Validate $? "downloading nginx files"

cd /usr/share/nginx/html &>>$Logfile

Validate $? "copying file nginx"

unzip /tmp/web.zip &>>$Logfile

Validate $? "unziping"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$Logfile

Validate $? "coping roboshop conf file"

systemctl restart nginx  &>>$Logfile

Validate $? "restart nginx"

