# ggsegverse (development version)

- `installed_ggseg_atlases()` warns when the r-universe lookup fails instead
  of reporting `available = NA` for every row, which the documentation says
  means the atlas is not hosted.
- `installed_atlas_packages()` takes the library paths, so the
  `DESCRIPTION` filter and the cross-library dedup are testable.

## Bug fixes

- The documented install now works: `Additional_repositories` declares the
  ggsegverse r-universe, and the README installs from it. Nothing on CRAN can
  satisfy a dev-version floor, so the old `pak::pak()` line could only fail.
- Raised the core package floors to the current development versions.
  They were stale, and a floor pairing `ggseg.meshes` before 0.0.1.9002 with
  `ggseg3d` after 2.1.2.9010 renders the cortex rotated 90 degrees in silence.
- `ggseg_atlas_repos()` aborts with a readable message when the r-universe
  returns a body that is not a package table, instead of
  "incorrect number of dimensions".
- `ggseg_atlas_repos()` filters with `grepl()`, so `value = TRUE` errors
  rather than returning a row of `NA`.
- `installed_ggseg_atlases()` reads your library rather than the r-universe,
  so it works offline and lists atlases you installed from elsewhere;
  `available` is `NA` when the r-universe cannot be reached.
- The `ggsegverse` vignette maps data on `label`, not `region`. `region`
  repeats across hemispheres, so the example filled both of them.

- Requires R >= 4.2, which is the floor of `S7`, and so of `ggseg.formats`.
  The package advertised an older R than its own dependency could install on.

- The core packages are pinned. They were imported unversioned, so
  installing ggsegverse on a machine with older copies upgraded nothing and
  loaded an incoherent set -- including a `ggseg.formats` whose `tracula` was
  mirrored left-to-right, which ggseg3d would then draw with the hemispheres
  swapped. A meta-package whose job is a coherent install has to say which
  versions are coherent.

* Initial development version.

* `library(ggsegverse)` attaches the core packages (ggseg.formats, ggseg,
  ggseg3d, ggseg.meshes, ggplot2) and prints a startup banner.
  Set `options(ggsegverse.quiet = TRUE)` to suppress it.

* Added `ggseg_atlas_repos()`, `install_ggseg_atlas()`,
  `install_ggseg_atlas_all()` and `installed_ggseg_atlases()` to discover and
  install atlas packages from the ggsegverse r-universe.

* Added `ggsegverse_packages()`, `ggsegverse_deps()`, `ggsegverse_sitrep()`
  and `ggsegverse_update()` to report and refresh core package versions.

* Added `ggsegverse_conflicts()` to report masking between core packages and
  other attached packages, ignoring re-exports of the identical object.
