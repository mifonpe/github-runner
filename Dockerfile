FROM alpine:3.11

ARG GITHUB_RUNNER_VERSION="2.165.2"
ENV HELM_URL=https://storage.googleapis.com/kubernetes-helm
ENV HELM_TAR=helm-v2.4.1-linux-amd64.tar.gz
ENV RUNNER_NAME "runner"
ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR "_work"

USER root

RUN apk update && apk add --no-cache curl sudo git jq openssh libunwind \
    nghttp2-libs libidn krb5-libs libuuid lttng-ust zlib \
    libstdc++ libintl \
    icu 
RUN mkdir /home/github 
RUN adduser github -D -h /home/github  
RUN addgroup github adm
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/github

RUN curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz 
USER github
COPY --chown=github:github entrypoint.sh ./entrypoint.sh
RUN  chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
