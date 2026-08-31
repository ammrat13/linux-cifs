FROM ubuntu:26.04
ARG FULLNAME="Ammar Ratnani"
ARG EMAIL="ammrat13@gmail.com"

RUN apt-get update && \
    # See: https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
    apt-get install -y \
        git \
        build-essential \
        python3 \
        fakeroot \
        debhelper \
        bc \
        gawk \
        rsync \
        zstd \
        kmod \
        libncurses5-dev \
        libssl-dev \
        libdw-dev \
        ccache \
        bison \
        flex \
        libelf-dev \
        dwarves && \
    rm -rf /var/lib/apt/lists/*

ENV DEBFULLNAME=${FULLNAME}
ENV DEBEMAIL=${EMAIL}

WORKDIR /app/
CMD ["/bin/bash"]
