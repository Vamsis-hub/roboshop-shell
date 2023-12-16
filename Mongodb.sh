#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIME=$(date +%F-%H-%M-%S)

Logfile="/tmp/$0-$TIME.log"



Vaildate(){
if [ $1 -ne 0 ]
then
    echo "$2 .....$R Failed $N" &>>$Logfile
else 
    echo "$2.....$G Success $N" &>>$Logfile

fi

}

if [ $ID -ne 0 ]
then 
   echo "$R Error,please run with root user $N" &>>$Logfile
   exit 1
else 
   echo "$G I am a root user $N"  &>>$Logfile
fi

cp Mongo.repo /etc/yum.repos.d/mongo.repo &>>$Logfile

Vaildate $? "COPING OF Mongorepo"


