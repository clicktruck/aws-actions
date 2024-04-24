FROM ubuntu:22.04

LABEL "com.github.actions.name"="eks-kubeconfig-action" \
      "com.github.actions.description"="Use eksctl CLI to obtain .kube/config then emit contents base 64 encoded" \
      "com.github.actions.icon"="server" \
      "com.github.actions.color"="blue" \
      "repository"="https://github.com/clicktruck/aws-actions/docker/actions/aws/eks-kubeconfig-action" \
      "maintainer"="Chris Phillipson <chris@clicktruck.org>"

RUN apt update && apt install bash ca-certificates curl -y --no-install-recommends \
    && curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin  \
    && rm -rf /var/lib/apt/lists/

# Copies scripts from action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]