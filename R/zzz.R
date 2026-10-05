# nocov start
.onAttach <- function(...) {
  ggsegverse_attach()
  if (is_loading_for_tests()) {
    return()
  }
  if (isTRUE(getOption("ggsegverse.quiet"))) {
    return()
  }

  inform_startup(ggsegverse_attach_message())
  conflicts <- ggsegverse_conflicts()
  if (length(conflicts) > 0) inform_startup(format(conflicts))
}
# nocov end

is_loading_for_tests <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}
