FROM centos:7
MAINTAINER Tore S. Lønøy <tore.lonoy@gmail.com>
RUN \
useradd ts3 -U -m -s /bin/bash && \
yum install bzip2 /lib/ld-linux.so.2 -y && \
curl -s http://teamspeak.gameserver.gamed.de/ts3/releases/3.0.13.3/teamspeak3-server_linux_x86-3.0.13.3.tar.bz2 | bunzip2 | tar -x -C /home/ts3 && \
mkdir /home/ts3/teamspeak3-server_linux_x86/data && \ 
ln -s /home/ts3/teamspeak3-server_linux_x86/data/logs /home/ts3/teamspeak3-server_linux_x86/logs && \
ln -s /home/ts3/teamspeak3-server_linux_x86/data/query_ip_blacklist.txt /home/ts3/teamspeak3-server_linux_x86/query_ip_blacklist.txt && \
ln -s /home/ts3/teamspeak3-server_linux_x86/data/query_ip_whitelist.txt /home/ts3/teamspeak3-server_linux_x86/query_ip_whitelist.txt && \
ln -s /home/ts3/teamspeak3-server_linux_x86/data/ts3server.sqlitedb /home/ts3/teamspeak3-server_linux_x86/ts3server.sqlitedb && \
chown -R ts3:ts3 /home/ts3/teamspeak3-server_linux_x86/data
USER ts3
WORKDIR /home/ts3/teamspeak3-server_linux_x86
CMD ['./ts3server_startscript.sh', 'start']


