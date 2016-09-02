FROM centos:7
MAINTAINER Tore S. Lønøy <tore.lonoy@gmail.com>
RUN \
useradd ts3 -U -m -s /bin/bash && \
yum install bzip2 /lib/ld-linux.so.2 -y && \
curl -s http://teamspeak.gameserver.gamed.de/ts3/releases/3.0.13.3/teamspeak3-server_linux_x86-3.0.13.3.tar.bz2 | bunzip2 | tar -x -C /home/ts3 

USER ts3
WORKDIR /home/ts3
CMD ['ts3server_startscript.sh', 'start]


