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
    echo "I am a root user"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$Logfile

Validate $? "installation of remorepo"

dnf module enable redis:remi-6.2 -y &>>$Logfile

Validate $? "enabling redis"

dnf install redis -y &>>$Logfile

Validate $? "insatalling redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$Logfile

Validate $? "allowing remote access" 

systemctl enable redis &>>$Logfile

Validate $? "enabling redis" 

systemctl start redis &>>$Logfile

Validate $? "start redis"