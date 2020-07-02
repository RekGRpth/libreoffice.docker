FROM rekgrpth/gost
ENV GROUP=libreoffice \
    USER=libreoffice
RUN exec 2>&1 \
    && set -ex \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache --virtual .libreoffice-rundeps \
        libreoffice \
#        openjdk11-jdk \
#        ttf-liberation \
        ttf-dejavu \
    && rm -rf /usr/src /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man \
    && ln -fs /usr/lib/libreoffice/program/soffice.bin /usr/bin/soffice.bin \
    && echo Done
CMD [ "su-exec", "libreoffice", "soffice", "--headless", "--invisible", "--nocrashreport", "--nodefault", "--nofirststartwizard", "--nologo", "--norestore", "--accept=socket,host=0.0.0.0,port=2002;urp;" ]
VOLUME "${HOME}"
