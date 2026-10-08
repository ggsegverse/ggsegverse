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

  Found the following (possibly) invalid URLs:
    URL: https://ggsegverse.github.io/ggsegverse/
      From: DESCRIPTION
            DESCRIPTION
            man/ggsegverse-package.Rd
      Status: 404
      Message: Not Found
```

The "New submission" paragraph is expected for a first submission.

The 404 is the package's own pkgdown site. It is built and deployed by GitHub
Actions from the submitted tag, so the URL resolves once that workflow has run.
It is listed in `URL` because `pkgdown::check_pkgdown()` requires it.

The same check run with `_R_CHECK_DEPENDS_ONLY_=true` gives the same result --
0 errors | 0 warnings | 1 note, that note being the one above -- confirming
that nothing in Suggests is needed to install, check or use the package.

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

* The package re-exports nothing. Five of its imports (ggseg, ggseg.formats,
  ggseg3d, ggseg.meshes, ggplot2) are attached for the user rather than called
  by ggsegverse code, so they are referenced once in an unexported
  `ignore_unused_imports()` helper, the standard idiom for a metapackage.
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
  and return `NULL` (or a zero-row result) rather than failing, both when the
  request fails and when it succeeds with a body that is not the expected
  package index.
* `Additional_repositories` points at <https://ggsegverse.r-universe.dev>,
  which serves the pre-release versions of ggseg and ggseg.formats that the
  `Imports` floors currently require. Those floors become CRAN release
  numbers at submission, at which point the field is removed. The optional
  atlas packages are also hosted there, but they are installed at run time by
  `install_ggseg_atlas()` and are never declared dependencies; no atlas
  package is required to install, load, check or use ggsegverse.
