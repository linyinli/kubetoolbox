FROM alpine:3.14
LABEL MAINTAINER=Yinlin.Li<Yinlin.Li@suse.com>
COPY ./gotty /usr/bin/
COPY ./support/describe-all-nodes-for-all-clusters.sh /
RUN apk add bash libc6-compat busybox-extras openssh-client jq bind-tools curl tcpdump iproute2 iperf iftop --no-cache \
    && rm -rf /var/cache/* \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.8/bin/linux/amd64/kubectl \
    && curl -fL "https://liyinlin-generic.pkg.coding.net/rancher/support/getNodeinfo_linux_amd64?version=latest" -o getNodeinfo_linux_amd64 \
    && chmod u+x kubectl describe-all-nodes-for-all-clusters.sh getNodeinfo_linux_amd64 \
    && mv kubectl /usr/bin/ \
    && mkdir ~/.kube
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
