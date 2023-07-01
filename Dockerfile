ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION
LABEL MAINTAINER=Yinlin.Li<yinlin@seal.io>
RUN apk add bash libc6-compat busybox-extras openssh-client jq bind-tools curl iproute2 iperf iftop terraform ansible \
    && rm -rf /var/cache/* \
    && mkdir -p /etc/ansible \
    && echo "localhost" >/etc/ansible/hosts \
    && ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
COPY ./seal /usr/bin/
COPY ./gotty /usr/bin/
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
