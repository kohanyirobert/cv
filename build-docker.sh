#!/bin/bash
texfile=${1:-main.tex}

image=ghcr.io/kohanyirobert/cv:latest
docker run \
  --rm \
  --interactive \
  --tty \
  --user=$(id -u):$(id -g) \
  --net=none \
  --mount type=bind,source="$PWD",target=/data \
  --workdir /data \
  $image \
  latexmk -cd -pvc -f -interaction=batchmode -pdflua -view=none $texfile
