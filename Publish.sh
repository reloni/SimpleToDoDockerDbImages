#!/bin/bash

set -ev

if [ "${TRAVIS_TAG}" != "" ]; then
  #push to AWS
  aws ecr get-login --region eu-central-1 > login
  eval "$(cat login)"
  export REPO=${DOCKER_AWS_REPONAME}
  export TAG=empty-${TRAVIS_TAG}
  docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=${DBVersion} .
  docker tag $REPO:$TAG $REPO:latest
  docker push $REPO > PushLog.log
  echo "AWS push log ===="
  cat PushLog.log
  echo "======"

  #push to docker-hub
  docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
  export REPO=reloni/todo-postgres
  docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=${DBVersion} .
  docker tag $REPO:$TAG $REPO:latest
  docker push $REPO > PushLog.log
  echo "Docker hub push log ===="
  cat PushLog.log
  echo "======"
fi

exit 0;
