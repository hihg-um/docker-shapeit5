# SPDX-License-Identifier: GPL-2.0
ARG BASE_IMAGE
FROM $BASE_IMAGE

ARG HTSLIB_VER=1.18
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt -y update && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
	apt-utils build-essential gcc git g++ make wget \
	libbz2-dev liblzma-dev zlib1g-dev \
	libboost-all-dev libcurl4-openssl-dev libssl-dev

# Compile htslib from the source to avoid issues with Ubuntu package
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VER}/htslib-${HTSLIB_VER}.tar.bz2 && \
	tar -xjf htslib-${HTSLIB_VER}.tar.bz2 && \
	cd htslib-${HTSLIB_VER} && \
	./configure --prefix=/usr/local --disable-libcurl --disable-gcs --disable-s3 && \
	make && \
	make install && \
	cd .. && \
	rm -rf htslib-${HTSLIB_VER} htslib-${HTSLIB_VER}.tar.bz2

WORKDIR /src
RUN git clone --recurse-submodules https://github.com/odelaneau/shapeit5.git
