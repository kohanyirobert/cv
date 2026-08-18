# Pinned rather than :latest. Any change to this file rebuilds and republishes
# the image, so an unpinned base would make every rebuild a silent OS upgrade.
# 24.04 is what the currently published image was built from.
FROM ubuntu:24.04
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
ENV LANG=en_US.utf8
# TeX Live is pinned to a specific release, installed from the frozen tlnet-final
# tree in the CTAN historic archive. The rolling tlnet tree always serves the
# *current* release, which silently upgrades the typesetting engine on every
# rebuild and desynchronises TEXLIVE_VERSION below.
#
# Bumping TEXLIVE_VERSION is a deliberate engine upgrade: rebuild, then re-check
# that main.pdf still fits on one page before relying on it.
#
# Both the installer and tlmgr must point at the same frozen tree. TeX Live
# refuses to run an installer against a repository of a different year, and
# tlmgr otherwise defaults back to the rolling tree.
ARG TEXLIVE_VERSION=2025
ARG TEXLIVE_REPO=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/$TEXLIVE_VERSION/tlnet-final
RUN curl --location --remote-name $TEXLIVE_REPO/install-tl-unx.tar.gz \
  && mkdir --parent /tmp/tlnet \
  && tar --strip-components 1 --directory /tmp/tlnet --extract --file install-tl-unx.tar.gz \
  && echo 'selected_scheme scheme-basic' >> /tmp/tlnet/texlive.profile \
  && /tmp/tlnet/install-tl --profile=/tmp/tlnet/texlive.profile --repository $TEXLIVE_REPO \
  && rm -rf install-tl-unx.tar.gz /tmp/tlnet
# PATH, etc. must be set correctly according to the TeX Live version.
ENV PATH=/usr/local/texlive/$TEXLIVE_VERSION/bin/x86_64-linux:$PATH
ENV MANPATH=/usr/local/texlive/$TEXLIVE_VERSION/texmf-dist/doc/man
ENV INFOPATH=/usr/local/texlive/$TEXLIVE_VERSION/texmf-dist/doc/info
RUN tlmgr --repository $TEXLIVE_REPO install \
  academicons \
  arydshln \
  fontawesome5 \
  fontspec \
  latexmk \
  luatexbase \
  moderncv \
  multirow \
  pgf
