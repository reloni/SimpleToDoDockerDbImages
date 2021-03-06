FROM postgres:9.6.1

# Install the AWS CLI
RUN apt-get update && \
    apt-get -y install python curl unzip && cd /tmp && \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" \
    -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && rm -rf awscli-bundle

COPY ./DBVersion.sql /docker-entrypoint-initdb.d
COPY secrets-entrypoint.sh /secrets-entrypoint.sh
COPY BackupContainer.sh /BackupContainer.sh
RUN chmod +x /BackupContainer.sh

ENTRYPOINT ["/secrets-entrypoint.sh"]
CMD ["postgres"]
