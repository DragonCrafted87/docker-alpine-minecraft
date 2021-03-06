FROM dragoncrafted87/alpine:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="DragonCrafted87 Alpine Minecraft" \
      org.label-schema.description="Alpine Image with OpenJDK to run a minecraft server." \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/DragonCrafted87/docker-alpine-minecraft" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

COPY root/. /

RUN apk add --no-cache --update \
    git \
    tini \
    && \
    apk add --no-cache --update openjdk16-jre-headless --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    && \
    pip3 --no-cache-dir install \
    dirsync \
    mcrcon \
    xmltodict \
    && \
    rm  -rf /tmp/* /var/cache/apk/* && \
    chmod +x -R /scripts/*
