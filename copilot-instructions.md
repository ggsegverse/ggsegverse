# Quick instructions for AI coding agents working on ggsegverse

Purpose: help an AI get productive quickly by outlining the project’s
shape, important files, build/test workflows, and repo-specific
conventions.

- Big picture
  - ggsegverse is a tidyverse-style meta-package that installs and loads
    the ggseg brain visualization ecosystem with
    [`library(ggsegverse)`](https://ggsegverse.github.io/ggsegverse/).
  - It does not contain plotting code itself — it orchestrates loading
    of core packages: `ggseg.formats`, `ggseg`, `ggseg3d`,
    `ggseg.meshes`, and `ggplot2`.
  - Scope is plotting: users load ggsegverse to make brain figures.
    Atlas-building tools (`ggseg.extra`) are deliberately not core;
    users install them separately when creating atlases.
  - The design mirrors how the `tidyverse` package works: attach core
    packages, report versions, detect conflicts.
- Core packages (loaded on attach)
  - `ggseg.formats` — atlas data structures and S3 classes (foundation).
  - `ggseg` — 2D ggplot2 brain region plotting via `geom_brain()`.
  - `ggseg3d` — interactive 3D brain visualization.
  - `ggseg.meshes` — additional cortical and cerebellar surface meshes.
  - `ggplot2` — the plotting grammar ggseg builds on; attached so
    `theme()`, scales, and `labs()` work without an extra
    [`library()`](https://rdrr.io/r/base/library.html).
  - The ggseg packages live under the `ggsegverse` GitHub org and are
    distributed through <https://ggsegverse.r-universe.dev>. `ggplot2`
    comes from CRAN. `core_package_sources()` in `R/utils.R` is the
    single source of truth: a named vector mapping each core package to
    its source (`"ggsegverse"` or `"cran"`), which drives version checks
    and install refs.
- Key files & folders
  - `DESCRIPTION` — lists all core packages as Imports.
  - `R/attach.R` — attachment logic: `core_unloaded()`,
    `same_library()`, `ggsegverse_attach()`, startup message formatting.
  - `R/zzz.R` — `.onAttach()` hook; respects `ggsegverse.quiet` option
    and suppresses messages during testthat runs.
  - `R/conflicts.R` —
    [`ggsegverse_conflicts()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_conflicts.md)
    detects name clashes involving ggseg packages. Re-exports of the
    identical object (e.g.
    [`ggseg::dk`](https://ggsegverse.github.io/ggseg.formats/reference/dk.html)
    re-exporting
    [`ggseg.formats::dk`](https://ggsegverse.github.io/ggseg.formats/reference/dk.html))
    are not conflicts.
  - `R/update.R` —
    [`ggsegverse_update()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_update.md),
    [`ggsegverse_deps()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_deps.md),
    and
    [`ggsegverse_sitrep()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_sitrep.md)
    for checking installed vs available versions (GitHub `main`
    DESCRIPTION for ggsegverse packages, CRAN for the rest).
  - `R/atlases.R` — atlas discovery and installation from the ggsegverse
    r-universe.
  - `R/utils.R` — `core_package_sources()` (the core package list),
    [`ggsegverse_packages()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_packages.md),
    and shared helpers like `installed_version()`.
  - `R/ggsegverse-package.R` — package-level docs and
    `ignore_unused_imports()` to satisfy R CMD check.
- Developer workflows
  - Update docs after changing roxygen: `devtools::document()`
  - Run full package checks: `devtools::check()`
  - Run unit tests: `devtools::test()`
  - Load for interactive testing: `devtools::load_all()`
- Exported API (9 functions + 2 S3 methods)
  - [`ggsegverse_packages()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_packages.md)
    — character vector of core package names.
  - [`ggsegverse_conflicts()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_conflicts.md)
    — detect masked functions.
  - [`ggsegverse_update()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_update.md)
    — check for outdated packages.
  - [`ggsegverse_deps()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_deps.md)
    — data frame of local vs available versions.
  - [`ggsegverse_sitrep()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_sitrep.md)
    — diagnostic overview.
  - [`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
    — list atlas packages on the r-universe.
  - [`install_ggseg_atlas()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas.md)
    /
    [`install_ggseg_atlas_all()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas_all.md)
    — install atlas packages.
  - [`installed_ggseg_atlases()`](https://ggsegverse.github.io/ggsegverse/reference/installed_ggseg_atlases.md)
    — list installed atlas packages.
  - `print.ggsegverse_conflicts` / `format.ggsegverse_conflicts` — S3
    methods for conflict display.
- Conventions & patterns
  - Tidyverse coding style; use `|>` pipe where existing code does.
  - roxygen2 for all documentation; NAMESPACE is auto-generated.
  - No code comments except when explaining necessary workarounds.
  - Self-explanatory function and variable naming.
  - Tests use testthat with `describe()`/`it()` structure.
  - Adding a new core package: add to DESCRIPTION Imports, add it with
    its source to `core_package_sources()` in `R/utils.R`, and add a
    reference in `ignore_unused_imports()` in `R/ggsegverse-package.R`.
    A test fails if a core package is missing from Imports.
- Example change pattern
  1.  Add new core package to `DESCRIPTION` Imports.
  2.  Add the package and its source to `core_package_sources()` in
      `R/utils.R`.
  3.  Add one exported symbol reference in `ignore_unused_imports()`.
  4.  Run `devtools::document()` and `devtools::check()`.
