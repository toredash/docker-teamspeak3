<img src="https://travis-ci.org/toredash/docker-teamspeak3.svg?branch=master"
             alt="build status">

# docker-teamspeak3

Dockerfile for running Teamspeak server. Support for logging and persistent config volume if needed.

## Bulding docker-teamspeak3

Running this will build a docker image with the latest version of docker-teamspeak, but not TeamSpeak itself. 

    git clone https://github.com/toredash/docker-teamspeak3
    cd docker-teamspeak3
    docker build -t toredash/docker-teamspeak3 .


## I just want a Teamspeak instance, how?

After building the container, you can start it with:

    docker run -d -p 9987:9987/udp toredash/docker-teamspeak3

Connection should be then available via you'r local IP.

## But how do I get access to the Privilege Key ?

Get the id of the container with `docker ps`, and get the logs:

    docker logs --tail=all <container-id> 2>/dev/null | grep token

## How do I stop and start the container ?

Again, get the id of the container with `docker ps`, and issue stop or start:

    docker stop <container-id>
    docker start <container-id>

## I want to use a storage volume to store config data and logs from Teamspeak, how ?

You need to create a storage volume for config and one for logs, but you don't need both.

    docker volume create --name logs
    docker volume create --name data

Then you need to start the container with correct storage mapping.

    docker run -d -p 9987:9987/udp -v logs:/home/ts3/teamspeak3-server_linux_x86/logs -v data:/home/ts3/teamspeak3-server_linux_x86/data toredash/docker-teamspeak3

## Filetransfer in the Teamspeak client doesnt work, what gives?

You need to map port 30033/TCP to enable filetransfer:

    docker run -d -p 9987:9987/udp -p 30033:30033 toredash/docker-teamspeak3

## Serverquery doesnt work, what gives ?

You need to map port 10011/TCP to enable serverquery:

    docker run -d -p 9987:9987/udp -p 10011:10011 toredash/docker-teamspeak3

From then you can telnet (yes, -telnet) to you Teamspeak instance on port 10011.

## I want to enable support for tsdns, how do I do that ?

You need to map port 41144/TCP to enable tsdns:

    docker run -d -p 9987:9987/udp -p 41144:41144 toredash/docker-teamspeak3


