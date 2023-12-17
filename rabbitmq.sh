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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$Logfile

Validate $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$Logfile

Validate $? "Downloading rabbitmq script"


dnf install rabbitmq-server -y  &>>$Logfile

Validate $? "Installing RabbitMQ server"

systemctl enable rabbitmq-server  &>>$Logfile

Validate $? "enabling RabbitMQ server"

systemctl start rabbitmq-server  &>>$Logfile

Validate $? "starting RabbitMQ server"

rabbitmqctl add_user roboshop roboshop123 &>>$Logfile

Validate $? "adding user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Logfile

Validate $? "setting permissions"

