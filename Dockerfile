FROM ubuntu:lunar

RUN apt-get update && \
    apt-get install build-essential cmake git verilator -y 

COPY espresso /home/espresso
COPY conda_install.sh /home
COPY chipyard /home/chipyard

RUN (echo "\n"; echo "yes"; echo "/home/conda"; echo "yes") | bash /home/conda_install.sh
ENV PATH /home/conda/bin:$PATH
SHELL ["bash", "-c"]

RUN source /home/conda/etc/profile.d/conda.sh && conda init bash

RUN source /home/conda/etc/profile.d/conda.sh && \
    conda activate base && \
    conda install -n base conda-lock && \
    cd /home/espresso  && \
    mkdir -p build  && \
    cd build  && \
    cmake ../ -DBUILD_DOC=OFF -DCMAKE_INSTALL_PREFIX=/usr/bin  && \
    make install && \
    cd /home/chipyard && \
    ./build-setup.sh riscv-tools && \
    source /home/chipyard/env.sh && \
    cd /home/chipyard && \
    make -C generators/constellation/src/main/resources/csrc/netrace netrace.o CFLAGS="-fPIC -O3" && \
    cd /home/chipyard/sims/verilator && \
    make SUB_PROJECT=constellation BINARY=none CONFIG=TestConfig00 run-binary-debug 

WORKDIR /home

CMD ["echo", "Alive!"]