core_unloaded <- function() {
  search <- paste0("package:", core_packages())
  core_packages()[!search %in% search()]
}

same_library <- function(pkg) {
  if (length(find.package(pkg, quiet = TRUE)) == 0) {
    return(invisible(FALSE))
  }
  loc <- if (pkg %in% loadedNamespaces()) dirname(getNamespaceInfo(pkg, "path"))
  library(
    pkg,
    lib.loc = loc,
    character.only = TRUE,
    warn.conflicts = FALSE,
    quietly = TRUE
  )
  invisible(TRUE)
}

ggsegverse_attach <- function() {
  to_load <- core_unloaded()
  if (length(to_load) == 0) {
    return(invisible())
  }

  suppressPackageStartupMessages(
    lapply(to_load, same_library)
  )

  invisible()
}

ggsegverse_attach_message <- function() {
  pkgs <- ggsegverse_packages(include_self = FALSE)
  header <- cli::rule(
    left = cli::style_bold("ggsegverse"),
    right = utils::packageVersion("ggsegverse")
  )

  half <- ceiling(length(pkgs) / 2)
  col1 <- vapply(pkgs[seq_len(half)], format_package_line, character(1))
  col2 <- vapply(pkgs[-seq_len(half)], format_package_line, character(1))
  col2 <- c(col2, rep("", half - length(col2)))

  info <- trimws(
    paste0(
      cli::ansi_align(col1, width = max(cli::ansi_nchar(col1))),
      " ",
      col2
    ),
    which = "right"
  )

  paste0(header, "\n", paste(info, collapse = "\n"))
}

package_version_string <- function(pkg) {
  v <- installed_version(pkg)
  if (is.na(v)) "[not installed]" else v
}

format_package_line <- function(pkg) {
  v <- package_version_string(pkg)
  mark <- if (v == "[not installed]") {
    cli::col_red(cli::symbol$cross)
  } else {
    cli::col_green(cli::symbol$tick)
  }
  paste0(mark, " ", cli::col_blue(pkg), " ", v)
}
