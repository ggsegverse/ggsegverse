# ggsegverse (development version)

## Bug fixes

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
