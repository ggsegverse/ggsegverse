# List available ggseg atlas packages

Query the ggsegverse r-universe to see which atlas packages are
available for installation. Returns package metadata including name,
version, and description.

## Usage

``` r
ggseg_atlas_repos(pattern = NULL, ...)
```

## Arguments

- pattern:

  Optional regex to filter packages by name (e.g., `"yeo"` to find Yeo
  atlas packages).

- ...:

  Additional arguments passed to
  [`base::grep()`](https://rdrr.io/r/base/grep.html).

## Value

A tibble of available atlas packages.

## Details

Only atlas packages are listed: those following the `ggseg<Atlas>`
naming convention (e.g. `ggsegYeo2011`, `ggsegSchaefer`). Core packages
and tools hosted on the same r-universe, such as `ggseg`, `ggseg3d`, or
the atlas-building toolkit `ggseg.extra`, are excluded.

## See also

[`install_ggseg_atlas()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas.md)
to install a specific atlas

## Examples

``` r
if (FALSE) { # \dontrun{
# See all available atlases
ggseg_atlas_repos()

# Find Yeo parcellation atlases
ggseg_atlas_repos("yeo")
} # }
```
