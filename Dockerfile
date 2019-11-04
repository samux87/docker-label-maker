FROM tensorflow/tensorflow:1.8.0-py3
LABEL maintainer="Rub21"
ENV workdir /usr/src/app

RUN mkdir $workdir
RUN apt-get update -y
RUN apt-get install -y \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    wget \
    git \
    jq

# Install tippecanoe
RUN git clone --progress https://github.com/mapbox/tippecanoe.git && \
    cd tippecanoe && \
    make -j && \
    make install

# Install label-maker
RUN pip install \
    label-maker==0.3.1 --ignore-installed pycurl

# Install remaining python dependencies
RUN pip install \
    Cython==0.28.2 \
    lxml==4.2.1

# Install Proto
RUN wget https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip -P $workdir
RUN unzip $workdir/protoc-3.2.0-linux-x86_64.zip -d $workdir/protoc3
RUN mv -f $workdir/protoc3/bin/* /usr/local/bin/
RUN mv -f $workdir/protoc3/include/* /usr/local/include/
RUN ln -s -f /usr/local/bin/protoc /usr/bin/protoc

RUN git clone --progress https://github.com/developmentseed/label-maker.git $workdir/label-maker && cd $workdir/label-maker
WORKDIR $workdir
VOLUME $workdir
COPY start.sh $workdir
# CMD ["bash", "start.sh"]
