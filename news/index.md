# Changelog

## ggsegverse (development version)

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
