#!/bin/bash

if [ "$LOAD_S3_SECRETS" = "YES" ]; then
  # Load the S3 secrets file contents into the environment variables
  echo "loading secrets"
  eval $(aws s3 cp s3://${SECRETS_BUCKET_NAME}/${SECRETS_FILE_NAME} - | sed 's/^/export /')
fi

/docker-entrypoint.sh "$@"
