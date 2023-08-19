FROM ubuntu:22.04

COPY SOLISP_* EDITLINE_VERSION /tmp/
RUN apt-get update && \
    apt-get install -y git make gcc g++-11 autoconf libtool && \
    ln -s /usr/bin/g++-11 /usr/bin/g++ && \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/troglobit/editline.git -b $(cat /tmp/EDITLINE_VERSION) && \
    cd /opt/editline && \
    ./autogen.sh && \
    ./configure && \
    make all && \
    make install && \
    cd /opt && \
    git clone https://github.com/stuin/Solisp.git && \
    cd Solisp && \
    git reset --hard $(cat /tmp/SOLISP_COMMIT_HASH) && \
    make LDFLAGS=-leditline && \
    make install && \
    rm -rf /opt/editline /opt/Solisp && \
    apt-get remove -y git make gcc g++-11 autoconf libtool && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
