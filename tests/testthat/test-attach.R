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

  it("attaches every core package", {
    # Detaching first is the point: loading this package has already
    # attached them, so without it the assertion is true before the call.
    attached <- paste0("package:", core_packages())
    on.exit(ggsegverse_attach(), add = TRUE)
    for (pkg in rev(intersect(attached, search()))) {
      detach(pkg, character.only = TRUE)
    }
    expect_false(any(attached %in% search()))

    ggsegverse_attach()
    expect_true(all(attached %in% search()))
  })
})

describe("ggsegverse_attach_message()", {
  it("returns a string containing ggsegverse", {
    msg <- ggsegverse_attach_message()
    expect_type(msg, "character")
    expect_match(msg, "ggsegverse")
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
