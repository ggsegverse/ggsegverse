# Install a ggseg atlas package

Install an atlas package from the ggsegverse r-universe. This is the
easiest way to get pre-built atlases like Yeo, Schaefer, Glasser, etc.
The r-universe is added to pak's repositories for the session, so
dependencies from the ecosystem resolve too.

## Usage

``` r
install_ggseg_atlas(package, ...)
```

## Arguments

- package:

  Package name (e.g., `"ggsegYeo2011"`, `"ggsegSchaefer"`). Use
  [`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
  to see available packages.

- ...:

  Additional arguments passed to
  [`pak::pak()`](https://pak.r-lib.org/reference/pak.html).

## Value

Called for its side effect of installing the package; returns the value
of [`pak::pak()`](https://pak.r-lib.org/reference/pak.html) invisibly.

## See also

[`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
to list available atlases

## Examples

``` r
if (FALSE) { # \dontrun{
# Find available Yeo atlases
ggseg_atlas_repos("yeo")

# Install one
install_ggseg_atlas("ggsegYeo2011")
} # }
```
