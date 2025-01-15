FROM docker.io/ubuntu:24.04
ARG OSSCAD_VERSION

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y install curl git sudo build-essential locales \
    && apt-get clean

RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

RUN cd /opt && \
    export OSSCAD_VERSION_SHORT=$(echo "${OSSCAD_VERSION}" | sed 's/-//g') && \
    curl --progress-bar -L "https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${OSSCAD_VERSION}/oss-cad-suite-linux-x64-${OSSCAD_VERSION_SHORT}.tgz" -o osscad.tgz && \
    tar -xf osscad.tgz && \
    rm osscad.tgz && \
    echo "${OSSCAD_VERSION}" > /opt/oss-cad-suite/VERSION && \
    echo "source /opt/oss-cad-suite/environment" >> /home/ubuntu/.bashrc