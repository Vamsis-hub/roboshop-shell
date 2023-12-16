#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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
   echo -e "$R Error,please run with root user $N" 
   exit 1
else 
   echo -e "$G I am a root user $N"  
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo 

Validate $? "COPING OF Mongorepo"


