param (
  [string]$texfile = "main.tex"
)

$source = (PWD).Path
if ($env:DOCKER_TOOLBOX_PATH)
{
  $uri = [System.Uri]$source
  $drive = $uri.Segments[1].TrimEnd(':/').ToLower()
  $parts = $uri.Segments[2..($uri.Segments.Length - 1)]
  $arr = @()
  $arr += $drive + '/'
  $arr += $parts
  $source = '/' + ($arr -Join '')
}

$image = "blang/latex:ctanfull"
& docker run `
    --rm `
    --interactive `
    --tty `
    --user=${id -u}:${id -g} `
    --net=none `
    --mount type=bind,source="${source}",target=/data `
    ${image} `
    latexmk -cd -pvc -f -interaction=batchmode -pdflua -view=none $texfile
