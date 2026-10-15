# Conflicts between ggsegverse packages and other loaded packages

Lists objects exported by a core ggsegverse package that mask, or are
masked by, an object of the same name in another attached package.
Re-exports of the identical object (for example
[`ggseg::dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.html)
re-exporting
[`ggseg.formats::dk()`](https://ggsegverse.github.io/ggseg.formats/reference/dk.html))
are not conflicts and are not reported.

## Usage

``` r
ggsegverse_conflicts()
```

## Value

A `ggsegverse_conflicts` object: a named list, one element per
conflicting name, each holding the `winner` package and the `masked`
packages.

## Details

Conflicts are shown when ggsegverse is attached. To make every ambiguous
call an error instead, use the conflicted package.

## Examples

``` r
ggsegverse_conflicts()
#> No conflicts detected.
```
