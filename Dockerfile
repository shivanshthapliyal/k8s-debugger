FROM alpine
ARG VCS_REF
ARG BUILD_DATE

MAINTAINER github.com/shivanshthapliyal

ENV KUBE_LATEST_VERSION="v1.23.4"

RUN apk add --update ca-certificates \
 && apk add -t deps \
 && apk add --update curl \
 && export ARCH="$(uname -m)" && if [[ ${ARCH} == "x86_64" ]]; then export ARCH="amd64"; elif [[ ${ARCH} == "aarch64" ]]; then export ARCH="arm64"; fi && curl -L https://dl.k8s.io/release/${KUBE_LATEST_VERSION}/bin/linux/${ARCH}/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

RUN   apk update \
            && apk upgrade \
            && apk add -v --update \
            bash bash-completion \
            coreutils \
            curl \
            httpie \
            htop iftop \
            jq \
            less \
            mysql-client \
            openldap-clients \
            openssl \
            redis \
            screen \
            python3 \
            unzip \
            vim vimdiff \
            busybox-extras \
            && apk add -v --update -t deps py-pip \
            && pip install --upgrade awscliv2 \
            && apk del --purge deps \
            && rm -rf /var/cache/apk/* \
            && rm -f /usr/local/bin/*.zip \
            && echo '\
                  . /etc/profile ; \
                  eval `dircolors -b` ; \
                  alias ls="ls --color=auto" ; \
                  alias ll="ls -la" ; \
                  alias screendr="/usr/bin/screen -DR"; \
                  alias vi="/usr/bin/vim"; \
                  alias vimdiff="/usr/bin/vimdiff -O "; \
                  function k () { \
                  kubectl $@ ; \
                  } ; \
                  export -f k ; \
                  source <(kubectl completion bash) ; \
                  # add completion ; \
                  complete -o default -F __start_kubectl k ; \
                  complete -o default -F __start_kubectl kub ; \
                  ' >> /etc/bash.bashrc \
            && echo '. ~/.bashrc' > /root/.bash_profile \
            && echo '. /etc/bash.bashrc' > /root/.bashrc

WORKDIR /root
# ENTRYPOINT ["kubectl"]
CMD ["/bin/bash", "-l"]
