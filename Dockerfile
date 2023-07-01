ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION
LABEL MAINTAINER=Yinlin.Li<yinlin@seal.io>
RUN apk add bash libc6-compat busybox-extras openssh-client jq bind-tools curl tcpdump iproute2 iperf iftop bash-completion --no-cache \
    && rm -rf /var/cache/* \
    && curl -Lo /usr/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod u+x /usr/bin/kubectl \
    && mkdir ~/.kube \
    && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | VERIFY_CHECKSUM=false bash \
    && echo 'source <(kubectl completion bash)' >>~/.bashrc \
    && echo 'source <(helm completion bash)' >>~/.bashrc \
    && echo 'alias k=kubectl' >>~/.bashrc \
    && echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
COPY ./gotty /usr/bin/
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
