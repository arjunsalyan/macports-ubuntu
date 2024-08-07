FROM ubuntu:22.04 AS builder

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
	tcllib \
	tcl-dev \
	tcl-doc \
	tclthread \
	tclreadline \
	freebsd-buildutils \
	binutils \
	libc6-dev \
	wget \
	perl-base \
	rsync \
	libssl-dev \
	tar && \
	rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/macports/macports-base/releases/download/v2.9.3/MacPorts-2.9.3.tar.bz2
RUN tar xf MacPorts-2.9.3.tar.bz2
RUN cd MacPorts-2.9.3/ && \
	./configure --with-objc-runtime=GNU --with-objc-foundation=GNU && \
	make && \
	make install

FROM ubuntu:20.04

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
	tcllib \
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
COPY --from=builder /MacPorts-2.9.3 /MacPorts-2.9.3

ARG CONF_PATH=/opt/local/etc/macports/macports.conf
# Write some required defaults.
# Unless, macports-base is modified so that it is able to detect these, 
# we need to hardcode them

# 2 because this image is mostly intended to run on VMs
RUN echo "buildmakejobs 2" >> $CONF_PATH

RUN echo "cxx_stdlib libstdc++" >> $CONF_PATH
RUN echo "build_arch x86_64" >> $CONF_PATH

# add symlink for gnumake
RUN ln -s /usr/bin/make /usr/bin/gnumake

ENV PATH="/opt/local/bin:$PATH"
