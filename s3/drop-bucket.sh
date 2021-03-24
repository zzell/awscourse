#!/bin/bash

# TODO: fix this script

CLI="docker run --rm -it -v ${PWD}/../.aws:/root/.aws amazon/aws-cli"
BUCKET_NAME="awscourse-03-2021"

VERSIONS="$($CLI s3api list-object-versions \
  --bucket $BUCKET_NAME \
  --output=json \
  --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

# TODO: looks like VERSIONS variable contains quoted JSON which cannot be used with delete-objects

echo "${VERSIONS}"

$CLI s3api delete-objects \
  --bucket $BUCKET_NAME \
  --delete "${VERSIONS}"