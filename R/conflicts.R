#' Conflicts between ggsegverse packages and other loaded packages
#'
#' Lists objects exported by a core ggsegverse package that mask, or are
#' masked by, an object of the same name in another attached package.
#' Re-exports of the identical object (for example `ggseg::dk()`
#' re-exporting `ggseg.formats::dk()`) are not conflicts and are not
#' reported.
#'
#' Conflicts are shown when ggsegverse is attached. To make every
#' ambiguous call an error instead, use the conflicted package.
#'
#' @return A `ggsegverse_conflicts` object: a named list, one element per
#'   conflicting name, each holding the `winner` package and the `masked`
#'   packages.
#' @export
#' @examples
#' ggsegverse_conflicts()
ggsegverse_conflicts <- function() {
  envs <- grep("^package:", search(), value = TRUE)
  names(envs) <- envs
  objs <- invert(lapply(envs, ls_env))

  ggseg_pkgs <- paste0("package:", ggsegverse_packages())
  candidates <- Filter(
    function(x) length(x) > 1 && any(x %in% ggseg_pkgs),
    objs
  )

  conflicts <- Map(
    confirm_conflict,
    candidates,
    names(candidates),
    MoreArgs = list(ggseg_pkgs = ggseg_pkgs)
  )
  conflicts <- Filter(Negate(is.null), conflicts)

  structure(conflicts, class = "ggsegverse_conflicts")
}

confirm_conflict <- function(pkgs, name, ggseg_pkgs) {
  winner <- pkgs[[1]]
  winner_obj <- pkg_object(winner, name)
  masked <- Filter(
    function(pkg) !identical(pkg_object(pkg, name), winner_obj),
    pkgs[-1]
  )
  if (length(masked) == 0) {
    return(NULL)
  }

  if (!any(c(winner, masked) %in% ggseg_pkgs)) {
    return(NULL)
  }

  list(winner = winner, masked = masked)
}

pkg_object <- function(pkg, name) {
  get0(name, envir = as.environment(pkg), inherits = FALSE)
}

ls_env <- function(env) {
  tryCatch(
    {
      x <- .getNamespaceInfo(asNamespace(gsub("package:", "", env)), "exports")
      if (inherits(x, "environment")) ls(x) else character()
    },
    error = function(e) character()
  )
}

#' @export
print.ggsegverse_conflicts <- function(x, ...) {
  if (length(x) == 0) {
    cli::cli_inform("No conflicts detected.")
  } else {
    rlang::inform(format(x))
  }
  invisible(x)
}

#' @export
format.ggsegverse_conflicts <- function(x, ...) {
  if (length(x) == 0) {
    return("")
  }

  header <- cli::rule(
    left = cli::style_bold("Conflicts"),
    right = "ggsegverse_conflicts()"
  )
  bullets <- unlist(Map(format_conflict, x, names(x)), use.names = FALSE)
  hint <- paste0(
    cli::col_cyan(cli::symbol$info),
    " Use the conflicted package to force all conflicts to become errors"
  )
  paste(c(header, bullets, hint), collapse = "\n")
}

format_conflict <- function(conflict, name) {
  qualify <- function(pkg) {
    paste0(cli::col_blue(sub("^package:", "", pkg)), "::", name)
  }
  paste0(
    cli::col_red(cli::symbol$cross),
    " ",
    qualify(conflict$winner),
    " masks ",
    paste(vapply(conflict$masked, qualify, character(1)), collapse = ", ")
  )
}
