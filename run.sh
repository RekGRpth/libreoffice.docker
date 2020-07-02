#!/bin/sh -ex

#docker build --tag rekgrpth/libreoffice .
#docker push rekgrpth/libreoffice
#docker pull rekgrpth/libreoffice
docker volume create pgadmin
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop libreoffice || echo $?
docker rm libreoffice || echo $?
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname libreoffice \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=volume,source=pgadmin,destination=/home \
    --name libreoffice \
    --network docker \
    rekgrpth/libreoffice
