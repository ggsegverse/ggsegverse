#' List available ggseg atlas packages
#'
#' Query the ggsegverse r-universe to see which atlas packages are available
#' for installation. Returns package metadata including name, version,
#' and description.
#'
#' Only atlas packages are listed: those following the `ggseg<Atlas>`
#' naming convention (e.g. `ggsegYeo2011`, `ggsegSchaefer`). Core
#' packages and tools hosted on the same r-universe, such as `ggseg`,
#' `ggseg3d`, or the atlas-building toolkit `ggseg.extra`, are excluded.
#'
#' @param pattern Optional regex to filter packages by name (e.g., `"yeo"`
#'   to find Yeo atlas packages).
#' @param ... Additional arguments passed to [base::grep()].
#'
#' @return A tibble of available atlas packages.
#' @seealso [install_ggseg_atlas()] to install a specific atlas
#' @export
#' @importFrom dplyr as_tibble
#' @examples
#' \dontrun{
#' # See all available atlases
#' ggseg_atlas_repos()
#'
#' # Find Yeo parcellation atlases
#' ggseg_atlas_repos("yeo")
#' }
ggseg_atlas_repos <- function(pattern = NULL, ...) {
  api_url <- paste0(universe_url(), "/api/packages")
  resp <- tryCatch(
    httr2::request(api_url) |>
      httr2::req_timeout(30) |>
      httr2::req_perform(),
    error = function(e) {
      cli::cli_abort(
        "Could not reach the ggsegverse r-universe at {.url {api_url}}.",
        parent = e
      )
    }
  )
  repos <- httr2::resp_body_json(resp, simplifyVector = TRUE)
  repos <- repos[is_atlas_package(repos$Package), ]

  if (!is.null(pattern)) {
    idx <- grep(pattern, repos$Package, ...)
    repos <- repos[idx, ]
  }

  repos <- as_tibble(repos)
  repos <- repos[, c(
    "Package",
    "Version",
    "Title",
    "Description",
    "License",
    "URL"
  )]
  names(repos) <- tolower(names(repos))
  repos
}

universe_url <- function() {
  "https://ggsegverse.r-universe.dev"
}

is_atlas_package <- function(pkg) {
  grepl("^ggseg[A-Z]", pkg)
}


#' Install a ggseg atlas package
#'
#' Install an atlas package from the ggsegverse r-universe. This is the
#' easiest way to get pre-built atlases like Yeo, Schaefer, Glasser, etc.
#' The r-universe is added to pak's repositories for the session, so
#' dependencies from the ecosystem resolve too.
#'
#' @param package Package name (e.g., `"ggsegYeo2011"`, `"ggsegSchaefer"`).
#'   Use [ggseg_atlas_repos()] to see available packages.
#' @param ... Additional arguments passed to [pak::pak()].
#'
#' @seealso [ggseg_atlas_repos()] to list available atlases
#' @export
#' @return Called for its side effect of installing the package; returns
#'   the value of [pak::pak()] invisibly.
#' @examples
#' \dontrun{
#' # Find available Yeo atlases
#' ggseg_atlas_repos("yeo")
#'
#' # Install one
#' install_ggseg_atlas("ggsegYeo2011")
#' }
install_ggseg_atlas <- function(package, ...) {
  pak::repo_add(ggsegverse = universe_url())
  pak::pak(package, ...)
}


#' Install all available ggseg atlas packages
#'
#' Downloads and installs every atlas package listed by
#' [ggseg_atlas_repos()].
#' This will take a while and use substantial disk space. For most users,
#' installing individual atlases with [install_ggseg_atlas()] is more
#' practical.
#'
#' @param ... Additional arguments passed to [pak::pak()].
#'
#' @seealso [install_ggseg_atlas()] to install specific atlases
#' @export
#' @return Called for its side effect of installing the packages; returns
#'   the value of [pak::pak()] invisibly.
#' @examples
#' \dontrun{
#' # Install everything (slow, large download)
#' install_ggseg_atlas_all()
#' }
install_ggseg_atlas_all <- function(...) {
  install_ggseg_atlas(ggseg_atlas_repos()$package, ...)
}


#' List installed ggseg atlas packages
#'
#' Check which ggseg atlas packages from the ggsegverse r-universe are
#' currently installed on your system, and how their versions compare to
#' what is available.
#'
#' @return A tibble with one row per installed atlas package and columns
#'   `package`, `installed` (local version), and `available` (version on
#'   the r-universe).
#' @seealso [ggseg_atlas_repos()] to list all available atlases,
#'   [install_ggseg_atlas()] to install one
#' @export
#' @examples
#' \dontrun{
#' installed_ggseg_atlases()
#' }
installed_ggseg_atlases <- function() {
  available <- ggseg_atlas_repos()
  installed <- vapply(
    available$package,
    installed_version,
    character(1),
    USE.NAMES = FALSE
  )
  found <- !is.na(installed)
  dplyr::tibble(
    package = available$package[found],
    installed = installed[found],
    available = available$version[found]
  )
}
