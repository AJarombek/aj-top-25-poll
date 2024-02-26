#!/bin/bash

# Directory containing the files to upload
DIRECTORY_TO_UPLOAD=$1
BUCKET_NAME="poll.jarombek.io"

# Ensure directory is specified
if [[ -z "$DIRECTORY_TO_UPLOAD" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Recursively upload files to S3
aws s3 cp "$DIRECTORY_TO_UPLOAD" s3://"$BUCKET_NAME" --recursive

echo "Upload complete."
