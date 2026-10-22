#!/bin/bash

SG_ID="sg-0c479968df80783e0" # replace with your ID
AMI_ID="ami-0055977a6e828a4f4"
#ZONE_ID="Z05013202FKF0ZL12WAOP"
#DOMAIN_NAME="daws88s.online"

for instance_name_tag in $@
do
    INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [ $instance_name_tag == "frontend" ]; then
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
        )
        #RECORD_NAME="$DOMAIN_NAME" # daws88s.online
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        )
        #RECORD_NAME="$instance.$DOMAIN_NAME" # mongodb.daws88s.online
    fi

    echo "IP Address: $IP"