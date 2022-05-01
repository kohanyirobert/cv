#!/bin/bash
texfile=${1:-main.tex}

latexmk -cd -pvc -f -interaction=batchmode -pdflua -view=none $texfile
