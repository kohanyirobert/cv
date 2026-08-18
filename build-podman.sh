#!/bin/bash
# Builds main.pdf inside the container image, without needing TeX Live locally.
#
#   ./build-podman.sh            one-shot build, identical to the Build workflow
#   ./build-podman.sh --watch    rebuild on every save, Ctrl-C to stop
#
# The Build workflow runs this same script, so the one-shot path is the single
# definition of how the CV is built. Keep it that way.
set -euo pipefail

watch=false
if [[ ${1:-} == --watch || ${1:-} == -w ]]; then
  watch=true
  shift
fi
texfile=${1:-main.tex}

image=ghcr.io/kohanyirobert/cv:latest

# --net=none because the build needs no network. Rootless podman already maps
# the container's root to the invoking user, so output is correctly owned --
# do not add --user, it maps to a subuid that cannot write to the bind mount.
if $watch; then
  # -pvc watches and rebuilds; -view=none because there is no viewer in the
  # container. --tty for Ctrl-C and progress output. Otherwise the same flags
  # as the one-shot build, so errors surface the same way.
  exec podman run \
    --rm \
    --interactive \
    --tty \
    --net=none \
    --mount type=bind,source="$PWD",target=/data \
    --workdir /data \
    "$image" \
    latexmk -quiet -pdflua -pvc -view=none "$texfile"
fi

exec podman run \
  --rm \
  --net=none \
  --mount type=bind,source="$PWD",target=/data \
  --workdir /data \
  "$image" \
  latexmk -quiet -pdflua "$texfile"
