#!/bin/bash

set -x

DOCKER_CMD="docker run --detach -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 toredash/docker-teamspeak3"
DOCKER_ID=`$DOCKER_CMD`
sleep 15 # We need to wait for Teamspeak to start
DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
echo "login serveradmin $PASSWORD" | nc 127.0.0.1 10011  | grep "error id=0 msg=ok"

