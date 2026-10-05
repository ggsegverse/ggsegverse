describe("ggseg_atlas_repos()", {
  it("returns a tibble of atlas metadata", {
    local_universe(c("ggsegYeo", "ggsegDKT"))
    result <- ggseg_atlas_repos()
    expect_s3_class(result, "tbl_df")
    expect_named(
      result,
      c("package", "version", "title", "description", "license", "url")
    )
    expect_equal(result$package, c("ggsegYeo", "ggsegDKT"))
  })

  it("filters by pattern", {
    local_universe(c("ggsegYeo", "ggsegDKT", "ggsegYeo7"))
    expect_equal(ggseg_atlas_repos("Yeo")$package, c("ggsegYeo", "ggsegYeo7"))
  })

  it("excludes core packages and tools hosted on the r-universe", {
    local_universe(c("ggseg", "ggseg.extra", "neuromapr", "ggsegYeo2011"))
    expect_equal(ggseg_atlas_repos()$package, "ggsegYeo2011")
  })

  it("errors with a clear message when the r-universe is unreachable", {
    local_mocked_bindings(
      req_perform = function(...) stop("Could not resolve host"),
      .package = "httr2"
    )
    expect_error(
      ggseg_atlas_repos(),
      "Could not reach the ggsegverse r-universe"
    )
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
    pak_calls <- NULL

    local_mocked_bindings(
      repo_add = function(...) invisible(NULL),
      pak = function(pkg, ...) {
        pak_calls <<- list(pkg = pkg)
        invisible(NULL)
      },
      .package = "pak"
    )

    install_ggseg_atlas("ggsegTest")
    expect_equal(pak_calls$pkg, "ggsegTest")
  })

  it("passes additional arguments to pak", {
    pak_calls <- NULL

    local_mocked_bindings(
      repo_add = function(...) invisible(NULL),
      pak = function(pkg, ...) {
        pak_calls <<- list(pkg = pkg, args = list(...))
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
  it("installs every listed atlas from the r-universe", {
    pak_calls <- NULL
    repo_calls <- NULL
    local_mocked_bindings(
      ggseg_atlas_repos = function(...) {
        dplyr::tibble(package = c("ggsegA", "ggsegB", "ggsegC"))
      }
    )
    local_mocked_bindings(
      repo_add = function(...) repo_calls <<- list(...),
      pak = function(pkg, ...) pak_calls <<- pkg,
      .package = "pak"
    )

    install_ggseg_atlas_all()
    expect_equal(pak_calls, c("ggsegA", "ggsegB", "ggsegC"))
    expect_equal(repo_calls$ggsegverse, universe_url())
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
    expect_equal(result$package, c("ggsegYeo2011", "ggsegHO"))
    expect_equal(result$installed, c("1.0.0", "1.5.0"))
    expect_equal(result$available, c("2.0.0", "1.5.0"))
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
    expect_equal(nrow(result), 0)
    expect_named(result, c("package", "installed", "available"))
  })
})
