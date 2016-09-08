#!/bin/bash

HOMEDIR=/ts3

set -x

docker volume create --name logs
DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 -v logs:$HOMEDIR/logs toredash/docker-teamspeak3`

COUNTER=0
while [ $COUNTER -lt 10 ]; do

        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi 
        sleep 5
done

LINES_BEFORE=`docker exec $DOCKER_ID ls $HOMEDIR/logs | wc -l`


docker stop $DOCKER_ID
docker rm $DOCKER_ID

#

DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 -v logs:$HOMEDIR/logs toredash/docker-teamspeak3`

COUNTER=0
while [ $COUNTER -lt 10 ]; do

        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi 
        sleep 5
done

LINES_AFTER=`docker exec $DOCKER_ID ls $HOMEDIR/logs | wc -l`
docker stop $DOCKER_ID
docker rm $DOCKER_ID
#

docker volume rm logs

if [[ $LINES_AFTER -gt $LINES_BEFORE ]]; then
 exit 0
fi

exit 1
