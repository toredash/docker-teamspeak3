#!/bin/bash

DOCKER_ID=`docker ps | tail -n +2 | 'awk {print $1}'`
PASSWORD=`docker logs --tail=all $DOCKER_ID 2>&1 | egrep "password= \".*\"" -o | tr -d \" | cut -d " " -f2`
echo "login serveradmin $PASSWORD" | nc 146.185.152.134 10011  | grep "error id=0 msg=ok"

