#!/bin/bash

set -x

DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 toredash/docker-teamspeak3`

COUNTER=0
while [ $COUNTER -lt 10 ]; do

        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi 
        sleep 5
done
echo "login serveradmin $PASSWORD" | nc 127.0.0.1 10011  | grep "error id=0 msg=ok"


docker stop $DOCKER_ID
docker rm $DOCKER_ID
