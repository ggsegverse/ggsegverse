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

  it("errors when the r-universe body is not a package table", {
    local_mocked_bindings(
      req_perform = function(...) structure(list(), class = "httr2_response"),
      resp_body_json = function(...) list(),
      .package = "httr2"
    )
    expect_error(ggseg_atlas_repos(), "Could not read the package list")
  })

  it("errors when the r-universe body is missing a column", {
    local_mocked_bindings(
      req_perform = function(...) structure(list(), class = "httr2_response"),
      resp_body_json = function(...) data.frame(Package = "ggsegYeo"),
      .package = "httr2"
    )
    expect_error(ggseg_atlas_repos(), "Could not read the package list")
  })

  it("rejects grep arguments that would change what it returns", {
    local_universe(c("ggsegYeo", "ggsegDKT"))
    expect_error(ggseg_atlas_repos("Yeo", value = TRUE))
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

  it("passes additional arguments to pak", {
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
  it("installs every listed atlas from the r-universe", {
    calls <- new.env(parent = emptyenv())
    local_mocked_bindings(
      ggseg_atlas_repos = function(...) {
        dplyr::tibble(package = c("ggsegA", "ggsegB", "ggsegC"))
      }
    )
    local_mocked_bindings(
      repo_add = function(...) calls$repo <- list(...),
      pak = function(pkg, ...) calls$pak <- pkg,
      .package = "pak"
    )

    install_ggseg_atlas_all()
    expect_identical(calls$pak, c("ggsegA", "ggsegB", "ggsegC"))
    expect_identical(calls$repo$ggsegverse, universe_url())
  })
})

describe("installed_ggseg_atlases()", {
  # These treat two base packages as atlases so that the package list comes
  # from the real library rather than from a fixture that could only agree
  # with itself.
  it("reads the installed atlases from the library, not from the r-universe", {
    local_mocked_bindings(
      is_atlas_package = function(pkg) pkg %in% c("stats", "utils"),
      ggseg_atlas_repos = function(...) {
        dplyr::tibble(package = "utils", version = "9.9.9")
      }
    )

    result <- installed_ggseg_atlases()
    expect_s3_class(result, "tbl_df")
    expect_named(result, c("package", "installed", "available"))
    expect_identical(result$package, c("stats", "utils"))
    expect_identical(
      result$installed,
      c(
        as.character(utils::packageVersion("stats")),
        as.character(utils::packageVersion("utils"))
      )
    )
    expect_identical(result$available, c(NA_character_, "9.9.9"))
  })

  it("still lists local atlases when the r-universe cannot be reached", {
    local_mocked_bindings(
      is_atlas_package = function(pkg) pkg %in% c("stats", "utils"),
      ggseg_atlas_repos = function(...) stop("offline")
    )

    result <- installed_ggseg_atlases()
    expect_identical(result$package, c("stats", "utils"))
    expect_identical(result$available, c(NA_character_, NA_character_))
  })

  it("returns an empty tibble when no atlases are installed", {
    local_mocked_bindings(
      is_atlas_package = function(pkg) rep(FALSE, length(pkg)),
      ggseg_atlas_repos = function(...) stop("offline")
    )

    result <- installed_ggseg_atlases()
    expect_identical(nrow(result), 0L)
    expect_named(result, c("package", "installed", "available"))
  })
})


describe("installed_atlas_packages()", {
  # Both branches below survived mutation: dropping the DESCRIPTION filter and
  # dropping the dedup each left the whole suite green.
  fake_libs <- function(envir = parent.frame()) {
    lib <- withr::local_tempdir(.local_envir = envir)
    dir.create(file.path(lib, "ggsegReal"))
    writeLines(
      c("Package: ggsegReal", "Version: 1.2.3"),
      file.path(lib, "ggsegReal", "DESCRIPTION")
    )
    # A leftover directory with the atlas name shape but no package in it.
    dir.create(file.path(lib, "ggsegLeftover"))
    dir.create(file.path(lib, "notanatlas"))
    lib
  }

  it("ignores a directory with no DESCRIPTION", {
    lib <- fake_libs()

    expect_identical(installed_atlas_packages(lib), "ggsegReal")
  })

  it("reports a package found in two library paths once", {
    lib <- fake_libs()

    expect_identical(installed_atlas_packages(c(lib, lib)), "ggsegReal")
  })
})


describe("atlas detection from the r-universe payload", {
  it("picks atlases by what they declare, not by their name", {
    # `oddlyNamed` builds on ggseg.formats and so is an atlas; `ggsegShaped`
    # has the atlas name shape but declares nothing, so it is not.
    local_universe(
      c("oddlyNamed", "ggsegShaped", "ggsegGlasser"),
      deps = list("ggseg.formats", "stats", c("R", "ggseg.formats"))
    )

    expect_setequal(
      ggseg_atlas_repos()$package,
      c("oddlyNamed", "ggsegGlasser")
    )
  })

  it("excludes our own tooling even though it builds on ggseg.formats", {
    local_universe(
      c("ggseg3d", "ggseg.extra", "ggsegGlasser"),
      deps = list("ggseg.formats", "ggseg.formats", "ggseg.formats")
    )

    expect_identical(ggseg_atlas_repos()$package, "ggsegGlasser")
  })

  it("excludes unrelated packages that share the universe", {
    local_universe(
      c("freesurfer", "wbcmd", "ggsegGlasser"),
      deps = list("utils", "utils", "ggseg.formats")
    )

    expect_identical(ggseg_atlas_repos()$package, "ggsegGlasser")
  })

  it("falls back to the name shape when the payload has no dependencies", {
    # A payload change must degrade, not return an empty list.
    local_universe(c("ggsegGlasser", "freesurfer"))

    expect_identical(ggseg_atlas_repos()$package, "ggsegGlasser")
  })
})
