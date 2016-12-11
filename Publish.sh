#!/bin/bash

set -ev

echo "${TRAVIS_TAG}"

if [ "${TRAVIS_TAG}" != "" ]; then
docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
export REPO=reloni/todo-todopostgres
export TAG=empty-${TRAVIS_TAG}
docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=${DBVersion} .
docker tag $REPO:$TAG $REPO:latest
docker push $REPO
fi

exit 0;
