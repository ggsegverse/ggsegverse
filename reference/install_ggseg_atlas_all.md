# Install all available ggseg atlas packages

Downloads and installs every atlas package listed by
[`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md).
This will take a while and use substantial disk space. For most users,
installing individual atlases with
[`install_ggseg_atlas()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas.md)
is more practical.

## Usage

``` r
install_ggseg_atlas_all(...)
```

## Arguments

- ...:

  Additional arguments passed to
  [`pak::pak()`](https://pak.r-lib.org/reference/pak.html).

## Value

Called for its side effect of installing the packages; returns the value
of [`pak::pak()`](https://pak.r-lib.org/reference/pak.html) invisibly.

## See also

[`install_ggseg_atlas()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas.md)
to install specific atlases

## Examples

``` r
if (FALSE) { # \dontrun{
# Install everything (slow, large download)
install_ggseg_atlas_all()
} # }
```
