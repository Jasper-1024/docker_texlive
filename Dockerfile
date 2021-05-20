FROM frolvlad/alpine-glibc

LABEL authors "jasperhale <ljy087621@gmail.com>"

# texlive 版本
ENV VERSION="2021"

WORKDIR /tmp

RUN apk update && \
    apk add perl wget xz tar bash && \
    # 运行依赖包
    apk add cairo icu-libs libgcc libpaper libpng libstdc++ libx11 musl pixman poppler zlib && \
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar xfz install-tl-unx.tar.gz && \
    mv install-tl-20* inst && \
    cd inst && \
    # 安装 full texlive
    echo "selected_scheme scheme-full" > profile && \
    ./install-tl -profile profile && \
    cd .. && \
    rm -rf *

# required packages
# RUN apk add cairo icu-libs libgcc libpaper libpng libstdc++ libx11 musl perl pixman poppler zlib bash

ENV PATH /usr/local/texlive/${VERSION}/bin/x86_64-linuxmusl:$PATH
WORKDIR /home

CMD ["/bin/sh"]
