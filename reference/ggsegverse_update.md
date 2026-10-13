# Update ggsegverse packages

Checks the core ggsegverse packages for newer versions and prints the
[`pak::pak()`](https://pak.r-lib.org/reference/pak.html) call that
updates them. Nothing is installed automatically.

## Usage

``` r
ggsegverse_update()
```

## Value

The rows of
[`ggsegverse_deps()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_deps.md)
that are out of date (invisibly), or `NULL` invisibly when everything is
current.

## See also

[`ggsegverse_sitrep()`](https://ggseg.github.io/ggsegverse/reference/ggsegverse_sitrep.md)
for a full overview.

## Examples

``` r
if (FALSE) { # \dontrun{
ggsegverse_update()
} # }
```
