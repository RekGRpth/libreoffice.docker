FROM rekgrpth/gost
ENV GROUP=libreoffice \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/usr/local/lib/python3.8:/usr/local/lib/python3.8/lib-dynload:/usr/local/lib/python3.8/site-packages \
    USER=libreoffice
VOLUME "${HOME}"
RUN set -eux; \
    addgroup -S "${GROUP}"; \
    adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}"; \
    apk add --no-cache --virtual .build-deps \
        gcc \
        libffi-dev \
        msttcorefonts-installer \
        musl-dev \
        openssl-dev \
        pcre-dev \
        py3-pip \
        python3-dev \
    ; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local \
        pylokit \
        uwsgi \
        webob \
    ; \
    apk add --no-cache --virtual .libreoffice-rundeps \
        libreoffice \
        ttf-dejavu \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    update-ms-fonts; \
    fc-cache -f; \
    find /usr/local/bin /usr/local/lib -type f -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    find / -type f -name "*.pyc" -delete; \
    find / -type f -name "*.a" -delete; \
    find / -type f -name "*.la" -delete; \
    rm -rf "${HOME}" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    echo Done
