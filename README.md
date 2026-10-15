
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggsegverse

<!-- badges: start -->

[![R-CMD-check](https://github.com/ggsegverse/ggsegverse/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ggsegverse/ggsegverse/actions/workflows/R-CMD-check.yaml)
[![code-quality](https://github.com/ggsegverse/ggsegverse/actions/workflows/code-quality.yaml/badge.svg)](https://github.com/ggsegverse/ggsegverse/actions/workflows/code-quality.yaml)
[![test-coverage](https://github.com/ggsegverse/ggsegverse/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/ggsegverse/ggsegverse/actions/workflows/test-coverage.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The ggsegverse is a set of R packages for brain region visualization
built on ggplot2. The **ggsegverse** package makes it easy to install
and load the core packages in a single step.

``` r
library(ggsegverse)
```

## Core packages

Loading ggsegverse attaches the following packages:

| Package | Description |
|----|----|
| [ggseg.formats](https://github.com/ggsegverse/ggseg.formats) | Atlas data structures and S3 classes |
| [ggseg](https://github.com/ggsegverse/ggseg) | 2D brain region plotting with `geom_brain()` |
| [ggseg3d](https://github.com/ggsegverse/ggseg3d) | Interactive 3D brain visualization |
| [ggseg.meshes](https://github.com/ggsegverse/ggseg.meshes) | Additional cortical and cerebellar surface meshes for 3D rendering |
| [ggplot2](https://ggplot2.tidyverse.org) | The grammar of graphics that ggseg builds on |

ggsegverse is for plotting. To build your own atlases, install
[ggseg.extra](https://ggsegverse.github.io/ggseg.extra/) separately.

## Installation

You can install ggsegverse from
[GitHub](https://github.com/ggsegverse/ggsegverse):

``` r
# install.packages("pak")
pak::pak("ggsegverse/ggsegverse")
```

This will also install all core packages that are not already on your
system.

## Usage

`library(ggsegverse)` loads and attaches all core packages. On attach,
it displays the loaded packages with their versions and any namespace
conflicts:

``` r
library(ggsegverse)
#> ── ggsegverse ───────────────────────────────────────────────────────── 0.0.1 ──
#> ✔ ggseg.formats 0.0.4.9006 ✔ ggseg.meshes 0.0.1.9000
#> ✔ ggseg 2.2.1.9007 ✔ ggplot2 4.0.3
#> ✔ ggseg3d 2.1.2.9003
```

### Find and install atlases

More atlases live on the [ggsegverse
r-universe](https://ggsegverse.r-universe.dev):

``` r
ggseg_atlas_repos("yeo")
install_ggseg_atlas("ggsegYeo2011")
installed_ggseg_atlases()
```

### Check for outdated packages

``` r
ggsegverse_sitrep()
#> 
#> ── ggsegverse situation report ─────────────────────────────────────────────────
#> 
#> ── Installed packages ──
#> 
#> ✔ ggseg.formats: 0.0.4.9006
#> ✔ ggseg: 2.2.1.9007
#> ✔ ggseg3d: 2.1.2.9003
#> ✔ ggseg.meshes: 0.0.1.9000
#> ✔ ggplot2: 4.0.3
#> 
#> ── R version ──
#> 
#> R version 4.6.1 (2026-06-24)
```

### List namespace conflicts

``` r
ggsegverse_conflicts()
#> No conflicts detected.
```

### Suppress startup message

``` r
options(ggsegverse.quiet = TRUE)
library(ggsegverse)
```
