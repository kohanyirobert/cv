#!/bin/bash
static_dir=$(mktemp -d)
ln --symbolic --relative index.html $static_dir/index.html
ln --symbolic --relative main.pdf $static_dir/main.pdf
python3 -m http.server --bind 0.0.0.0 --directory $static_dir 8000
