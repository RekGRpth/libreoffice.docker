#!/bin/sh -eux

docker pull ghcr.io/rekgrpth/libreoffice.docker
docker volume create libreoffice
docker network create --attachable --driver overlay docker || echo $?
docker service rm libreoffice || echo $?
docker service create \
    --env GROUP_ID="$(id -g)" \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID="$(id -u)" \
    --hostname="{{.Service.Name}}-{{.Node.Hostname}}" \
    --mode global \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=volume,source=libreoffice,destination=/home \
    --name libreoffice \
    --network name=docker \
    ghcr.io/rekgrpth/libreoffice.docker uwsgi --ini libreoffice.ini
