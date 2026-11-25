# Changelog

## ggsegverse (development version)

- [`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
  works out which packages are atlases from what they declare, not from
  their name: anything in the universe that builds on `ggseg.formats`
  and is not one of our own tools. The payload was already in hand, so
  this costs no extra request, and it falls back to the name shape if
  the API stops serving `_dependencies`.

- [`installed_ggseg_atlases()`](https://ggsegverse.github.io/ggsegverse/reference/installed_ggseg_atlases.md)
  warns when the r-universe lookup fails instead of reporting
  `available = NA` for every row, which the documentation says means the
  atlas is not hosted.

- `installed_atlas_packages()` takes the library paths, so the
  `DESCRIPTION` filter and the cross-library dedup are testable.

### Bug fixes

- The documented install now works: `Additional_repositories` declares
  the ggsegverse r-universe, and the README installs from it. Nothing on
  CRAN can satisfy a dev-version floor, so the old
  [`pak::pak()`](https://pak.r-lib.org/reference/pak.html) line could
  only fail.

- Raised the core package floors to the current development versions.
  They were stale, and a floor pairing `ggseg.meshes` before 0.0.1.9002
  with `ggseg3d` after 2.1.2.9010 renders the cortex rotated 90 degrees
  in silence.

- [`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
  aborts with a readable message when the r-universe returns a body that
  is not a package table, instead of “incorrect number of dimensions”.

- [`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
  filters with [`grepl()`](https://rdrr.io/r/base/grep.html), so
  `value = TRUE` errors rather than returning a row of `NA`.

- [`installed_ggseg_atlases()`](https://ggsegverse.github.io/ggsegverse/reference/installed_ggseg_atlases.md)
  reads your library rather than the r-universe, so it works offline and
  lists atlases you installed from elsewhere; `available` is `NA` when
  the r-universe cannot be reached.

- The `ggsegverse` vignette maps data on `label`, not `region`. `region`
  repeats across hemispheres, so the example filled both of them.

- Requires R \>= 4.2, which is the floor of `S7`, and so of
  `ggseg.formats`. The package advertised an older R than its own
  dependency could install on.

- The core packages are pinned. They were imported unversioned, so
  installing ggsegverse on a machine with older copies upgraded nothing
  and loaded an incoherent set – including a `ggseg.formats` whose
  `tracula` was mirrored left-to-right, which ggseg3d would then draw
  with the hemispheres swapped. A meta-package whose job is a coherent
  install has to say which versions are coherent.

- Initial development version.

- [`library(ggsegverse)`](https://ggsegverse.github.io/ggsegverse/)
  attaches the core packages (ggseg.formats, ggseg, ggseg3d,
  ggseg.meshes, ggplot2) and prints a startup banner. Set
  `options(ggsegverse.quiet = TRUE)` to suppress it.

- Added
  [`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md),
  [`install_ggseg_atlas()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas.md),
  [`install_ggseg_atlas_all()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas_all.md)
  and
  [`installed_ggseg_atlases()`](https://ggsegverse.github.io/ggsegverse/reference/installed_ggseg_atlases.md)
  to discover and install atlas packages from the ggsegverse r-universe.

- Added
  [`ggsegverse_packages()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_packages.md),
  [`ggsegverse_deps()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_deps.md),
  [`ggsegverse_sitrep()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_sitrep.md)
  and
  [`ggsegverse_update()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_update.md)
  to report and refresh core package versions.

- Added
  [`ggsegverse_conflicts()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_conflicts.md)
  to report masking between core packages and other attached packages,
  ignoring re-exports of the identical object.
