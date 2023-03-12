FROM alpine:3.17
LABEL MAINTAINER=Yinlin.Li<Yinlin.Li@suse.com>
COPY ./gotty /usr/bin/
RUN apk add bash libc6-compat busybox-extras openssh-client jq bind-tools curl iproute2 ansible \
    && rm -rf /var/cache/* \
    && STABLE_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$STABLE_VERSION/bin/linux/amd64/kubectl \
    && mv kubectl /usr/bin/ \
    && mkdir ~/.kube \
    && mkdir -p /etc/ansible \
    && echo "localhost" >/etc/ansible/hosts \
    && ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
EXPOSE 80
ENTRYPOINT ["gotty","-p","80","-w","sh"]
