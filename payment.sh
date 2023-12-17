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

dnf install python36 gcc python3-devel -y &>>$Logfile

Validate $? "install python"

useradd roboshop &>>$Logfile 

Validate $? "creating user"

mkdir /app  &>>$Logfile

Validate $? "creating directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$Logfile

Validate $? "downloading payment zip file"

cd /app  

unzip /tmp/payment.zip &>>$Logfile

Validate $? "unzipping"

cd /app 

pip3.6 install -r requirements.txt &>>$Logfile

Validate $? "installing dependencies"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service  &>>$Logfile

Validate $? "coping to payment service"

systemctl daemon-reload &>>$Logfile

Validate $? "daemon"

systemctl enable payment  &>>$Logfile

Validate $? "enabling payment"

systemctl start payment &>>$Logfile

Validate $? "start payment"

