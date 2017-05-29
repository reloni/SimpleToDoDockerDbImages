#!/bin/bash

BACKUP_FOLDER=/backups
mkdir -p $BACKUP_FOLDER

FOLDER=$(date +%Y-%m)
FILEDATE=$(date +%Y-%m-%d-%H:%M)
#pg_dump --clean --dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} 2> /${BACKUP_FOLDER}/$FILEDATE.log | gzip > /${BACKUP_FOLDER}/$FILEDATE.psql.gz
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

#docker run -it --name pgs3 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=test -e POSTGRES_HOST=localhost -e POSTGRES_PORT=5432 -e POSTGRES_DB=postgres  -e BACKUP_FOLDER=/backups -e AWS_DEFAULT_REGION=eu-central-1 -p 5432:5432 db-test
