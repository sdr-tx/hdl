#!/usr/bin/env bash
GIT_DIR=$(git rev-parse --show-toplevel)
docker build -f $GIT_DIR/docker/Dockerfile -t icestorm .
docker run -it --rm \
           -v$PWD:$PWD \
           -v$GIT_DIR:$GIT_DIR \
           -v/dev/:/dev/ \
           -u$(id -u):$(id -g) \
           --privileged \
           -w$PWD \
           icestorm \
           ${@:-/bin/bash}

