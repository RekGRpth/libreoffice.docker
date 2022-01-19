#!/bin/sh -eux

cd "$HOME"
pip install --no-cache-dir --prefix /usr/local \
    pylokit \
    webob \
;
