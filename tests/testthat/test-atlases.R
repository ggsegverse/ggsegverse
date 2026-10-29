describe("ggseg_atlas_repos()", {
  it("returns a tibble of atlas metadata", {
    local_universe(c("ggsegYeo", "ggsegDKT"))
    result <- ggseg_atlas_repos()
    expect_s3_class(result, "tbl_df")
    expect_named(
      result,
      c("package", "version", "title", "description", "license", "url")
    )
    expect_identical(result$package, c("ggsegYeo", "ggsegDKT"))
  })

  it("filters by pattern", {
    local_universe(c("ggsegYeo", "ggsegDKT", "ggsegYeo7"))
    expect_identical(
      ggseg_atlas_repos("Yeo")$package,
      c("ggsegYeo", "ggsegYeo7")
    )
  })

  it("excludes core packages and tools hosted on the r-universe", {
    local_universe(c("ggseg", "ggseg.extra", "neuromapr", "ggsegYeo2011"))
    expect_identical(ggseg_atlas_repos()$package, "ggsegYeo2011")
  })

  it("rejects grep-only arguments instead of returning NA rows", {
    local_universe(c("ggsegYeo", "ggsegDKT"))
    expect_error(ggseg_atlas_repos("Yeo", value = TRUE), "value")
  })

  it("passes matching arguments through to grepl", {
    local_universe(c("ggsegYeo", "ggsegDKT"))
    expect_identical(
      ggseg_atlas_repos("yeo", ignore.case = TRUE)$package,
      "ggsegYeo"
    )
  })

  it("warns and returns NULL when the body is not a package index", {
    local_universe_body("<html>captive portal</html>")
    expect_warning(
      result <- ggseg_atlas_repos(),
      "Unexpected response"
    )
    expect_null(result)
  })

  it("warns and returns NULL when expected columns are missing", {
    local_universe_body(data.frame(name = "ggsegYeo"))
    expect_warning(
      result <- ggseg_atlas_repos(),
      "Unexpected response"
    )
    expect_null(result)
  })

  it("warns and returns NULL when the body cannot be parsed", {
    testthat::local_mocked_bindings(
      req_perform = function(...) structure(list(), class = "httr2_response"),
      resp_body_json = function(...) stop("Invalid JSON"),
      .package = "httr2"
    )
    expect_warning(
      result <- ggseg_atlas_repos(),
      "Unexpected response"
    )
    expect_null(result)
  })

  it("warns and returns NULL when the r-universe is unreachable", {
    local_offline_universe()
    expect_warning(
      result <- ggseg_atlas_repos(),
      "Could not reach the ggsegverse r-universe"
    )
    expect_null(result)
  })
})

describe("is_atlas_package()", {
  it("accepts ggseg<Atlas> package names", {
    expect_true(all(is_atlas_package(c("ggsegYeo2011", "ggsegHO", "ggsegAAL"))))
  })

  it("rejects core packages and tools", {
    expect_false(any(is_atlas_package(
      c("ggseg", "ggseg3d", "ggseg.extra", "ggseg.formats", "wbcmd")
    )))
  })
})

describe("install_ggseg_atlas()", {
  it("adds ggsegverse repo and calls pak", {
    skip_if_not_installed("pak")
    pak_calls <- new.env(parent = emptyenv())

    local_mocked_bindings(
      repo_add = function(...) invisible(NULL),
      pak = function(pkg, ...) {
        pak_calls$pkg <- pkg
        invisible(NULL)
      },
      .package = "pak"
    )

    install_ggseg_atlas("ggsegTest")
    expect_identical(pak_calls$pkg, "ggsegTest")
  })

  it("restores the repos option that pak::repo_add() mutates", {
    skip_if_not_installed("pak")
    before <- getOption("repos")
    local_mocked_bindings(
      repo_add = function(...) {
        options(repos = c(mutated = "https://example.com"))
      },
      pak = function(pkg, ...) invisible(NULL),
      .package = "pak"
    )

    install_ggseg_atlas("ggsegTest")
    expect_identical(getOption("repos"), before)
  })

  it("errors without installing when pak is not available", {
    testthat::local_mocked_bindings(
      is_installed = function(...) FALSE,
      .package = "rlang"
    )
    rlang::local_interactive(FALSE)
    expect_error(install_ggseg_atlas("ggsegTest"))
  })

  it("rejects refs that are not atlas packages", {
    expect_error(
      install_ggseg_atlas("url::http://example.com/x.tar.gz"),
      "not an atlas package"
    )
    expect_error(install_ggseg_atlas("ggseg.extra"), "not an atlas package")
    expect_error(install_ggseg_atlas(character()), "character vector")
  })

  it("passes additional arguments to pak", {
    skip_if_not_installed("pak")
    pak_calls <- new.env(parent = emptyenv())

    local_mocked_bindings(
      repo_add = function(...) invisible(NULL),
      pak = function(pkg, ...) {
        pak_calls$pkg <- pkg
        pak_calls$args <- list(...)
        invisible(NULL)
      },
      .package = "pak"
    )

    install_ggseg_atlas("ggsegTest", upgrade = TRUE)
    expect_true("upgrade" %in% names(pak_calls$args))
    expect_true(pak_calls$args$upgrade)
  })
})


describe("install_ggseg_atlas_all()", {
  it("installs every listed atlas when confirmation is waived", {
    skip_if_not_installed("pak")
    calls <- new.env(parent = emptyenv())
    local_atlas_listing(c("ggsegA", "ggsegB", "ggsegC"))
    local_mocked_bindings(
      repo_add = function(...) calls$repo <- list(...),
      pak = function(pkg, ...) calls$pak <- pkg,
      .package = "pak"
    )

    install_ggseg_atlas_all(ask = FALSE)
    expect_identical(calls$pak, c("ggsegA", "ggsegB", "ggsegC"))
    expect_identical(calls$repo$ggsegverse, universe_url())
  })

  it("does not let pak ask again after its own confirmation", {
    skip_if_not_installed("pak")
    calls <- new.env(parent = emptyenv())
    local_atlas_listing("ggsegA")
    rlang::local_interactive(TRUE)
    local_mocked_bindings(confirm_install = function(packages) TRUE)
    local_mocked_bindings(
      repo_add = function(...) invisible(NULL),
      pak = function(pkg, ...) calls$args <- list(...),
      .package = "pak"
    )

    install_ggseg_atlas_all()
    expect_false(calls$args$ask)
  })

  it("installs after the user confirms interactively", {
    skip_if_not_installed("pak")
    calls <- new.env(parent = emptyenv())
    local_atlas_listing(c("ggsegA", "ggsegB"))
    rlang::local_interactive(TRUE)
    local_mocked_bindings(confirm_install = function(packages) TRUE)
    local_mocked_bindings(
      repo_add = function(...) invisible(NULL),
      pak = function(pkg, ...) calls$pak <- pkg,
      .package = "pak"
    )

    install_ggseg_atlas_all()
    expect_identical(calls$pak, c("ggsegA", "ggsegB"))
  })

  it("installs nothing when the user declines", {
    skip_if_not_installed("pak")
    calls <- new.env(parent = emptyenv())
    local_atlas_listing(c("ggsegA", "ggsegB"))
    rlang::local_interactive(TRUE)
    local_mocked_bindings(confirm_install = function(packages) FALSE)
    local_mocked_bindings(
      repo_add = function(...) invisible(NULL),
      pak = function(pkg, ...) calls$pak <- pkg,
      .package = "pak"
    )

    expect_message(install_ggseg_atlas_all(), "Nothing installed")
    expect_null(calls$pak)
  })

  it("refuses to install non-interactively without an explicit opt-in", {
    local_atlas_listing(c("ggsegA", "ggsegB"))
    rlang::local_interactive(FALSE)
    expect_error(install_ggseg_atlas_all(), "needs confirmation")
  })

  it("warns and installs nothing when the r-universe is unreachable", {
    local_offline_universe()
    expect_warning(
      expect_warning(
        result <- install_ggseg_atlas_all(ask = FALSE),
        "Could not reach the ggsegverse r-universe"
      ),
      "No atlas packages found"
    )
    expect_null(result)
  })
})

describe("installed_ggseg_atlases()", {
  it("returns installed atlases with local and available versions", {
    local_mocked_bindings(
      ggseg_atlas_repos = function(...) {
        dplyr::tibble(
          package = c("ggsegYeo2011", "ggsegHO", "ggsegGlasser"),
          version = c("2.0.0", "1.5.0", "1.0.0")
        )
      },
      installed_version = function(pkg) {
        switch(pkg, ggsegYeo2011 = "1.0.0", ggsegHO = "1.5.0", NA_character_)
      }
    )

    result <- installed_ggseg_atlases()
    expect_s3_class(result, "tbl_df")
    expect_named(result, c("package", "installed", "available"))
    expect_identical(result$package, c("ggsegYeo2011", "ggsegHO"))
    expect_identical(result$installed, c("1.0.0", "1.5.0"))
    expect_identical(result$available, c("2.0.0", "1.5.0"))
  })

  it("returns an empty tibble when the r-universe is unreachable", {
    local_offline_universe()
    expect_warning(
      result <- installed_ggseg_atlases(),
      "Could not reach the ggsegverse r-universe"
    )
    expect_identical(nrow(result), 0L)
    expect_named(result, c("package", "installed", "available"))
  })

  it("returns empty tibble when no atlases installed", {
    local_mocked_bindings(
      ggseg_atlas_repos = function(...) {
        dplyr::tibble(
          package = c("ggsegFake1", "ggsegFake2"),
          version = "0.1.0"
        )
      },
      installed_version = function(pkg) NA_character_
    )

    result <- installed_ggseg_atlases()
    expect_identical(nrow(result), 0L)
    expect_named(result, c("package", "installed", "available"))
  })
})
