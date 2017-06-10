#!/bin/bash

if [ "$LOAD_S3_SECRETS" = "YES" ]; then
  # Load the S3 secrets file contents into the environment variables
  eval $(aws s3 --region ${SECRETS_BUCKET_REGION} cp s3://${SECRETS_BUCKET_NAME}/${SECRETS_FILE_NAME} - | sed 's/^/export /')
fi

BACKUP_FOLDER=/backups
mkdir -p $BACKUP_FOLDER

FOLDER=$(date +%Y-%m)
FILEDATE=$(date +%Y-%m-%d-%H:%M)

pg_dump --clean --dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} > temp.psql 2> /$BACKUP_FOLDER/$FILEDATE.log && \
  gzip < temp.psql > ${BACKUP_FOLDER}/$FILEDATE.psql.gz && \
  aws sns publish --topic-arn ${SNS_TOPIC} --message "Backup on $FILEDATE completed" || \
  aws sns publish --topic-arn ${SNS_TOPIC} --message "Backup on $FILEDATE failed. $(cat /$BACKUP_FOLDER/$FILEDATE.log)"

if [ "$LOAD_S3_SECRETS" = "YES" ]; then
  #upload backups to S3
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.log s3://${BACKUPS_BUCKET_NAME}/$FOLDER/$FILEDATE.log --sse
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.psql.gz s3://${BACKUPS_BUCKET_NAME}/$FOLDER/$FILEDATE.psql.gz --sse

  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.log s3://${BACKUPS_BUCKET_NAME}/latest.log --sse
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.psql.gz s3://${BACKUPS_BUCKET_NAME}/latest.psql.gz --sse

  rm /$BACKUP_FOLDER/$FILEDATE.log
  rm /$BACKUP_FOLDER/$FILEDATE.psql.gz
fi
