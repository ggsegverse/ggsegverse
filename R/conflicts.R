#' Conflicts between ggsegverse packages and other loaded packages
#'
#' Lists all function name conflicts between ggsegverse packages and
#' other loaded packages.
#'
#' @return A `ggsegverse_conflicts` object (invisibly).
#' @export
ggsegverse_conflicts <- function() {
  envs <- grep("^package:", search(), value = TRUE)
  names(envs) <- envs
  objs <- invert(lapply(envs, ls_env))

  ggseg_pkgs <- paste0("package:", ggsegverse_packages())
  conflicts <- Filter(
    function(x) length(x) > 1 && any(x %in% ggseg_pkgs),
    objs
  )

  conflict_funs <- Map(confirm_conflict, conflicts, names(conflicts))
  conflict_funs <- Filter(Negate(is.null), conflict_funs)

  structure(conflict_funs, class = "ggsegverse_conflicts")
}

confirm_conflict <- function(pkgs, name) {
  dominated <- pkgs[pkgs != pkgs[[1]]]
  ggseg_pkgs <- paste0("package:", ggsegverse_packages())

  dominated_ggseg <- dominated[dominated %in% ggseg_pkgs]
  if (length(dominated_ggseg) == 0) {
    return(NULL)
  }

  winner <- pkgs[[1]]
  all_internal <- winner %in% ggseg_pkgs && all(dominated_ggseg == dominated)
  if (all_internal && winner == "package:ggseg.formats") {
    return(NULL)
  }

  dominated_ggseg
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
    return(invisible(x))
  }

  header <- cli::rule(
    left = cli::style_bold("Conflicts"),
    right = "ggsegverse_conflicts()"
  )
  cli::cli_inform(header)
  Map(
    function(pkgs, name) {
      search_pkgs <- grep("^package:", search(), value = TRUE)
      winner <- setdiff(
        Filter(function(p) name %in% ls_env(p), search_pkgs),
        pkgs
      )[[1]]
      loser <- pkgs[[1]]
      cli::cli_inform(
        "{cli::col_red(cli::symbol$cross)} {name}: {loser} masks {winner}"
      )
    },
    x,
    names(x)
  )

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
  bullets <- Map(
    function(pkgs, name) {
      paste0(
        cli::col_red(cli::symbol$cross),
        " ",
        name,
        ": ",
        pkgs[[1]],
        " masks another package"
      )
    },
    x,
    names(x)
  )
  paste(c(header, unlist(bullets)), collapse = "\n")
}
