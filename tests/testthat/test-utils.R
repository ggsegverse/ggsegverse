describe("ggsegverse_packages", {
  it("returns core package names", {
    pkgs <- ggsegverse_packages(include_self = FALSE)
    expect_true("ggseg" %in% pkgs)
    expect_true("ggseg3d" %in% pkgs)
    expect_true("ggseg.formats" %in% pkgs)
    expect_true("ggseg.meshes" %in% pkgs)
    expect_true("ggplot2" %in% pkgs)
  })

  it("includes self when requested", {
    pkgs <- ggsegverse_packages(include_self = TRUE)
    expect_true("ggsegverse" %in% pkgs)
  })

  it("excludes self by default when include_self is FALSE", {
    pkgs <- ggsegverse_packages(include_self = FALSE)
    expect_false("ggsegverse" %in% pkgs)
  })

  it("excludes non-core imports like cli and rlang", {
    pkgs <- ggsegverse_packages(include_self = FALSE)
    expect_false("cli" %in% pkgs)
    expect_false("rlang" %in% pkgs)
  })

  it("does not include atlas-building tools", {
    expect_false("ggseg.extra" %in% ggsegverse_packages())
  })
})

describe("core_packages", {
  it("returns a character vector", {
    pkgs <- core_packages()
    expect_type(pkgs, "character")
    expect_true(length(pkgs) >= 4)
  })

  it("contains all expected packages", {
    pkgs <- core_packages()
    expect_true(all(
      c("ggseg.formats", "ggseg", "ggseg3d", "ggseg.meshes", "ggplot2") %in%
        pkgs
    ))
  })
})

describe("core_package_sources()", {
  it("lists every core package in DESCRIPTION Imports", {
    imports <- utils::packageDescription("ggsegverse")$Imports
    imports <- trimws(sub("\\(.*", "", strsplit(imports, ",")[[1]]))
    expect_true(all(core_packages() %in% imports))
  })

  it("assigns every core package a known source", {
    expect_true(all(core_package_sources() %in% c("ggsegverse", "cran")))
  })
})

describe("installed_version()", {
  it("returns the version of an installed package", {
    expect_equal(
      installed_version("testthat"),
      as.character(packageVersion("testthat"))
    )
  })

  it("returns NA for a package that is not installed", {
    expect_identical(installed_version("zzz_not_installed_999"), NA_character_)
  })
})

describe("invert", {
  it("inverts a named list", {
    x <- list(a = c("x", "y"), b = c("y", "z"))
    result <- invert(x)
    expect_true("x" %in% names(result))
    expect_true("y" %in% names(result))
    expect_true("z" %in% names(result))
    expect_true("a" %in% result[["x"]])
    expect_true("a" %in% result[["y"]])
    expect_true("b" %in% result[["y"]])
  })

  it("returns empty list for empty input", {
    expect_equal(invert(list()), list())
  })
})
