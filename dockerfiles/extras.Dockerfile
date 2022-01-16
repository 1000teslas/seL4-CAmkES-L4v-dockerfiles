#
# Copyright 2020, Data61/CSIRO
#
# SPDX-License-Identifier: BSD-2-Clause
#

ARG USER_BASE_IMG=trustworthysystems/sel4
# hadolint ignore=DL3006
FROM $USER_BASE_IMG

# This dockerfile is a shim between the images from Dockerhub and the
# user.dockerfile.
# Add extra dependencies in here!

# For example, uncomment this to get cowsay on top of the sel4/camkes/l4v
# dependencies:

# hadolint ignore=DL3008,DL3009
RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        # Add more dependencies here
        python3.9-venv sudo pandoc musl-tools \
        texlive-latex-extra texlive-fonts-recommended \
        libglib2.0-dev libgcrypt20-dev zlib1g-dev autoconf automake libtool bison flex libpixman-1-dev
RUN wget --content-disposition 'https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz?revision=79f65c42-1a1b-43f2-acb7-a795c8427085&hash=61BBFB526E785D234C5D8718D9BA8E61' \
    && tar xf 'gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz' --strip 1 -C /usr/local
RUN git clone git://github.com/Xilinx/qemu.git && cd qemu \
    && git submodule update --init dtc \
    && mkdir build && cd build \
    && ../configure --target-list="aarch64-softmmu,microblazeel-softmmu" --enable-fdt --disable-kvm --disable-xen --enable-gcrypt \
    && make -j4 && make install && cd ../..
RUN git clone git://github.com/Xilinx/qemu-devicetrees.git && cd qemu-devicetrees && make && cd ..
