FROM ubuntu:14.04

MAINTAINER Jakub Pavlat jakub_pavlat@cz.ibm.com

RUN apt-get update && \
apt-get install -y curl

##DOWNLOAD##
##or copy from local
# RUN curl -LO http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/10.0.0.10-IIB-LINUX64-DEVELOPER.tar.gz
# RUN curl -LO https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev904_ubuntu_x86-64.tar.gz
 COPY 10.0.0.10-IIB-LINUX64-DEVELOPER.tar.gz .
 COPY mqadv_dev904_ubuntu_x86-64.tar.gz .

RUN mkdir /opt/ibm && mkdir /opt/mqm

##IIB##
RUN tar -xzf 10.0.0.10-IIB-LINUX64-DEVELOPER.tar.gz --directory /opt/ibm
RUN /opt/ibm/iib-10.0.0.10/iib make registry global accept license silently
RUN /opt/ibm/iib-10.0.0.10/iib verify install
RUN useradd --create-home --home-dir /home/iibuser -G mqbrkrs,sudo iibuser

##MQ##
RUN tar -xzf mqadv_dev904_ubuntu_x86-64.tar.gz --directory /opt/mqm
RUN /opt/mqm/DebianMQServer/mqlicense.sh -text_only -accept
#RUN apt install /opt/mqm/DebianMQServer/ibmmq-runtime_9.0.4.0_amd64.deb
#RUN apt install /opt/mqm/DebianMQServer/ibmmq-server_9.0.4.0_amd64.deb
RUN dpkg -i /opt/mqm/DebianMQServer/ibmmq-runtime_9.0.4.0_amd64.deb
RUN dpkg -i /opt/mqm/DebianMQServer/ibmmq-server_9.0.4.0_amd64.deb

#RUN groupadd mqm
RUN useradd --create-home --home-dir /home/mqmuser -G mqm,sudo mqmuser

##Cleanup##
RUN rm -rf 10.0.0.10-IIB-LINUX64-DEVELOPER.tar.gz && rm -rf mqadv_dev904_ubuntu_x86-64.tar.gz

# Expose default admin port and http port
EXPOSE 1414 4414 7800 9443

# Set entrypoint to run management script
COPY iib_manage.sh /home/iibuser/
RUN chmod +x /home/iibuser/iib_manage.sh
ENTRYPOINT ["/home/iibuser/iib_manage.sh"]
