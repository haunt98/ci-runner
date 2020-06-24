FROM ubuntu:18.04

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
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://dl.google.com/go/go$GO_VERSION.$GO_OS-$GO_ARCH.tar.gz \
    && tar -C /usr/local -xzf go$GO_VERSION.$GO_OS-$GO_ARCH.tar.gz
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


# Install git
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install enumer
RUN go get -u github.com/alvaroloes/enumer/...

# Install golang-ci lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.27.0

#RUN apt-get update
#RUN apt-get install -y \
#            apt-transport-https \
#            tzdata zip \
#            ca-certificates \
#            curl \
#            software-properties-common \
#            wget pkg-config \
#            git g++ make
#RUN wget https://dl.google.com/go/go1.14.linux-amd64.tar.gz
#RUN tar -C /usr/local -xzf go1.14.linux-amd64.tar.gz
#ENV PATH="/usr/local/go/bin:${PATH}"
#RUN go version
#RUN git clone --single-branch --branch=v1.3.0 https://github.com/edenhill/librdkafka.git --depth=1
#RUN cd ./librdkafka && ./configure --prefix /usr && make && make install
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#RUN add-apt-repository \
#        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#        $(lsb_release -cs) \
#        stable"
#RUN apt-get update
#RUN apt-get -y install docker-ce
#
#WORKDIR /usr/share/zoneinfo
## -0 means no compression.  Needed because go's
## tz loader doesn't handle compressed data.
#RUN zip -r -0 /zoneinfo.zip .
#
#ENV GOPATH /go
#ENV PATH ${GOPATH}/bin:$PATH
#

