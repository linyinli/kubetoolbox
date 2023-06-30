FROM alpine:3.18
LABEL MAINTAINER=Yinlin.Li<yinlin@seal.io>
COPY ./gotty /usr/bin/
RUN apk add bash libc6-compat busybox-extras openssh-client jq bind-tools curl iproute2 \
    && rm -rf /var/cache/* \
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
