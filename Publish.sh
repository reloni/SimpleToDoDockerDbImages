#!/bin/bash

set -ev

echo "${TRAVIS_TAG}"

if [ "${TRAVIS_TAG}" != "" ]; then
docker login -u ${DOCKER_AWS_USER} -p ${DOCKER_AWS_PASS} -e none ${DOCKER_AWS_URL}
export REPO=${DOCKER_AWS_REPONAME}
export TAG=empty-${TRAVIS_TAG}
docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=${DBVersion} .
docker tag $REPO:$TAG $REPO:latest
docker push $REPO
fi

exit 0;
