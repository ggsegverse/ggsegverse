# ggsegverse 0.0.1

* Initial release.

* `library(ggsegverse)` attaches the core ggsegverse packages — ggseg.formats,
  ggseg, ggseg3d, ggseg.meshes — together with ggplot2, and prints a startup
  banner of the attached versions. Set `options(ggsegverse.quiet = TRUE)` to
  suppress the banner.

* Atlas discovery and installation: `ggseg_atlas_repos()` lists the atlas
  packages published on the ggsegverse r-universe,
  `installed_ggseg_atlases()` compares those against what is installed
  locally, and `install_ggseg_atlas()` / `install_ggseg_atlas_all()` install
  them.

* Version reporting: `ggsegverse_packages()` lists the core packages,
  `ggsegverse_deps()` compares installed against available versions,
  `ggsegverse_sitrep()` prints a situation report for bug reports, and
  `ggsegverse_update()` prints the `pak::pak()` call that brings the
  ecosystem up to date without installing anything itself.

* Conflict reporting: `ggsegverse_conflicts()` reports objects of a core
  package that mask, or are masked by, another attached package, ignoring
  re-exports of the identical object.
