# Quick instructions for AI coding agents working on ggsegverse

Purpose: help an AI get productive quickly by outlining the project’s
shape, important files, build/test workflows, and repo-specific
conventions.

- Big picture
  - ggsegverse is a tidyverse-style meta-package that installs and loads
    the ggseg brain visualization ecosystem with
    [`library(ggsegverse)`](https://ggsegverse.github.io/ggsegverse/).
  - It does not contain plotting code itself — it orchestrates loading
    of core packages: `ggseg.formats`, `ggseg`, `ggseg3d`, `ggseg.hub`,
    and `neuromapr`.
  - The design mirrors how the `tidyverse` package works: attach core
    packages, report versions, detect conflicts.
- Core packages (loaded on attach)
  - `ggseg.formats` — atlas data structures and S3 classes (foundation).
  - `ggseg` — 2D ggplot2 brain region plotting via `geom_brain()`.
  - `ggseg3d` — interactive 3D brain visualization with plotly.
  - `ggseg.hub` — atlas discovery, comparison, and installation helpers.
  - `neuromapr` — spatial null models for brain maps.
  - All live under the `ggseg` GitHub org. `ggseg.hub` and `neuromapr`
    are not yet on CRAN; install from GitHub or local sources.
- Key files & folders
  - `DESCRIPTION` — lists all core packages as Imports; `Remotes` points
    to GitHub sources for packages not on CRAN.
  - `R/attach.R` — attachment logic: `core_unloaded()`,
    `same_library()`, `ggsegverse_attach()`, startup message formatting.
  - `R/zzz.R` — `.onAttach()` hook; respects `ggsegverse.quiet` option
    and suppresses messages during testthat runs.
  - `R/conflicts.R` —
    [`ggsegverse_conflicts()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_conflicts.md)
    detects function name clashes between ggseg packages and other
    loaded packages.
  - `R/update.R` —
    [`ggsegverse_update()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_update.md),
    [`ggsegverse_deps()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_deps.md),
    and
    [`ggsegverse_sitrep()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_sitrep.md)
    for checking installed vs available versions.
  - `R/utils.R` —
    [`ggsegverse_packages()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_packages.md)
    parses DESCRIPTION Imports to list core packages; shared helpers.
  - `R/ggsegverse-package.R` — package-level docs and
    `ignore_unused_imports()` to satisfy R CMD check.
- Developer workflows
  - Update docs after changing roxygen: `devtools::document()`
  - Run full package checks: `devtools::check()`
  - Run unit tests: `devtools::test()`
  - Load for interactive testing: `devtools::load_all()`
- Exported API (5 functions + 2 S3 methods)
  - [`ggsegverse_packages()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_packages.md)
    — character vector of core package names.
  - [`ggsegverse_conflicts()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_conflicts.md)
    — detect masked functions.
  - [`ggsegverse_update()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_update.md)
    — check for outdated packages.
  - [`ggsegverse_deps()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_deps.md)
    — data frame of local vs available versions.
  - [`ggsegverse_sitrep()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_sitrep.md)
    — diagnostic overview.
  - `print.ggsegverse_conflicts` / `format.ggsegverse_conflicts` — S3
    methods for conflict display.
- Conventions & patterns
  - Tidyverse coding style; use `|>` pipe where existing code does.
  - roxygen2 for all documentation; NAMESPACE is auto-generated.
  - No code comments except when explaining necessary workarounds.
  - Self-explanatory function and variable naming.
  - Tests use testthat with `describe()`/`it()` structure.
  - Adding a new core package: add to DESCRIPTION Imports, add to
    `core_packages()` in `R/utils.R`, add a reference in
    `ignore_unused_imports()` in `R/ggsegverse-package.R`, and add a
    Remotes entry if not on CRAN.
- Example change pattern
  1.  Add new core package to `DESCRIPTION` Imports and Remotes.
  2.  Add package name to `core_packages()` in `R/utils.R`.
  3.  Add one exported symbol reference in `ignore_unused_imports()`.
  4.  Run `devtools::document()` and `devtools::check()`.
