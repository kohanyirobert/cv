param (
  [string]$texfile = "main.tex"
)
$image = "blang/latex:ctanfull"
& docker run `
    --rm `
    --interactive `
    --tty `
    --user=${id -u}:${id -g} `
    --net=none `
    --volume ${pwd}:/data `
    ${image} `
    latexmk -cd -pvc -f -interaction=batchmode -pdflua -view=none $texfile
