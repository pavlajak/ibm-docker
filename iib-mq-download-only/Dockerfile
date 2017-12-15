FROM ubuntu:16.04

# Install apt-utils
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LO https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev904_ubuntu_x86-64.tar.gz

RUN curl -LO http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/10.0.0.10-IIB-LINUX64-DEVELOPER.tar.gz

ENTRYPOINT ["run-container-loop.sh"]
