ARG IMAGE=intersystemsdc/irishealth-community:2020.3.0.200.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.3.0.221.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.524.0-zpm
ARG IMAGE=intersystemsdc/iris-ml-community:2020.3.0.302.0-zpm
FROM $IMAGE

USER root   
        
WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
RUN \
  apt-get update && \
  apt-get -y install nano

RUN apt install python3 -y

# Make python available in cmd
RUN export PATH=${PATH}:/usr/bin/python3
RUN /bin/bash -c "source ~/.bashrc"


USER ${ISC_PACKAGE_MGRUSER}

#COPY  Installer.cls .
COPY  in in
COPY  py py
COPY  src src
COPY module.xml module.xml
COPY iris.script /tmp/iris.script

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
