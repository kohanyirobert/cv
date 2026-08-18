param (
  [string]$texfile = "main.tex"
)

$source = (PWD).Path
$image = "ghcr.io/kohanyirobert/cv:latest"
& docker run `
    --rm `
    --interactive `
    --tty `
    --net=none `
    --mount type=bind,source="${source}",target=/data `
    --workdir /data `
    ${image} `
    latexmk -cd -pvc -f -interaction=batchmode -pdflua -view=none $texfile
