ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION
LABEL MAINTAINER=Yinlin.Li<yinlin@seal.io>
RUN apk add bash libc6-compat busybox-extras openssh-client jq bind-tools curl iproute2 iperf iftop \
    && rm -rf /var/cache/*
COPY ./gotty /usr/bin/
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
