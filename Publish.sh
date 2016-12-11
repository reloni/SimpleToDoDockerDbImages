#!/bin/bash

travistag=$0
user=$1
pass=$2
dbversion=$3

set -ev

echo $travistag

if [ "$travistag" != "" ]; then
docker login -u $user -p $pass
export REPO=reloni/todo-todopostgres
export TAG=empty-$travistag
docker build -f Dockerfile.empty -t $REPO:$TAG --label Postgres=$dbversion .
docker tag $REPO:$TAG $REPO:latest
docker push $REPO
fi

exit 0;
