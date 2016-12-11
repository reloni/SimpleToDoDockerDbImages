#!/bin/bash

travistag=$1
user=$2
pass=$3
dbversion=$4

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
