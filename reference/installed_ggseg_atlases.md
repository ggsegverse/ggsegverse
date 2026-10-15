# List installed ggseg atlas packages

Check which ggseg atlas packages from the ggsegverse r-universe are
currently installed on your system, and how their versions compare to
what is available.

## Usage

``` r
installed_ggseg_atlases()
```

## Value

A tibble with one row per installed atlas package and columns `package`,
`installed` (local version), and `available` (version on the
r-universe).

## See also

[`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
to list all available atlases,
[`install_ggseg_atlas()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas.md)
to install one

## Examples

``` r
if (FALSE) { # \dontrun{
installed_ggseg_atlases()
} # }
```
