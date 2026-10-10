describe("package_version_string()", {
  it("returns version string for installed package", {
    v <- package_version_string("base")
    expect_type(v, "character")
    expect_false(v == "[not installed]")
  })

  it("returns not installed for missing package", {
    v <- package_version_string("notarealpackage999")
    expect_equal(v, "[not installed]")
  })
})

describe("format_package_line()", {
  it("formats installed package with tick", {
    line <- format_package_line("base")
    expect_type(line, "character")
    expect_match(line, "base")
  })

  it("formats missing package with cross", {
    line <- format_package_line("notarealpackage999")
    expect_match(line, "not installed")
  })
})

describe("same_library()", {
  it("declines a package that is not installed instead of erroring", {
    expect_false(same_library("notarealpackage999"))
  })
})

describe("ggsegverse_attach()", {
  it("does not error when a core package is missing", {
    local_mocked_bindings(core_unloaded = function() "notarealpackage999")
    expect_invisible(ggsegverse_attach())
  })
})

describe("core_unloaded()", {
  it("returns a character vector", {
    result <- core_unloaded()
    expect_type(result, "character")
  })
})

describe("ggsegverse_attach()", {
  it("returns invisibly when all packages already loaded", {
    local_mocked_bindings(core_unloaded = function() character())
    expect_invisible(ggsegverse_attach())
  })
})

describe("ggsegverse_attach_message()", {
  it("returns a string containing ggsegverse", {
    msg <- ggsegverse_attach_message()
    expect_type(msg, "character")
    expect_match(msg, "ggsegverse")
  })

  it("aligns the second column across rows", {
    local_mocked_bindings(
      ggsegverse_packages = function(...) {
        c("ggseg", "ggseg.formats", "ggseg3d", "ggplot2")
      }
    )
    lines <- strsplit(ggsegverse_attach_message(), "\n")[[1]][-1]
    offsets <- vapply(
      lines,
      function(line) {
        cli::ansi_nchar(cli::ansi_strsplit(line, cli::symbol$tick)[[1]][2])
      },
      integer(1),
      USE.NAMES = FALSE
    )
    expect_length(unique(offsets), 1L)
  })

  it("handles odd number of packages", {
    local_mocked_bindings(
      ggsegverse_packages = function(...) c("ggseg", "ggseg3d", "ggseg.formats")
    )
    msg <- ggsegverse_attach_message()
    expect_type(msg, "character")
  })

  it("handles single package", {
    local_mocked_bindings(
      ggsegverse_packages = function(...) "ggseg"
    )
    msg <- ggsegverse_attach_message()
    expect_type(msg, "character")
  })
})
