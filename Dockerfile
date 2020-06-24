FROM ubuntu:18.04

# Prepare
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
# https://docs.docker.com/engine/install/ubuntu/
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
RUN apt-get update && apt-get install --no-install-recommends -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    && rm -rf /var/lib/apt/lists/*

# Install Go
# https://golang.org/doc/install
ENV GO_VERSION 1.14.4
ENV GO_OS linux
ENV GO_ARCH amd64
RUN wget https://dl.google.com/go/go$GO_VERSION.$GO_OS-$GO_ARCH.tar.gz \
    && tar -C /usr/local -xzf go$GO_VERSION.$GO_OS-$GO_ARCH.tar.gz \
    && rm -rf go$GO_VERSION.$GO_OS-$GO_ARCH.tar.gz
ENV PATH "/usr/local/go/bin:$PATH"
ENV GOPATH /go
ENV PATH "$GOPATH/bin:$PATH"

# Configure timezone
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install librdfkafka
# https://docs.confluent.io/current/installation/installing_cp/deb-ubuntu.html#
RUN wget -qO - https://packages.confluent.io/deb/5.5/archive.key | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/5.5 stable main"
RUN apt-get update && apt-get install --no-install-recommends -y \
    librdkafka-dev \
    && rm -rf /var/lib/apt/lists/*

# Install enumer
RUN go get -u github.com/alvaroloes/enumer/...

# Install golang-ci lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.27.0
