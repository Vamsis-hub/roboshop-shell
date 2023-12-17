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

dnf module disable mysql -y &>>$Logfile

Validate $? "disabling MYSQL" 

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$Logfile

Validate $? "coping MYSQL repo" 

dnf install mysql-community-server -y &>>$Logfile

Validate $? "install MYSQL" 

systemctl enable mysqld &>>$Logfile

Validate $? "enabling MYSQL" 

systemctl start mysqld &>>$Logfile

Validate $? "starting MYSQL" 

mysql_secure_installation --set-root-pass RoboShop@1 &>>$Logfile

Validate $? "setting Mysql root password" 