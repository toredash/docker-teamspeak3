#!/bin/bash

set -x

DOCKER_ID=`docker ps --filter name=ts3_data | tail -n +2 | awk '{print $1}'`
LOG_LINE=`docker logs $DOCKER_ID 2>/dev/null | tail -n 1`
docker stop $DOCKER_ID
docker start $DOCKER_ID
LOG_LINE_DIFF=`docker logs $DOCKER_ID 2>/dev/null | tail -n 1`

