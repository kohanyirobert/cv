# The latest tag refers to LTS in case of Ubuntu.
# Using it in hope that TeX live follows the release cadence.
FROM ubuntu:latest
# See *Locales* at https://hub.docker.com/_/ubuntu
RUN apt-get update && apt-get install -y \
# Curl required to download TeX Live installer.
  curl \
# Locales required to produce PDF with latexmk.
  locales \
# Perl required to run (at least) the TeX Live installer.
  perl \
  && rm -rf /var/lib/apt/lists/* \
# Set the locale to UTF-8. Required for latexmk to work properly.
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
# This installs the *latest* TeX Live version - installing a specific version is not really supported.
# Archive final versions can be installed, but downloading those releases are slow(er).
RUN curl --location --remote-name https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
  && mkdir --parent /tmp/tlnet \
  && tar --strip-components 1 --directory /tmp/tlnet --extract --file install-tl-unx.tar.gz \
  && echo 'selected_scheme scheme-basic' >> /tmp/tlnet/texlive.profile \
  && /tmp/tlnet/install-tl --profile=/tmp/tlnet/texlive.profile \
  && rm -rf install-tl-unx.tar.gz /tmp/tlnet
# PATH, etc. must be set correctly according to the TeX Live version.
ARG TEXLIVE_VERSION=2025
ENV PATH=/usr/local/texlive/$TEXLIVE_VERSION/bin/x86_64-linux:$PATH
ENV MANPATH=/usr/local/texlive/$TEXLIVE_VERSION/texmf-dist/doc/man:$MANPATH
ENV INFOPATH=/usr/local/texlive/$TEXLIVE_VERSION/texmf-dist/doc/info:$INFOPATH
RUN tlmgr install \
  academicons \
  arydshln \
  fontawesome5 \
  fontspec \
  latexmk \
  luatexbase \
  moderncv \
  multirow \
  pgf
