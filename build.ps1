$image = "blang/latex:ctanfull"
& docker run `
    --rm `
    --interactive `
    --user=${id -u}:${id -g} `
    --net=none `
    --volume ${pwd}:/data `
    ${image} `
    latexmk -cd -pvc -f -interaction=batchmode -pdflua -view=none main.tex
