FROM centos:7
MAINTAINER Tore S. Lønøy <tore.lonoy@gmail.com>
RUN \
useradd ts3 -U -m -s /bin/bash && \
yum install bzip2 && \
USER ts3

