# Use Ubuntu 20.04 LTS as the basis for the Docker image.
FROM ubuntu:20.04

# docker build -t imx6ul:latest .

# Install all Linux packages required for Yocto builds as given in section "Build Host Packages"
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y --purge && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y gawk wget git diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping libsdl1.2-dev xterm && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y autoconf libtool libglib2.0-dev libarchive-dev python-git-doc \
    sed cvs subversion coreutils texi2html docbook-utils python-pysqlite2 \
    help2man make gcc g++ desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev \
    mercurial automake groff curl lzop asciidoc u-boot-tools dos2unix mtd-utils pv \
    libncurses5 libncurses5-dev libncursesw5-dev libelf-dev zlib1g-dev bc rename

RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN git config --global user.name "vult0306"
RUN git config --global user.email "letuanvu91@gmail.com"


ENV USER_NAME geocomply
ENV PROJECT imx6ul
ARG host_uid=1001
ARG host_gid=1001
RUN groupadd -g $host_gid $USER_NAME && \
    useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

USER $USER_NAME
ENV YOCTO_BUILD_DIR /home/$USER_NAME/var-fslc-yocto
RUN mkdir -p $YOCTO_BUILD_DIR

WORKDIR $YOCTO_BUILD_DIR
RUN mkdir ~/bin
RUN curl https://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
RUN chmod a+x ~/bin/repo
RUN ~/bin/repo init -u https://github.com/varigit/variscite-bsp-platform.git -b dunfell && \
    ~/bin/repo sync -j4

# docker run -it repository_name:latest "/bin/bash"
# MACHINE=imx6ul-var-dart DISTRO=fslc-x11 . setup-environment build_x11
# edit config build:
# DL_DIR ?= "/opt/yocto_downloads/"
# exit
# docker ps -a (copy latest container id)
# docker commit container_id repository_name:latest