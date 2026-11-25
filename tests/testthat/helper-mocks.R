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

# `deps` is a list parallel to `pkgs`, each a character vector of hard
# dependencies, mirroring the API's `_dependencies`. Omit it to serve a payload
# without that column, which is the fallback path.
local_universe <- function(pkgs, deps = NULL, .env = parent.frame()) {
  repos <- data.frame(
    Package = pkgs,
    Version = "1.0.0",
    Title = pkgs,
    Description = "d",
    License = "MIT",
    URL = "u",
    stringsAsFactors = FALSE
  )
  if (!is.null(deps)) {
    repos[["_dependencies"]] <- lapply(deps, function(d) {
      data.frame(
        package = d,
        version = "*",
        role = rep("Imports", length(d)),
        stringsAsFactors = FALSE
      )
    })
  }
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
