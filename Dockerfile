FROM golang:alpine as builder
RUN exec 2>&1 \
    && set -ex \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        git \
        musl-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/RekGRpth/unoconv-api \
    && cd /usr/src/unoconv-api \
    && go build \
    && echo Done

FROM rekgrpth/gost
COPY --from=builder /usr/src/unoconv-api/unoconv-api /usr/local/bin/unoconv-api
ADD service /etc/service
ENV GROUP=libreoffice \
    USER=libreoffice
RUN exec 2>&1 \
    && set -ex \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache \
        msttcorefonts-installer \
    && apk add --no-cache --virtual .libreoffice-rundeps \
        libreoffice \
        runit \
        ttf-dejavu \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --virtual .edge-testing-rundeps \
        py3-unoconv \
    && update-ms-fonts \
    && fc-cache -f \
    && apk del --no-cache \
        msttcorefonts-installer \
    && chmod -R 0755 /etc/service /usr/local/bin \
    && rm -rf /usr/src /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man \
    && ln -fs /usr/lib/libreoffice/program/soffice.bin /usr/bin/soffice.bin \
    && echo Done
CMD [ "runsvdir", "/etc/service" ]
VOLUME "${HOME}"
