#' Update ggsegverse packages
#'
#' Checks the core ggsegverse packages for newer versions and prints the
#' `pak::pak()` call that updates them. Nothing is installed
#' automatically.
#'
#' @return The rows of [ggsegverse_deps()] that are out of date
#'   (invisibly), or `NULL` invisibly when everything is current.
#' @family diagnostics
#' @seealso [ggsegverse_sitrep()] for a full overview.
#' @export
#' @examples
#' \dontrun{
#' ggsegverse_update()
#' #> -- The following packages are out of date: --
#' #> * ggseg (2.2.1 -> 2.3.0)
#' #> Update with:
#' #> pak::pak(c('ggseg'))
#' }
ggsegverse_update <- function() {
  deps <- ggsegverse_deps()
  behind <- deps[deps$behind, ]

  if (nrow(behind) == 0) {
    cli::cli_alert_success("All ggsegverse packages are up to date.")
    return(invisible())
  }

  cli::cli_h2("The following packages are out of date:")
  cli::cli_ul(paste0(
    behind$package,
    " (",
    behind$local,
    " -> ",
    behind$available,
    ")"
  ))
  cli::cli_text("")

  pkgs_fmt <- paste0("'", pak_ref(behind$package), "'", collapse = ", ")
  cli::cli_text("Update with:")
  cli::cli_code(paste0("pak::pak(c(", pkgs_fmt, "))"))

  invisible(behind)
}

#' List ggsegverse package dependencies and versions
#'
#' Compares the installed version of each core package with the latest
#' version released on CRAN. Requires an internet connection; versions
#' that cannot be retrieved are `NA`.
#'
#' @return A data frame with columns `package`, `local` (installed
#'   version, `NA` if not installed), `available` (latest version, `NA`
#'   if it could not be retrieved), and `behind` (logical).
#' @family diagnostics
#' @export
#' @examples
#' \dontrun{
#' ggsegverse_deps()
#' #>         package local available behind
#' #> 1 ggseg.formats  1.0.0     1.0.0  FALSE
#' #> 2         ggseg  2.2.1     2.3.0   TRUE
#' }
ggsegverse_deps <- function() {
  pkgs <- core_packages()

  local_version <- vapply(
    pkgs,
    installed_version,
    character(1),
    USE.NAMES = FALSE
  )
  available_version <- remote_versions(pkgs)

  data.frame(
    package = pkgs,
    local = local_version,
    available = available_version,
    behind = is_behind(local_version, available_version),
    stringsAsFactors = FALSE,
    row.names = NULL
  )
}

#' Situation report for ggsegverse
#'
#' Prints the installed version of each core package, flags packages that
#' are missing or out of date, and reports the running R version. Useful
#' to include when reporting a bug.
#'
#' @return The data frame from [ggsegverse_deps()], invisibly.
#' @family diagnostics
#' @seealso [ggsegverse_update()] to get the update command.
#' @export
#' @examples
#' \dontrun{
#' ggsegverse_sitrep()
#' #> -- ggsegverse situation report --
#' #> -- Installed packages --
#' #> v ggseg.formats: 1.0.0
#' #> ! ggseg: 2.2.1 (update available: 2.3.0)
#' #> x ggseg3d: not installed
#' #> -- R version --
#' #> R version 4.5.1 (2025-06-13)
#' }
ggsegverse_sitrep <- function() {
  cli::cli_h1("ggsegverse situation report")

  deps <- ggsegverse_deps()

  cli::cli_h2("Installed packages")
  Map(
    function(package, local, available, behind) {
      if (is.na(local)) {
        cli::cli_alert_danger("{package}: not installed")
      } else if (behind) {
        cli::cli_alert_warning(
          "{package}: {local} (update available: {available})"
        )
      } else {
        cli::cli_alert_success("{package}: {local}")
      }
    },
    deps$package,
    deps$local,
    deps$available,
    deps$behind
  )

  cli::cli_h2("R version")
  cli::cli_text("{r_version_string()}")

  invisible(deps)
}

is_behind <- function(local, available) {
  known <- !is.na(local) & !is.na(available)
  behind <- rep(FALSE, length(local))
  behind[known] <- package_version(local[known]) <
    package_version(available[known])
  behind
}

remote_versions <- function(pkgs) {
  reqs <- lapply(pkgs, function(pkg) {
    httr2::request(description_url(pkg)) |>
      httr2::req_user_agent(ggsegverse_user_agent()) |>
      httr2::req_timeout(10)
  })
  resps <- httr2::req_perform_parallel(
    reqs,
    on_error = "continue",
    progress = FALSE
  )
  vapply(resps, parse_remote_version, character(1))
}

parse_remote_version <- function(resp) {
  if (!inherits(resp, "httr2_response")) {
    return(NA_character_)
  }
  con <- textConnection(httr2::resp_body_string(resp))
  on.exit(close(con))
  tryCatch(
    read.dcf(con, fields = "Version")[[1, "Version"]],
    error = function(e) NA_character_
  )
}

r_version_string <- function() {
  R.version.string
}

pak_ref <- function(pkg) {
  from_cran <- core_package_sources()[pkg] == "cran"
  unname(ifelse(from_cran, pkg, paste0("ggsegverse/", pkg)))
}

description_url <- function(pkg) {
  switch(
    core_package_sources()[[pkg]],
    cran = paste0(
      "https://cran.r-project.org/web/packages/",
      pkg,
      "/DESCRIPTION"
    ),
    ggsegverse = paste0(
      "https://raw.githubusercontent.com/ggsegverse/",
      pkg,
      "/main/DESCRIPTION"
    )
  )
}
