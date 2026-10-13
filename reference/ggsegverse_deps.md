# List ggsegverse package dependencies and versions

Compares the installed version of each core package with the latest
available version. ggsegverse packages are checked against the `main`
branch on GitHub; ggplot2 is checked against CRAN. Requires an internet
connection; versions that cannot be retrieved are `NA`.

## Usage

``` r
ggsegverse_deps()
```

## Value

A data frame with columns `package`, `local` (installed version, `NA` if
not installed), `available` (latest version, `NA` if it could not be
retrieved), and `behind` (logical).

## Examples

``` r
if (FALSE) { # \dontrun{
ggsegverse_deps()
} # }
```
