#!/bin/sh -eux

apk update --no-cache
apk upgrade --no-cache
apk add --no-cache --virtual .build-deps \
    coreutils \
    fontconfig \
    gcc \
    libffi-dev \
    msttcorefonts-installer \
    musl-dev \
    openssl-dev \
    pcre-dev \
    py3-pip \
    python3-dev \
;
update-ms-fonts
fc-cache -f
