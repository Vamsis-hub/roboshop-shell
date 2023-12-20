#!/bin/bash


INSTANCES=("MONGODB" "SHIPPING" "MYSQL" "RABBITMQ" "CART" "USER" "CATALOGUE" "PAYMENT" "REDIS" "DISPATCH" "WEB")


for i in "{$INSTANCES[@]}"
do
  if [ $i == "MONGODB" ] || [ $i == "SHIPPING" ] || [ $i == "MYSQL" ]
  then
     INSTANCE_TYPE="t3.small"
  else
     INSTANCE_TYPE="t2.micro"
fi

 IPADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-080a5a1150d6297ba --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

 echo "$i=$IPADDRESS"

done