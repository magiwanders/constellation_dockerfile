FROM ubuntu:lunar

RUN apt-get update && \
    apt-get install build-essential cmake curl tar git verilator -y 


RUN cd home && \
    curl -L https://github.com/chipsalliance/espresso/archive/refs/tags/v2.4.tar.gz | tar xvz && \
    cd espresso-2.4 && \ 
    mkdir -p build && \
    cd build && \
    cmake ../ -DBUILD_DOC=OFF -DCMAKE_INSTALL_PREFIX=/path/to/install/bin && \
    make install 

RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" && \
    (echo "\n"; echo "yes"; echo "/home/conda"; echo "yes") | bash Mambaforge-$(uname)-$(uname -m).sh
ENV PATH /home/conda/bin:$PATH
SHELL ["bash", "-c"]

RUN source /home/conda/etc/profile.d/conda.sh && conda init bash

RUN source /home/conda/etc/profile.d/conda.sh && \
    conda activate base && \
    conda install -n base conda-lock && \
    cd home && \
    git clone https://github.com/ucb-bar/chipyard.git && \
    cd chipyard && \
    git checkout 1.8.1 && \
    ./build-setup.sh riscv-tools

RUN source /home/conda/etc/profile.d/conda.sh && \
    source /home/chipyard/env.sh && \
    cd /home/chipyard && \
    make -C generators/constellation/src/main/resources/csrc/netrace netrace.o CFLAGS="-fPIC -O3" && \
    cd /home/chipyard/sims/verilator && \
    make SUB_PROJECT=constellation BINARY=none CONFIG=TestConfig00 run-binary-debug 

WORKDIR /home

CMD ["echo", "Alive!"]