#!/bin/bash

#Downloading PEM Key from S3
aws s3 cp s3://${S3_BUCKET}/${PEM_KEY} /home/ec2-user/${PEM_KEY}

#changing permission of pem key
chmod 400 /home/ec2-user/${PEM_KEY}