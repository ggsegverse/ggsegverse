#' List the core ggsegverse packages
#'
#' The packages attached by `library(ggsegverse)`: ggseg.formats, ggseg,
#' ggseg3d, ggseg.meshes, and ggplot2. Atlas packages and the
#' atlas-building toolkit ggseg.extra are not core packages; see
#' [ggseg_atlas_repos()] for atlases.
#'
#' @param include_self Whether to include ggsegverse itself in the list.
#' @return A character vector of package names.
#' @export
#' @examples
#' ggsegverse_packages()
ggsegverse_packages <- function(include_self = FALSE) {
  c(core_packages(), if (include_self) "ggsegverse")
}

core_packages <- function() {
  names(core_package_sources())
}

core_package_sources <- function() {
  c(
    ggseg.formats = "ggsegverse",
    ggseg = "ggsegverse",
    ggseg3d = "ggsegverse",
    ggseg.meshes = "ggsegverse",
    ggplot2 = "cran"
  )
}

installed_version <- function(pkg) {
  tryCatch(
    as.character(utils::packageVersion(pkg)),
    error = function(e) NA_character_
  )
}

# nocov start
inform_startup <- function(...) {
  if (is_loading_for_tests()) {
    return(invisible())
  }
  rlang::inform(paste0(...), class = "packageStartupMessage")
}
# nocov end

invert <- function(x) {
  if (length(x) == 0) {
    return(list())
  }
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}
