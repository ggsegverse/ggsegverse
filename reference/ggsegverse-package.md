# ggsegverse: Easily Install and Load the 'ggsegverse' Brain Visualisation Ecosystem

Installs and loads the core packages of the 'ggsegverse', an ecosystem
for plotting brain atlases and mapping data onto brain regions in 2D and
3D, together with 'ggplot2', in a single call. Also provides helpers to
find and install atlas packages, report package versions, and detect
namespace conflicts. Learn more about the 'ggsegverse' ecosystem at
<https://ggsegverse.github.io/ggsegverse/>.

## Details

[`library(ggsegverse)`](https://ggsegverse.github.io/ggsegverse/)
attaches the core packages:

- ggseg — 2D brain atlas plots with `geom_brain()`.

- ggseg3d — interactive 3D brain atlas widgets.

- ggseg.formats — atlas data structures and the bundled `dk()`,
  `aseg()`, `tracula()`, and `suit()` atlases.

- ggseg.meshes — additional cortical and cerebellar surface meshes.

- ggplot2 — the plotting grammar ggseg builds on.

More atlases are available from the ggsegverse r-universe; see
[`ggseg_atlas_repos()`](https://ggsegverse.github.io/ggsegverse/reference/ggseg_atlas_repos.md)
and
[`install_ggseg_atlas()`](https://ggsegverse.github.io/ggsegverse/reference/install_ggseg_atlas.md).
To build your own atlases, install ggseg.extra separately.

## Options

- `ggsegverse.quiet`:

  Set to `TRUE` to suppress the startup message when loading ggsegverse.
  Default is `FALSE`.

## See also

Useful links:

- <https://ggsegverse.github.io/ggsegverse/>

- <https://github.com/ggsegverse/ggsegverse>

- Report bugs at <https://github.com/ggsegverse/ggsegverse/issues>

## Author

**Maintainer**: Athanasia Mo Mowinckel <a.m.mowinckel@psykologi.uio.no>
([ORCID](https://orcid.org/0000-0002-5756-0223))

Authors:

- Athanasia Mo Mowinckel <a.m.mowinckel@psykologi.uio.no>
  ([ORCID](https://orcid.org/0000-0002-5756-0223))

Other contributors:

- Center for Lifespan Changes in Brain and Cognition (LCBC), University
  of Oslo \[copyright holder\]
