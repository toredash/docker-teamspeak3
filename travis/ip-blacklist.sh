#!/bin/bash

set -x

DOCKER_VOLUME=`docker volume create data`
DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 10011:10011 -v data:/ts3/data toredash/docker-teamspeak3`

COUNTER=0
PASSWORD=""

while [ $COUNTER -lt 10 ]; do

        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi 
        sleep 5
done

echo "login serveradmin $PASSWORD" | nc 127.0.0.1 10011  | grep "error id=0 msg=ok"

if [[ $? -ne 0 ]];
  echo "Unable to connect to TS3 instance..."
  exit 1
fi

DOCKER_PATH=`volume docker inspect $DOCKER_VOLUME | grep Mountpoint  | cut -d"\"" -f 4`
echo 127.0.0.1 > $DOCKER_PATH/query_ip_blacklist.txt

docker start $DOCKER_ID

sleep 15

echo "login serveradmin $PASSWORD" | nc 127.0.0.1 10011  | grep "error id=0 msg=ok"

if [[ $? -ne 1 ]];
  echo "ABLE to connect to TS3 instance... This should not work"
  exit 1
fi

exit 0
