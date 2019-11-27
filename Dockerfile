FROM ubuntu:18.04

# SnapTools commit for v1.2.3
ARG SNAPTOOLS_COMMIT=96d6f9539b77cd38101196b0adacce742c884974

RUN apt-get update && apt-get install -y \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    python-pip \
    python \
    python3 \
    wget \
    curl \
    unzip \
    htop \
    vim \
    zlib1g \
    zlib1g-dev

LABEL maintainer="jshands@ucsc.edu"

WORKDIR install

# Install SnapTools https://github.com/r3fang/SnapTools
# wget the Git repository by commit since this will create a smaller image than
# git clone because it does not include the .git dir
RUN wget -O SnapTools.zip https://github.com/r3fang/SnapTools/archive/$SNAPTOOLS_COMMIT.zip && \
    unzip SnapTools.zip && \
    mkdir SnapTools && \
    mv SnapTools-$SNAPTOOLS_COMMIT/* SnapTools/ && \
    rm -rf SnapTools-$SNAPTOOLS_COMMIT
WORKDIR SnapTools
RUN pip install -e .

RUN pip install html5lib

WORKDIR /opt/samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 -O samtools.tar.bz2 && \
    tar -xjvf samtools.tar.bz2 && \
    cd samtools-1.9 && \
    ./configure --prefix /opt/samtools/samtools-1.9 && \
    make && \
    make install
ENV PATH /opt/samtools/samtools-1.9/bin:$PATH

# Install BWA
RUN cd /install && \
    wget -O "bwa-0.7.17.tar.bz2" "https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2/download" && \
    tar xvjf bwa-0.7.17.tar.bz2 && \
    cd bwa-0.7.17 && \
    make && \
    mkdir /tools/ && \
    cp bwa /tools/

COPY create_genome_size_file.sh /tools/
COPY create_reference_genome_index.sh /tools/

ENV PATH /tools/:$PATH
