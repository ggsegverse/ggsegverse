# Changelog

## ggsegverse (development version)

### Bug fixes

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
