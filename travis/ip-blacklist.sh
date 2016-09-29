#!/bin/bash

set -x

docker volume create --name data
DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 -v logs:/home/ts3/teamspeak3-server_linux_x86/logs toredash/docker-teamspeak3`

COUNTER=0
while [ $COUNTER -lt 10 ]; do

        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi 
        sleep 5
done

LINES_BEFORE=`docker exec $DOCKER_ID ls /home/ts3/teamspeak3-server_linux_x86/logs| wc -l`


docker stop $DOCKER_ID
docker rm $DOCKER_ID

#

DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 30033:30033 -p 10011:10011 -p 41144:41144 -v data:/ts3/data toredash/docker-teamspeak3`

COUNTER=0
while [ $COUNTER -lt 10 ]; do

        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi 
        sleep 5
done

query_ip_blacklist.txt


if [[ $x -gt $y ]]; then
 exit 0
fi

exit 1
