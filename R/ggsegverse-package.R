#' @keywords internal
"_PACKAGE"

ignore_unused_imports <- function() {
  ggseg.formats::as_brain_atlas
  ggseg::GeomBrain
  ggseg3d::add_glassbrain
  neuromapr::annot_to_gifti
  lifecycle::deprecated
}
