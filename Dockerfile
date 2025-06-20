FROM alpine:latest
ADD bin /usr/local/bin
ENTRYPOINT [ "docker_entrypoint.sh" ]
ENV HOME=/home
MAINTAINER RekGRpth
WORKDIR "$HOME"
ARG DOCKER_PYTHON_VERSION=3.12
ENV GROUP=libreoffice \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=libreoffice
RUN set -eux; \
    ln -fs su-exec /sbin/gosu; \
    chmod +x /usr/local/bin/*.sh; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    addgroup -S "$GROUP"; \
    adduser -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"; \
    apk add --no-cache --virtual .build \
        coreutils \
        fontconfig \
        gcc \
        libffi-dev \
        msttcorefonts-installer \
        musl-dev \
        pcre-dev \
        py3-pip \
        python3-dev \
    ; \
    update-ms-fonts; \
    fc-cache -f; \
    cd "$HOME"; \
    pip install --no-cache-dir --prefix /usr/local \
        pylokit \
        webob \
    ; \
    cd /; \
    apk add --no-cache --virtual .libreoffice \
        busybox-extras \
        busybox-suid \
        ca-certificates \
        libreoffice \
        musl-locales \
        py3-six \
        shadow \
        su-exec \
        ttf-dejavu \
        tzdata \
        uwsgi-python3 \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | grep -v -e libcrypto | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
