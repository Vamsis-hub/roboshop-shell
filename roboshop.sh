#!/bin/bash

INSTANCES=("MONGODB" "REDIS" "MYSQL" "RABBITMQ" "CART" "USER" "CATALOGUE" "PAYMENT" "SHIPPING" "DISPATCH" "WEB")


for i in "${INSTANCES[@]}"
do
    if [ $i == "MONGODB" ] || [ $i == "SHIPPING" ] || [ $i == "MYSQL" ]
    then
         INSTANCE_TYPE="t3.small"
    else
         INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-080a5a1150d6297ba

done

