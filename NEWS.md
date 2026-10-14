# ggsegverse (development version)

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
