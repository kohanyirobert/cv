# buildpack-deps:20.04
FROM buildpack-deps@sha256:d2dccd92800ce961e0b9f65fb9293055536a01252528347a65c4e1c37608342f AS texlive
RUN curl --location --remote-name https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
  && mkdir --parent /tmp/tlnet \
  && tar --strip-components 1 --directory /tmp/tlnet --extract --file install-tl-unx.tar.gz \
  && echo 'selected_scheme scheme-basic' >> /tmp/tlnet/texlive.profile \
  && /tmp/tlnet/install-tl --profile=/tmp/tlnet/texlive.profile \
  && rm -rf install-tl-unx.tar.gz /tmp/tlnet
ENV PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH
ENV MANPATH=/usr/local/texlive/2022/texmf-dist/doc/man:$MANPATH
ENV INFOPATH=/usr/local/texlive/2022/texmf-dist/doc/info:$INFOPATH
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
