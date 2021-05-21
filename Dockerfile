FROM debian:10

LABEL authors "jasperhale <ljy087621@gmail.com>"

ENV VERSION=2021

RUN apt-get update && \
  apt-get -y install wget unzip curl ca-certificates git make\
  # perl 依赖
  perl perl-modules \
  # python & 语法高亮
  python3 python3-pygments

RUN wget --no-verbose \
  "https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz" && \
  tar -xzf install-tl-unx.tar.gz && \
  # 进入texlive
  cd $(find . -type d -name "install-tl-*" | head -n 1) && \
  # 默认安装全部
  echo "selected_scheme scheme-full" > profile && \
  # 安装
  ./install-tl -profile profile && \
  cd .. &&\
  rm -rf install-tl-*

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
      # to fix "error while loading shared libraries: libfontconfig.so.1"
      libfontconfig \
      # YAML::Tiny:
      libyaml-tiny-perl \
      # File::HomeDir:
      libfile-homedir-perl \
      # Unicode:GCString:
      libunicode-linebreak-perl \
      # Log::Log4perl:
      liblog-log4perl-perl \
      # Log::Dispatch:
      liblog-dispatch-perl \
      # Get `envsubst` to replace environment variables in files with their actual values.
      gettext-base \
      # headless, 25% of normal size:
      default-jre-headless \
      # No headless inkscape available currently:
      inkscape \
      # nox (no X Window System): CLI version, 10% of normal size:
      gnuplot-nox \
      # For various conversion tasks, e.g. EPS -> PDF (for legacy support):
      ghostscript \
      # librsvg2 for 'rsvg-convert' used by pandoc to convert SVGs when embedding into PDF
      librsvg2-bin \
      #pandoc layer; not required for LaTeX compilation, but useful for document conversions
      pandoc

ENV PATH="/usr/local/texlive/${VERSION}/bin/x86_64-linux:${PATH}"

CMD ["/bin/bash"]