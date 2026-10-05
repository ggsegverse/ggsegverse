local_deps <- function(
  package = "ggseg",
  local = "1.0.0",
  available = "1.0.0",
  behind = FALSE,
  .env = parent.frame()
) {
  deps <- data.frame(
    package = package,
    local = local,
    available = available,
    behind = behind,
    stringsAsFactors = FALSE
  )
  testthat::local_mocked_bindings(
    ggsegverse_deps = function() deps,
    .env = .env
  )
}

local_universe <- function(pkgs, .env = parent.frame()) {
  repos <- data.frame(
    Package = pkgs,
    Version = "1.0.0",
    Title = pkgs,
    Description = "d",
    License = "MIT",
    URL = "u",
    stringsAsFactors = FALSE
  )
  testthat::local_mocked_bindings(
    req_perform = function(...) structure(list(), class = "httr2_response"),
    resp_body_json = function(...) repos,
    .package = "httr2",
    .env = .env
  )
}

fake_response <- function(body) {
  structure(list(body = body), class = "httr2_response")
}

local_offline_universe <- function(.env = parent.frame()) {
  testthat::local_mocked_bindings(
    req_perform = function(...) stop("Could not resolve host"),
    .package = "httr2",
    .env = .env
  )
}

local_atlas_listing <- function(pkgs, .env = parent.frame()) {
  testthat::local_mocked_bindings(
    ggseg_atlas_repos = function(...) dplyr::tibble(package = pkgs),
    .env = .env
  )
}
