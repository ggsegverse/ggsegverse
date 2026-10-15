# Situation report for ggsegverse

Prints the installed version of each core package, flags packages that
are missing or out of date, and reports the running R version. Useful to
include when reporting a bug.

## Usage

``` r
ggsegverse_sitrep()
```

## Value

The data frame from
[`ggsegverse_deps()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_deps.md),
invisibly.

## See also

[`ggsegverse_update()`](https://ggsegverse.github.io/ggsegverse/reference/ggsegverse_update.md)
to get the update command.

## Examples

``` r
if (FALSE) { # \dontrun{
ggsegverse_sitrep()
} # }
```
