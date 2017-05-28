#!/bin/bash

set -e

pg_dump --clean --dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} 2> /${BACKUP_FOLDER}/$(date +%Y-%m-%d-%H:%M).log | gzip > /${BACKUP_FOLDER}/$(date +%Y-%m-%d-%H:%M).psql.gz

if [ "$LOAD_S3_SECRETS" = "YES" ]; then
  echo "upload to S3"
  # Load the S3 secrets file contents into the environment variables
  #eval $(aws s3 --region ${SECRETS_BUCKET_REGION} cp s3://${SECRETS_BUCKET_NAME}/${SECRETS_FILE_NAME} - | sed 's/^/export /')
fi

#docker run -it --name pgs3 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=test -e POSTGRES_HOST=localhost -e POSTGRES_PORT=5432 -e POSTGRES_DB=postgres -e BACKUP_FOLDER=/backups -p 5432:5432 db-test
