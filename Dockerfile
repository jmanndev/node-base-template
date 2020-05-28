FROM node:10.16

WORKDIR /app

RUN npm install npm -g 

RUN npm install nodemon webpack -g

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y libaio1 \
  && apt-get install -y rlwrap alien libaio1 \
  && apt-get install -y procps \
  && apt-get install -y build-essential \
  && apt-get install -y curl \
  && apt-get install -y vim \
  && apt-get install -y unzip \
  && apt-get install -y screen \
  && apt-get install -y sudo

#ADD ORACLE INSTANT CLIENT
RUN mkdir -p /opt/oracle
ADD ./oracle/linux/ /opt/oracle/
RUN cd /opt/oracle/ && unzip instantclient-basic-linux.x64-12.1.0.2.0.zip \
  && unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip \
  && unzip instantclient-sqlplus-linux.x64-12.1.0.2.0.zip

RUN mv /opt/oracle/instantclient_12_1 /opt/oracle/instantclient

RUN ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so
RUN ln -s /opt/oracle/instantclient/libocci.so.12.1 /opt/oracle/instantclient/libocci.so

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV OCI_HOME="/opt/oracle/instantclient"
ENV OCI_LIB_DIR="/opt/oracle/instantclient"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient/sdk/include"
ENV PATH=$OCI_HOME:$PATH

RUN echo '/opt/oracle/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig

EXPOSE 80

COPY ./app/database-connector/package.json /app/database-connector/package.json
RUN cd ./database-connector && npm i --package-lock-only && npm audit fix --force
RUN cd ./database-connector && npm update
RUN cd ./database-connector && npm install

COPY ./app/. /app

RUN sed -i 's/\r$//' ./start.sh  && \  
        chmod +x ./start.sh

RUN pwd

RUN ls

#docker run --name database-connector --volume /home/jonathan/code/microservices/database_connector/app/database-connector:/app/database-connector -p 3144: 80 -it database-connector
ENTRYPOINT [ "./start.sh" ]
