# gitpod/workspace-base:2022-04-29-21-59-17
FROM gitpod/workspace-base@sha256:87dea615c27cb27e251aee4795a3fe3ccabc09e480e6292e4127ab20736bc2b8
# ghcr.io/kohanyirobert/cv:latest
COPY --from=ghcr.io/kohanyirobert/cv@sha256:b706c49903a6a3de78ffacf45966a6ff65fe6725dd89288128f28e7af4c86295 /usr/local/texlive/2022 /usr/local/texlive/2022
ENV PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH
ENV MANPATH=/usr/local/texlive/2022/texmf-dist/doc/man:$MANPATH
ENV INFOPATH=/usr/local/texlive/2022/texmf-dist/doc/info:$INFOPATH
