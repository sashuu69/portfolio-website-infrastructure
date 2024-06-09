#!/bin/bash

if [ -z "$1" ]; then
    echo "No argument provided."
    exit 1
fi

if [ "$1" == "apply" ]; then
    arg="apply"
elif [ "$1" == "destroy" ]; then
    arg="destroy"
else
    echo "Invalid argument provided."
    exit 1
fi

docker run \
    -v "$PWD:/build" \
    -w /build \
    --rm docker.io/ubuntu:noble \
    /build/setup.sh $arg
