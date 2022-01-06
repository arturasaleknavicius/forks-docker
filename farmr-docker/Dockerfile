FROM ubuntu:latest

ENV crypto="xeth"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tar bash ca-certificates git wget python3-pip sudo acl build-essential python3-dev tzdata

# Farmr
RUN wget https://github.com/gilnobrega/farmr/releases/download/v1.7.7.4/farmr-linux-x86_64.tar.gz && mkdir /farmr && tar xf farmr-linux-x86_64.tar.gz -C /farmr/ && rm farmr-linux-x86_64.tar.gz

RUN dpkg-reconfigure -f noninteractive tzdata

WORKDIR /farmr
ADD ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
