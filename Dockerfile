FROM ubuntu:18.04

# Configure timezone
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Prepare packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg-agent \
    gnupg2 \
    pkg-config \
    software-properties-common \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
# https://docs.docker.com/engine/install/ubuntu/
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
ENV _GO_VERSION 1.14.4
ENV _GO_OS linux
ENV _GO_ARCH amd64
RUN wget https://dl.google.com/go/go$_GO_VERSION.$_GO_OS-$_GO_ARCH.tar.gz \
    && tar -C /usr/local -xzf go$_GO_VERSION.$_GO_OS-$_GO_ARCH.tar.gz \
    && rm -rf go$_GO_VERSION.$GO_OS-$GO_ARCH.tar.gz
ENV PATH "/usr/local/go/bin:$PATH"
ENV GOPATH /go
ENV PATH "$GOPATH/bin:$PATH"

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

# Install Rclone
ENV _RCLONE_VERSION v1.52.2
RUN curl -O https://downloads.rclone.org/$_RCLONE_VERSION/rclone-$_RCLONE_VERSION-linux-amd64.zip \
    && unzip rclone-$_RCLONE_VERSION-linux-amd64.zip \
    && rm rclone-$_RCLONE_VERSION-linux-amd64.zip \
    && mv rclone-$_RCLONE_VERSION-linux-amd64/rclone $GOPATH/bin \
    && rm -rf rclone-$_RCLONE_VERSION-linux-amd64
