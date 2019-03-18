FROM python:3.6.7-alpine3.8

LABEL maintainer=ilpan:<pna.dev@outlook.com>

COPY ./requirements.txt /tmp/requirements.txt

ENV PY_VERSION=3.6
ENV SITE_PACKAGES=/usr/local/lib/python${PY_VERSION}/site-packages

# add build deps
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        libffi-dev \
        libressl-dev \
        libxml2-dev \
        libxslt-dev

# install requirements
RUN pip install -U pip \
        && pip install -r /tmp/requirements.txt \
        && rm /tmp/requirements.txt \
        && rm -r ${SITE_PACKAGES}/*.dist-info
 
# RUN apk del .build-deps

WORKDIR /scrapyd
COPY ./scrapyd.conf /etc/scrapyd/
COPY ./docker-entrypoint.sh .

EXPOSE 6800

ENTRYPOINT ["./docker-entrypoint.sh"]
