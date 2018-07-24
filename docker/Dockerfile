FROM ubuntu:16.04

ENV GOREL=go1.9.3.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
ENV CVER="0.3.2"
ENV CREL="constellation-$CVER-ubuntu1604"

RUN apt-get update &&  apt-get install -y
RUN apt-get install -y software-properties-common wget git psmisc build-essential unzip libdb-dev libleveldb-dev libsodium-dev jq zlib1g-dev libtinfo-dev sysvbanner
RUN apt-get install curl -y && curl -sL https://deb.nodesource.com/setup_8.x | bash && apt-get install nodejs -y

RUN add-apt-repository -y ppa:ethereum/ethereum &&  apt-get update && apt-get install -y solc
RUN wget -q https://github.com/jpmorganchase/constellation/releases/download/v$CVER/$CREL.tar.xz && tar xfJ $CREL.tar.xz
RUN cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node && rm -rf $CREL

RUN wget -q https://storage.googleapis.com/golang/$GOREL && tar xfz $GOREL
RUN mv go /usr/local/go && rm -f $GOREL
RUN mkdir /home/ubuntu/ && echo 'PATH=$PATH:/usr/local/go/bin' >> /home/ubuntu/.bashrc

RUN git clone https://github.com/jpmorganchase/quorum.git
RUN cd quorum && git checkout v2.0.2 && make all && cp build/bin/geth /usr/local/bin && cp build/bin/bootnode /usr/local/bin

RUN wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
RUN mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity

ENTRYPOINT cd node && ./start.sh && /bin/bash