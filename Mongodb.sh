#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


TIME=$(date +%F-%H-%M-%S)

Logfile="/tmp/$0-$TIME.log"

Validate(){
if [ $1 -ne 0 ]
then
    echo -e "$2 .....$R Failed $N"  
    exit 1
else 
    echo -e "$2.....$G Success $N"  

fi

}

if [ $ID -ne 0 ]
then 
   echo -e "$R Error,please run with root user $N"  &>>$Logfile
   exit 1
else 
   echo -e "$G I am a root user $N"  &>>$Logfile
fi

cp Mongo.repo /etc/yum.repos.d/mongo.repo  &>>$Logfile

Validate $? "COPING OF Mongorepo"

dnf install mongodb-org -y  &>>$Logfile

Validate $? "installation of mongodb"

systemctl enable mongod &>>$Logfile

Validate $? "enabling of mongodb"

systemctl start mongod &>>$Logfile

Validate $? "starting of mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$Logfile

Validate $? "enabling remote access"

systemctl restart mongod &>>$Logfile

Validate $? "restart of mongodb"




