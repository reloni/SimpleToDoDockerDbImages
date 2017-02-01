#!/bin/bash

set -ev

if [ "${TRAVIS_TAG}" != "" ]; then
  eval "$(aws ecr get-login --region eu-central-1)" 1> /dev/null
  export REPO=${DOCKER_AWS_REPONAME}
  export TAG=empty-${TRAVIS_TAG}
  docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=${DBVersion} .
  docker tag $REPO:$TAG $REPO:latest
  docker push $REPO > PushLog.log
  cat PushLog.log
fi

exit 0;
