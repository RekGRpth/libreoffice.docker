#!/bin/sh -eux

docker pull ghcr.io/rekgrpth/libreoffice.docker
docker volume create libreoffice
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop libreoffice || echo $?
docker rm libreoffice || echo $?
docker run \
    --detach \
    --env GROUP_ID="$(id -g)" \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID="$(id -u)" \
    --hostname libreoffice \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=volume,source=libreoffice,destination=/home \
    --name libreoffice \
    --network name=docker \
    --restart always \
    ghcr.io/rekgrpth/libreoffice.docker uwsgi --ini libreoffice.ini
