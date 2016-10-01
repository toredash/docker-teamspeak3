#!/bin/bash

set -x

DOCKER_VOLUME=`docker volume create --name data`
DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 10011:10011 -v data:/ts3/data toredash/docker-teamspeak3`

COUNTER=0
PASSWORD=""

while [ $COUNTER -lt 10 ]; do
        sleep 5
        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi  
done

COUNTER=0
while [ $COUNTER -lt 10 ]; do
  echo "login serveradmin $PASSWORD\r" | nc 127.0.0.1 10011 2>&1 | tee -a /tmp/output | grep "error id=0 msg=ok"
  cat /tmp/output
  sleep 5
done

if [[ $? -ne 0 ]]; then
  echo "Unable to connect to TS3 instance..."
  cat /tmp/output
  exit 1
fi

docker stop $DOCKER_ID
docker rm $DOCKER_ID

DOCKER_PATH=`docker volume inspect $DOCKER_VOLUME | grep Mountpoint  | cut -d"\"" -f 4`
echo 127.0.0.1 >> $DOCKER_PATH/query_ip_blacklist.txt
> $DOCKER_PATH/query_ip_whitelist.txt
cat $DOCKER_PATH/query_ip_blacklist.txt

DOCKER_ID=`docker run --detach -p 9987:9987/udp -p 10011:10011 -v data:/ts3/data toredash/docker-teamspeak3`
docker start $DOCKER_ID

COUNTER=0
PASSWORD=""

while [ $COUNTER -lt 10 ]; do
        sleep 5
        DOCKER_LOGS=`docker logs --tail=all $DOCKER_ID 2>&1`
        PASSWORD=`echo $DOCKER_LOGS | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
        let COUNTER=$COUNTER+1
        if [ -z "$PASSWORD" ]; then echo "No password, wait...."; else break; fi 
done

echo "login serveradmin $PASSWORD" | nc 127.0.0.1 10011  | grep "error id=0 msg=ok"

if [[ $? -ne 1 ]]; then
  echo "ABLE to connect to TS3 instance... This should not work"
  exit 1
fi

exit 0
