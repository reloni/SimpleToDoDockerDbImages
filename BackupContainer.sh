#!/bin/bash

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
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.log s3://${BACKUPS_BUCKET_NAME}/$FOLDER/$FILEDATE.log
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.psql.gz s3://${BACKUPS_BUCKET_NAME}/$FOLDER/$FILEDATE.psql.gz

  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.log s3://${BACKUPS_BUCKET_NAME}/latest.log
  aws s3 --region ${SECRETS_BUCKET_REGION} cp /$BACKUP_FOLDER/$FILEDATE.psql.gz s3://${BACKUPS_BUCKET_NAME}/latest.psql.gz

  rm /$BACKUP_FOLDER/$FILEDATE.log
  rm /$BACKUP_FOLDER/$FILEDATE.psql.gz
fi
