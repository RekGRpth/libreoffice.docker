FROM rekgrpth/gost
CMD [ "su-exec", "libreoffice", "/usr/lib/libreoffice/program/soffice.bin", "--headless", "--invisible", "--nocrashreport", "--nodefault", "--nofirststartwizard", "--nologo", "--norestore", "--accept=socket,host=0.0.0.0,port=2002,tcpNoDelay=1;urp;StarOffice.ComponentContext" ]
ENV GROUP=libreoffice \
    USER=libreoffice
VOLUME "${HOME}"
RUN exec 2>&1 \
    && set -ex \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache --virtual .libreoffice-rundeps \
        libreoffice \
        ttf-liberation \
    && rm -rf /usr/src /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man \
    && echo Done
