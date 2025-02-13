FROM ubuntu:24.04

RUN apt-get update && apt-get install -yq \
    git \
    git-lfs \
    sudo \
    curl && \
    curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh | bash - && \
    apt-get install -y nodejs npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* && \
    npm add --global nx@latest && \
    useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

USER gitpod

SHELL ["bash", "-lic"]
