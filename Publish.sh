#!/bin/bash

set -ev

echo "${TRAVIS_TAG}"

if [ "${TRAVIS_TAG}" != "" ]; then
docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
export REPO=reloni/todo-postgres
export TAG=empty-${TRAVIS_TAG}
docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=${DBVersion} .
docker tag $REPO:$TAG $REPO:latest
docker run -d --name firstrun -e POSTGRES_PASSWORD=pass1 $REPO:$TAG
docker stop firstrun
docker commit firstrun
docker push $REPO
fi

exit 0;
