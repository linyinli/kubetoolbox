FROM alpine:3.17
LABEL MAINTAINER=Yinlin.Li<Yinlin.Li@suse.com>
RUN apk add libc6-compat busybox-extras openssh-client jq bind-tools curl tcpdump iproute2 iperf iftop --no-cache \
    && rm -rf /var/cache/* \
    && STABLE_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$STABLE_VERSION/bin/linux/amd64/kubectl \
    && chmod u+x kubectl \
    && mv kubectl /usr/bin/ \
    && mkdir ~/.kube
COPY ./gotty /usr/bin/
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
