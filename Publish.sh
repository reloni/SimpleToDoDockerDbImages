#!/bin/bash

set -e

if [ "${TRAVIS_TAG}" != "" ]; then
  if [ "${TRAVIS_BRANCH}" = "master" ]; then
    export SUBTAG=release
  else
    export SUBTAG=develop
  fi

  export REPO=${DOCKER_AWS_REPONAME}
  export TAG=${TRAVIS_TAG}-${DBVersion}-$SUBTAG

  #push to AWS
  aws ecr get-login --region eu-central-1 > login
  eval "$(cat login)"
  docker build -f Dockerfile -t $REPO:$TAG --label Postgres=${DBVersion} .
  if [ "${TRAVIS_BRANCH}" = "master" ]; then
    docker tag $REPO:$TAG $REPO:latest
  fi
  docker push $REPO > PushLog.log
  echo "AWS push log ===="
  cat PushLog.log
  echo "======"

  #push to docker-hub
  docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
  export REPO=reloni/todo-postgres
  docker build -f Dockerfile -t $REPO:$TAG --label Postgres=${DBVersion} .
  if [ "${TRAVIS_BRANCH}" = "master" ]; then
    docker tag $REPO:$TAG $REPO:latest
  fi
  docker push $REPO > PushLog.log
  echo "Docker hub push log ===="
  cat PushLog.log
  echo "======"
fi

exit 0;
