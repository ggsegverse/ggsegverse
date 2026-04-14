#' List all ggsegverse packages
#'
#' @param include_self Whether to include ggsegverse itself in the list.
#' @return A character vector of package names.
#' @export
ggsegverse_packages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("ggsegverse")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  parsed <- gsub("\\s*\\(.*\\)", "", parsed)
  core <- parsed[parsed %in% core_packages()]
  if (include_self) {
    core <- c(core, "ggsegverse")
  }
  core
}

core_packages <- function() {
  c("ggseg.formats", "ggseg", "ggseg3d", "neuromapr")
}

inform_startup <- function(...) {
  if (is_loading_for_tests()) return(invisible())
  rlang::inform(paste0(...), class = "packageStartupMessage")
}

invert <- function(x) {
  if (length(x) == 0) return(list())
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}
