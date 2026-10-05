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
  it("returns NULL when no ggsegverse package is dominated", {
    pkgs <- c("package:stats", "package:base")
    expect_null(confirm_conflict(pkgs, "filter"))
  })

  it("returns NULL for internal conflicts where ggseg.formats wins", {
    pkgs <- c("package:ggseg.formats", "package:ggseg3d")
    expect_null(confirm_conflict(pkgs, "dk"))
  })

  it("returns dominated ggseg packages when external package wins", {
    pkgs <- c("package:someother", "package:ggseg")
    result <- confirm_conflict(pkgs, "some_fun")
    expect_equal(result, "package:ggseg")
  })

  it("returns dominated ggseg packages for internal conflict without ggseg.formats winning", {
    pkgs <- c("package:ggseg3d", "package:ggseg.formats")
    result <- confirm_conflict(pkgs, "dk")
    expect_equal(result, "package:ggseg.formats")
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

  it("formats conflict list with header and bullets", {
    conflicts <- structure(
      list(some_fun = "package:ggseg"),
      class = "ggsegverse_conflicts"
    )
    result <- format(conflicts)
    expect_match(result, "Conflicts")
    expect_match(result, "some_fun")
    expect_match(result, "masks another package")
  })
})

describe("print.ggsegverse_conflicts()", {
  it("prints message when no conflicts", {
    conflicts <- structure(list(), class = "ggsegverse_conflicts")
    expect_snapshot(print(conflicts))
  })

  it("returns object invisibly when no conflicts", {
    conflicts <- structure(list(), class = "ggsegverse_conflicts")
    result <- withCallingHandlers(
      print(conflicts),
      message = function(m) invokeRestart("muffleMessage")
    )
    expect_s3_class(result, "ggsegverse_conflicts")
  })

  it("prints conflict details when conflicts exist", {
    local_mocked_bindings(
      ls_env = function(env) {
        if (env == "package:ggseg") "filter" else character()
      }
    )
    conflicts <- structure(
      list(filter = "package:ggseg3d"),
      class = "ggsegverse_conflicts"
    )
    expect_snapshot(print(conflicts))
  })
})
