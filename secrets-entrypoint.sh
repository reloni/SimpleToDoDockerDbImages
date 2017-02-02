#!/bin/bash

eval "$(echo POSTGRES_PASSWORD=supersecretpass | sed 's/^/export /')"

# Load the S3 secrets file contents into the environment variables
#eval $(aws s3 cp s3://${SECRETS_BUCKET_NAME}/db_credentials.txt - | sed 's/^/export /')

/docker-entrypoint.sh "$@"
