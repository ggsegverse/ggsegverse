# ggsegverse_sitrep() / reports not installed packages

    Code
      ggsegverse_sitrep()
    Message
      
      -- ggsegverse situation report -------------------------------------------------
      
      -- Installed packages --
      
      x zzz_not_real_pkg: not installed
      
      -- R version --
      
      R version 4.5.0 (2025-04-11)

# ggsegverse_sitrep() / reports outdated packages

    Code
      ggsegverse_sitrep()
    Message
      
      -- ggsegverse situation report -------------------------------------------------
      
      -- Installed packages --
      
      ! ggseg: 0.1.0 (update available: 99.0.0)
      
      -- R version --
      
      R version 4.5.0 (2025-04-11)

# ggsegverse_sitrep() / reports up to date packages

    Code
      ggsegverse_sitrep()
    Message
      
      -- ggsegverse situation report -------------------------------------------------
      
      -- Installed packages --
      
      v ggseg: 1.0.0
      
      -- R version --
      
      R version 4.5.0 (2025-04-11)

# ggsegverse_update() / reports all up to date when no packages behind

    Code
      ggsegverse_update()
    Message
      v All ggsegverse packages are up to date.

# ggsegverse_update() / reports outdated packages

    Code
      ggsegverse_update()
    Message
      
      -- The following packages are out of date: --
      
      * ggseg (0.1.0 -> 1.0.0)
      
      Update with:
      pak::pak(c('ggsegverse/ggseg'))

# ggsegverse_update() / suggests CRAN and GitHub refs together

    Code
      ggsegverse_update()
    Message
      
      -- The following packages are out of date: --
      
      * ggseg (0.1.0 -> 1.0.0)
      * ggplot2 (3.5.0 -> 4.0.0)
      
      Update with:
      pak::pak(c('ggsegverse/ggseg', 'ggplot2'))

