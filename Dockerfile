# Using stable in hope that TeX live follows the release cadence of Debian.
FROM buildpack-deps:stable
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
  pgf # resolves tikz dependency
