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

/usr/bin/expect << EOF 
#If it all goes pear shaped the script will timeout after 5 seconds.
set timeout 5
set password [lindex $argv 0]

#This spawns the telnet program and connects it to the variable name
spawn telnet 127.0.0.1 10011 
#The script expects login
expect "TS3"
expect "Welcome to the TeamSpeak 3 ServerQuery interface, type \"help\" for a list of commands and \"help <command>\" for information on a specific command."
#The script sends the user variable
send "login serveradmin $password"
#The script expects Password
expect "error id=0 msg=ok"
send "exit\r"
expect eof
EOF

echo "login serveradmin $PASSWORD " | nc 127.0.0.1 10011 2>&1 | tee -a /tmp/output | grep "error id=0 msg=ok"


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
