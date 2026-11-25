# List installed ggseg atlas packages

Check which ggseg atlas packages are currently installed on your system,
and how their versions compare to what the ggsegverse r-universe offers.
The list of installed packages is read from your library, so atlases you
built yourself are included too.

## Usage

``` r
installed_ggseg_atlases()
```

## Value

A tibble with one row per installed atlas package and columns `package`,
`installed` (local version), and `available` (version on the r-universe,
or `NA` if the r-universe cannot be reached or does not host the
package).

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
