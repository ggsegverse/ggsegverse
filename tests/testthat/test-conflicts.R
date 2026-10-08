describe("ggsegverse_conflicts()", {
  it("returns ggsegverse_conflicts class", {
    conflicts <- ggsegverse_conflicts()
    expect_s3_class(conflicts, "ggsegverse_conflicts")
  })

  it("returns a list", {
    conflicts <- ggsegverse_conflicts()
    expect_type(conflicts, "list")
  })
})

describe("confirm_conflict()", {
  ggseg_pkgs <- c("package:ggseg", "package:ggseg3d", "package:ggseg.formats")

  it("returns NULL when no ggsegverse package is involved", {
    local_mocked_bindings(pkg_object = function(pkg, name) pkg)
    pkgs <- c("package:stats", "package:base")
    expect_null(confirm_conflict(pkgs, "filter", ggseg_pkgs))
  })

  it("returns NULL when all candidates are the same re-exported object", {
    local_mocked_bindings(pkg_object = function(pkg, name) "shared")
    pkgs <- c("package:ggseg", "package:ggseg3d", "package:ggseg.formats")
    expect_null(confirm_conflict(pkgs, "dk", ggseg_pkgs))
  })

  it("reports a ggseg package masked by an external package", {
    local_mocked_bindings(pkg_object = function(pkg, name) pkg)
    pkgs <- c("package:someother", "package:ggseg")
    expect_equal(
      confirm_conflict(pkgs, "some_fun", ggseg_pkgs),
      list(winner = "package:someother", masked = "package:ggseg")
    )
  })

  it("reports a ggseg package masking an external package", {
    local_mocked_bindings(pkg_object = function(pkg, name) pkg)
    pkgs <- c("package:ggseg", "package:someother")
    expect_equal(
      confirm_conflict(pkgs, "some_fun", ggseg_pkgs),
      list(winner = "package:ggseg", masked = "package:someother")
    )
  })

  it("drops masked packages exporting the identical object", {
    local_mocked_bindings(
      pkg_object = function(pkg, name) {
        if (pkg == "package:someother") "different" else "shared"
      }
    )
    pkgs <- c("package:ggseg", "package:ggseg.formats", "package:someother")
    expect_equal(
      confirm_conflict(pkgs, "dk", ggseg_pkgs)$masked,
      "package:someother"
    )
  })
})

describe("by_search_order()", {
  it("puts the package earliest on the search path first", {
    attached <- grep("^package:", search(), value = TRUE)
    expect_equal(by_search_order(rev(attached)), attached)
  })

  it("keeps the search-path winner first regardless of input order", {
    expect_equal(
      by_search_order(c("package:base", "package:stats")),
      c("package:stats", "package:base")
    )
  })
})

describe("pkg_object()", {
  it("returns the object exported from an attached package", {
    expect_identical(pkg_object("package:stats", "median"), stats::median)
  })

  it("returns NULL for a name the package does not export", {
    expect_null(pkg_object("package:stats", "zzz_not_a_function"))
  })
})

describe("ls_env()", {
  it("returns exports for a valid package", {
    exports <- ls_env("package:stats")
    expect_type(exports, "character")
    expect_true(length(exports) > 0)
  })

  it("returns empty character for invalid package", {
    result <- ls_env("package:zzz_nonexistent_pkg_999")
    expect_equal(result, character())
  })
})

describe("format.ggsegverse_conflicts()", {
  it("returns empty string when no conflicts", {
    conflicts <- structure(list(), class = "ggsegverse_conflicts")
    expect_equal(format(conflicts), "")
  })

  it("names the masking and masked packages", {
    conflicts <- structure(
      list(
        some_fun = list(
          winner = "package:someother",
          masked = c("package:ggseg", "package:ggseg3d")
        )
      ),
      class = "ggsegverse_conflicts"
    )
    result <- cli::ansi_strip(format(conflicts))
    expect_match(result, "Conflicts")
    expect_match(
      result,
      "someother::some_fun masks ggseg::some_fun, ggseg3d::some_fun",
      fixed = TRUE
    )
    expect_match(result, "conflicted package", fixed = TRUE)
  })
})

describe("print.ggsegverse_conflicts()", {
  it("prints message when no conflicts", {
    conflicts <- structure(list(), class = "ggsegverse_conflicts")
    expect_snapshot(print(conflicts))
  })

  it("returns object invisibly", {
    conflicts <- structure(list(), class = "ggsegverse_conflicts")
    expect_invisible(
      withCallingHandlers(
        print(conflicts),
        message = function(m) invokeRestart("muffleMessage")
      )
    )
  })

  it("prints conflict details when conflicts exist", {
    conflicts <- structure(
      list(filter = list(winner = "package:ggseg", masked = "package:stats")),
      class = "ggsegverse_conflicts"
    )
    expect_snapshot(print(conflicts))
  })
})
