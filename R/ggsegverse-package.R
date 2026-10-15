#' @keywords internal
#' @importFrom ggplot2 ggplot
#' @importFrom ggseg GeomBrain
#' @importFrom ggseg.formats as_brain_atlas
#' @importFrom ggseg.meshes available_cortical_surfaces
#' @importFrom ggseg3d add_glassbrain
#' @details
#' `library(ggsegverse)` attaches the core packages:
#' \itemize{
#'   \item \pkg{ggseg} — 2D brain atlas plots with `geom_brain()`.
#'   \item \pkg{ggseg3d} — interactive 3D brain atlas widgets.
#'   \item \pkg{ggseg.formats} — atlas data structures and the bundled
#'     `dk()`, `aseg()`, `tracula()`, and `suit()` atlases.
#'   \item \pkg{ggseg.meshes} — additional cortical and cerebellar
#'     surface meshes.
#'   \item \pkg{ggplot2} — the plotting grammar ggseg builds on.
#' }
#'
#' More atlases are available from the ggsegverse r-universe; see
#' [ggseg_atlas_repos()] and [install_ggseg_atlas()]. To build your own
#' atlases, install \pkg{ggseg.extra} separately.
#' @section Options:
#' \describe{
#'   \item{`ggsegverse.quiet`}{Set to `TRUE` to suppress the startup
#'     message when loading ggsegverse. Default is `FALSE`.}
#' }
"_PACKAGE"
