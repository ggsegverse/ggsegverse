# List the core ggsegverse packages

The packages attached by
[`library(ggsegverse)`](https://ggsegverse.github.io/ggsegverse/):
ggseg.formats, ggseg, ggseg3d, ggseg.meshes, and ggplot2. Atlas packages
and the atlas-building toolkit ggseg.extra are not core packages; see
[`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
for atlases.

## Usage

``` r
ggsegverse_packages(include_self = FALSE)
```

## Arguments

- include_self:

  Whether to include ggsegverse itself in the list.

## Value

A character vector of package names.

## Examples

``` r
ggsegverse_packages()
#> [1] "ggseg.formats" "ggseg"         "ggseg3d"       "ggseg.meshes" 
#> [5] "ggplot2"      
```
