#!/bin/bash

CLI="docker run --rm -it -v ${PWD}/../.aws:/root/.aws -v ${PWD}/hello.txt:/root/upload/hello.txt amazon/aws-cli"
BUCKET_NAME="awscourse-03-2021"

# create text file
touch hello.txt
echo "Hello s3 world!" > hello.txt

# create s3 bucket
$CLI s3api create-bucket --bucket $BUCKET_NAME --region us-east-1
$CLI s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# upload file into bucket
$CLI s3 cp /root/upload/hello.txt s3://$BUCKET_NAME