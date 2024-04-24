FROM ubuntu:22.04

LABEL "com.github.actions.name"="eksctl-runsh-setup-action" \
      "com.github.actions.description"="Execute a shell script where eksctl CLI commands may be invoked one or more times" \
      "com.github.actions.icon"="server" \
      "com.github.actions.color"="blue" \
      "repository"="https://github.com/clicktruck/aws-actions/docker/actions/aws/eksctl-runsh-setup-action" \
      "maintainer"="Chris Phillipson <chris@clicktruck.org>"

RUN apt update && apt install bash ca-certificates curl -y --no-install-recommends \
    && curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin  \
    && rm -rf /var/lib/apt/lists/

# Copies scripts from action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]