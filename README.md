# CV

LaTeX CV built with [moderncv](https://ctan.org/pkg/moderncv), typeset by
LuaLaTeX. The source is `main.tex`; `main.pdf` is a build artifact and is not
committed.

## Building

Everything needed to build is in a container image, so no TeX Live installation
is required locally — only [Podman](https://podman.io).

```bash
./build-podman.sh            # one-shot build
./build-podman.sh --watch    # rebuild on every save, Ctrl-C to stop
```

Pass a different `.tex` file as the last argument if needed.

The *Build* workflow runs this same script, so a successful local build means
CI will build too. Keep it that way — if the build ever needs different flags,
change them here rather than in `.github/workflows/build.yml`.

Do not add `--user=$(id -u):$(id -g)` to the podman invocation. Rootless Podman
already maps the container's root to the invoking user, so output is correctly
owned without it; passing it lands on an unprivileged subuid that cannot write
to the bind mount.

The CV must stay **one page**. Check after any change:

```bash
grep 'Output written' main.log
```

## Releasing

Pushing to `main` builds the PDF and hands off to
[release-please](https://github.com/googleapis/release-please), which computes
the next version from Conventional Commit prefixes — `fix:` for a patch,
`feat:` for a minor, `chore:`/`ci:`/`docs:` for no release at all. Merging the
release PR it opens cuts the release, attaches `main.pdf` to the tag, and
publishes the PDF to the website repository.

The version in the footer comes from `version.txt`, which release-please
maintains.

## Container image

`Dockerfile` defines the build environment and is published to
`ghcr.io/kohanyirobert/cv:latest` by the *Build and push image* workflow, which
runs on any change to that file.
