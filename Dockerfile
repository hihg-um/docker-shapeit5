# SPDX-License-Identifier: GPL-2.0
ARG BASE_IMAGE
FROM $BASE_IMAGE

LABEL org.opencontainers.image.title="Shapeit5 base image"
LABEL org.opencontainers.image.description="Shapeit5 from https://github.com/odelaneau/shapeit5"
LABEL org.opencontainers.image.url="https://github.com/hihg-um/docker-shapeit5"
LABEL org.opencontainers.image.version="5.1.1"
LABEL org.opencontainers.image.licences="GPL v2"
LABEL org.opencontainers.image.vendor="The John P. Hussman Institute for Human Genomics at The University of Miami Miller School of Medicine"
LABEL org.opencontainers.image.authors="kms309@med.miami.edu"

ARG HTSLIB_VER=1.18
ARG SHAPEIT_VER=v5.1.1
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt -y update && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
	apt-utils autoconf build-essential ca-certificates gcc git g++ make \
	libbz2-dev liblzma-dev zlib1g-dev \
	libboost-all-dev libcurl4-openssl-dev libssl-dev

WORKDIR /src

# Compile htslib from the source to avoid issues with Ubuntu package
RUN git clone --recurse-submodules --branch ${HTSLIB_VER} --single-branch \
	--depth=1 https://github.com/samtools/htslib.git && cd htslib && \
	autoreconf -i && ./configure --prefix=/usr/local \
		--disable-libcurl --disable-gcs --disable-s3 && \
	make && make install && cd .. && rm -rf htslib

RUN git clone --recurse-submodules --branch ${SHAPEIT_VER} --single-branch \
	--depth=1 https://github.com/odelaneau/shapeit5.git
