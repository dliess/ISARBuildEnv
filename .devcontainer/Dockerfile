#PREREQ on the Host: sudo apt-get install binfmt-support qemu-user-static

FROM debian:bullseye

ARG BUILD_USER=build-user
ARG host_uid=1001
ARG host_gid=1001
ARG BUILD_USER_PWD=pwd

# Generate and set locale
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen --purge en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
     binfmt-support \
     debootstrap \
     dosfstools \
     dpkg-dev \
     gettext-base \
     git \
     mtools \
     parted \
     python3 \
     quilt \
     qemu \
     qemu-user-static \
     reprepro \
     python3-distutils \
  sudo   && rm -rf /var/lib/apt/lists/*

# Some utils
RUN apt-get update && apt-get install -y \
     ssh \
     vim \
   && rm -rf /var/lib/apt/lists/*

RUN groupadd -g $host_gid $BUILD_USER
RUN useradd -g $host_gid -m -s /bin/bash -u $host_uid $BUILD_USER
RUN echo "$BUILD_USER:$BUILD_USER_PWD" | chpasswd
RUN usermod -aG sudo $BUILD_USER
RUN echo "$BUILD_USER  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "Defaults env_keep += \"ftp_proxy http_proxy https_proxy no_proxy\"" >> /etc/sudoers

ENV HOME=/home/$BUILD_USER
ENV ISAR_DIR=$HOME/Isar
ENV SSH_DIR=$HOME/.ssh
ENV ID_RSA_FILE=$SSH_DIR/id_rsa
ENV ID_RSA_PUB_FILE=$SSH_DIR/id_rsa.pub
ENV KNOWN_HOSTS_FILE=$SSH_DIR/known_hosts

USER $BUILD_USER

RUN mkdir -p $SSH_DIR
RUN mkdir -p $ISAR_DIR

RUN touch $KNOWN_HOSTS_FILE
RUN ssh-keyscan github.com >> $KNOWN_HOSTS_FILE
RUN ssh-keyscan server >> $KNOWN_HOSTS_FILE

