#!/bin/bash

set -ev

if [ "${TRAVIS_TAG}" != "" ]; then
docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
export REPO=reloni/todo-postgres
export TAG=empty-${TRAVIS_TAG}
docker build -f Dockerfile.empty -t base --label Postgres=${DBVersion} .
docker run -d --name firstrun -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} base
docker commit firstrun $REPO:$TAG
docker stop firstrun
docker tag $REPO:$TAG $REPO:latest
docker push $REPO
fi

exit 0;
