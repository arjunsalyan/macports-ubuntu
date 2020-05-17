FROM ubuntu:18.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
	autotools-dev \
	sqlite \
        libsqlite3-dev \
	openssl \
	libcurl4-openssl-dev \
	curl \
        tcl \
	tcl-dev \
	tcl-doc \
	tclthread \
	tclreadline \
        freebsd-buildutils \
	binutils \
	libc6-dev \
	perl-base \
	rsync \
	libssl-dev \
	tar && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.6.2.tar.bz2
RUN tar xf MacPorts-2.6.2.tar.bz2
RUN cd MacPorts-2.6.2/ && \
	./configure --with-objc-runtime=GNU --with-objc-foundation=GNU && \
	make && \
	make install

FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
	autotools-dev \
	sqlite \
        libsqlite3-dev \
	openssl \
	libcurl4-openssl-dev \
	curl \
        tcl \
	tcl-dev \
	tcl-doc \
	tclthread \
	tclreadline \
        freebsd-buildutils \
	binutils \
	libc6-dev \
	perl-base \
	rsync \
	libssl-dev \
	tar && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/local /opt/local

ENV PATH="/opt/local/bin:$PATH"
