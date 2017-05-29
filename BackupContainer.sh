#!/bin/bash

set -e

FOLDER=$(date +%Y-%m)
FILEDATE=$(date +%Y-%m-%d-%H:%M)
pg_dump --clean --dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} 2> /${BACKUP_FOLDER}/$FILEDATE.log | gzip > /${BACKUP_FOLDER}/$FILEDATE.psql.gz

if [ "$LOAD_S3_SECRETS" = "YES" ]; then
  #upload backups to S3
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /${BACKUP_FOLDER}/$FILEDATE.log s3://${BACKUPS_BUCKET_NAME}/$FOLDER/$FILEDATE.log
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /${BACKUP_FOLDER}/$FILEDATE.psql.gz s3://${BACKUPS_BUCKET_NAME}/$FOLDER/$FILEDATE.psql.gz

  aws s3 --region ${SECRETS_BUCKET_REGION} cp /${BACKUP_FOLDER}/$FILEDATE.log s3://${BACKUPS_BUCKET_NAME}/latest.log
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /${BACKUP_FOLDER}/$FILEDATE.psql.gz s3://${BACKUPS_BUCKET_NAME}/latest.psql.gz

  rm /${BACKUP_FOLDER}/$FILEDATE.log
  rm /${BACKUP_FOLDER}/$FILEDATE.psql.gz
fi

#docker run -it --name pgs3 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=test -e POSTGRES_HOST=localhost -e POSTGRES_PORT=5432 -e POSTGRES_DB=postgres -e BACKUP_FOLDER=/backups -p 5432:5432 db-test
