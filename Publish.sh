#!/bin/bash

set -ev

if [ "${TRAVIS_TAG}" != "" ]; then
  eval $(aws ecr get-login --region eu-central-1)
  export REPO=reloni/todo-postgres
  export TAG=empty-${TRAVIS_TAG}
  docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=${DBVersion} .
  docker tag $REPO:$TAG $REPO:latest
  docker push $REPO
fi

exit 0;
