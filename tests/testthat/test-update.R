describe("ggsegverse_deps()", {
  it("returns one row per core package with the expected columns", {
    local_mocked_bindings(remote_versions = function(pkgs) {
      rep("99.0.0", length(pkgs))
    })
    deps <- ggsegverse_deps()
    expect_s3_class(deps, "data.frame")
    expect_named(deps, c("package", "local", "available", "behind"))
    expect_equal(deps$package, core_packages())
    expect_type(deps$behind, "logical")
  })

  it("handles failed remote version lookup", {
    local_mocked_bindings(remote_versions = function(pkgs) {
      rep(NA_character_, length(pkgs))
    })
    deps <- ggsegverse_deps()
    expect_true(all(is.na(deps$available)))
    expect_false(any(deps$behind))
  })
})

describe("is_behind()", {
  it("flags older local versions", {
    expect_true(is_behind("0.1.0", "0.2.0"))
  })

  it("does not flag equal or newer local versions", {
    expect_equal(
      is_behind(c("1.0.0", "2.0.0"), c("1.0.0", "1.5.0")),
      c(FALSE, FALSE)
    )
  })

  it("is FALSE when either version is unknown", {
    expect_equal(
      is_behind(c(NA, "1.0.0", NA), c("1.0.0", NA, NA)),
      c(FALSE, FALSE, FALSE)
    )
  })
})

describe("remote_versions()", {
  it("requests every package in parallel with a timeout", {
    seen <- NULL
    local_mocked_bindings(
      req_perform_parallel = function(reqs, ...) {
        seen <<- reqs
        list(
          fake_response("Version: 1.0.0\n"),
          structure(class = c("error", "condition"), list(message = "404"))
        )
      },
      resp_body_string = function(resp, ...) resp$body,
      .package = "httr2"
    )
    result <- remote_versions(c("ggseg", "ggplot2"))
    expect_equal(result, c("1.0.0", NA_character_))
    expect_equal(
      vapply(seen, function(req) req$url, character(1)),
      c(description_url("ggseg"), description_url("ggplot2"))
    )
    expect_false(is.null(seen[[1]]$options$timeout_ms))
  })
})

describe("parse_remote_version()", {
  it("reads the Version field from a DESCRIPTION response", {
    local_mocked_bindings(
      resp_body_string = function(resp, ...) resp$body,
      .package = "httr2"
    )
    resp <- fake_response("Package: ggseg\nTitle: Plotting\nVersion: 2.3.0\n")
    expect_equal(parse_remote_version(resp), "2.3.0")
  })

  it("returns NA for a failed request", {
    err <- structure(class = c("error", "condition"), list(message = "offline"))
    expect_identical(parse_remote_version(err), NA_character_)
  })

  it("returns NA when the body has no Version field", {
    local_mocked_bindings(
      resp_body_string = function(resp, ...) resp$body,
      .package = "httr2"
    )
    expect_identical(
      parse_remote_version(fake_response("<html>rate limited</html>\n")),
      NA_character_
    )
  })
})

describe("ggsegverse_sitrep()", {
  it("returns deps invisibly", {
    local_deps()
    result <- withCallingHandlers(
      ggsegverse_sitrep(),
      message = function(m) invokeRestart("muffleMessage")
    )
    expect_s3_class(result, "data.frame")
  })

  it("reports not installed packages", {
    local_mocked_bindings(
      r_version_string = function() "R version 4.5.0 (2025-04-11)"
    )
    local_deps(package = "zzz_not_real_pkg", local = NA_character_)
    expect_snapshot(ggsegverse_sitrep())
  })

  it("reports outdated packages", {
    local_mocked_bindings(
      r_version_string = function() "R version 4.5.0 (2025-04-11)"
    )
    local_deps(local = "0.1.0", available = "99.0.0", behind = TRUE)
    expect_snapshot(ggsegverse_sitrep())
  })

  it("reports up to date packages", {
    local_mocked_bindings(
      r_version_string = function() "R version 4.5.0 (2025-04-11)"
    )
    local_deps()
    expect_snapshot(ggsegverse_sitrep())
  })
})

describe("ggsegverse_update()", {
  it("reports all up to date when no packages behind", {
    local_deps()
    expect_snapshot(ggsegverse_update())
  })

  it("reports outdated packages", {
    local_deps(local = "0.1.0", behind = TRUE)
    expect_snapshot(ggsegverse_update())
  })

  it("returns behind packages invisibly", {
    local_deps(local = "0.1.0", behind = TRUE)
    result <- withCallingHandlers(
      ggsegverse_update(),
      message = function(m) invokeRestart("muffleMessage")
    )
    expect_s3_class(result, "data.frame")
    expect_equal(result$package, "ggseg")
  })

  it("suggests a pak call for several packages at once", {
    local_deps(
      package = c("ggseg", "ggplot2"),
      local = c("0.1.0", "3.5.0"),
      available = c("1.0.0", "4.0.0"),
      behind = c(TRUE, TRUE)
    )
    expect_snapshot(ggsegverse_update())
  })
})

describe("core_package_sources()", {
  it("classifies every released core package as CRAN", {
    expect_equal(
      unname(core_package_sources()[c("ggseg", "ggseg.formats", "ggseg3d")]),
      c("cran", "cran", "cran")
    )
  })
})

describe("pak_ref()", {
  it("leaves CRAN packages unprefixed", {
    expect_equal(pak_ref(c("ggseg", "ggplot2")), c("ggseg", "ggplot2"))
  })

  it("prefixes packages that are not on CRAN with the GitHub org", {
    local_sources(c(ggsegFuture = "ggsegverse", ggplot2 = "cran"))
    expect_equal(
      pak_ref(c("ggsegFuture", "ggplot2")),
      c("ggsegverse/ggsegFuture", "ggplot2")
    )
  })
})

describe("description_url()", {
  it("points released core packages at CRAN", {
    expect_equal(
      description_url("ggseg"),
      "https://cran.r-project.org/web/packages/ggseg/DESCRIPTION"
    )
    expect_equal(
      description_url("ggplot2"),
      "https://cran.r-project.org/web/packages/ggplot2/DESCRIPTION"
    )
  })

  it("points packages that are not on CRAN at GitHub main", {
    local_sources(c(ggsegFuture = "ggsegverse"))
    expect_equal(
      description_url("ggsegFuture"),
      paste0(
        "https://raw.githubusercontent.com/ggsegverse/",
        "ggsegFuture/main/DESCRIPTION"
      )
    )
  })
})

describe("r_version_string()", {
  it("returns the running R version string", {
    expect_equal(r_version_string(), R.version.string)
  })
})
