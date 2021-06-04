FROM alpine:3.13
LABEL MAINTAINER=Yinlin.Li<Yinlin.Li@suse.com>
RUN apk add libc6-compat busybox-extras openssh-client jq bind-tools curl tcpdump iproute2 iperf iftop --no-cache \
    && rm -rf /var/cache/*
COPY ./gotty /usr/bin/
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
