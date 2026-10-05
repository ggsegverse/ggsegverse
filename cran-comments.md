## Submission

This is a new submission of ggsegverse 0.0.1. The package has not been on CRAN
before.

## Test environments

* local macOS (aarch64-apple-darwin23), R 4.6.1
* GitHub Actions: ubuntu-latest (devel, release, oldrel-1), macOS-latest
  (release), windows-latest (release)
* R-hub

## R CMD check results

0 errors | 0 warnings | 1 note

```
* checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Athanasia Mo Mowinckel <a.m.mowinckel@psykologi.uio.no>'
  New submission
```

This note is expected for a first submission.

## This is not only a re-export shell

ggsegverse attaches its core dependencies, as tidyverse does, but it also
provides functionality of its own that exists in no other package in the
ecosystem:

* `ggseg_atlas_repos()` queries the ggsegverse r-universe index and returns the
  atlas packages published there.
* `installed_ggseg_atlases()` reconciles that index against the locally
  installed atlas packages.
* `install_ggseg_atlas()` and `install_ggseg_atlas_all()` install atlas
  packages from that repository.
* `ggsegverse_deps()`, `ggsegverse_sitrep()` and `ggsegverse_update()` report
  installed versus available versions across the ecosystem.
* `ggsegverse_conflicts()` reports masking between core packages, excluding
  re-exports of the identical object.

## Policy notes

* The package imports no package that it does not use, and re-exports nothing.
* `pak` is in Suggests and is reached only through `rlang::check_installed()`
  at the point of use.
* `install_ggseg_atlas()` adds the ggsegverse r-universe to `options("repos")`
  only for the duration of the call; the option is restored on exit via
  `withr::local_options()`.
* `install_ggseg_atlas_all()` asks for confirmation before installing, and
  refuses to run non-interactively unless `ask = FALSE` is passed explicitly.
* Nothing in the examples, tests or vignette accesses the network during
  `R CMD check`. Examples of network-facing functions are wrapped in
  `\dontrun{}`, the vignette chunks that install atlases are not evaluated,
  and the tests mock all HTTP calls. Functions that reach the internet warn
  and return `NULL` (or a zero-row result) when the resource is unavailable,
  rather than failing.
* `Additional_repositories` points at <https://ggsegverse.r-universe.dev>,
  which hosts the optional atlas packages. No atlas package is required to
  install, load, check or use ggsegverse.
