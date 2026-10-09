# Generate the hex logo for ggsegverse
#
# Run with: source("data-raw/make_hex.R")
#
# Concept: the ggsegverse brand hex (data-raw/ggsegverse-hex.png, exported from
# the brand sheet in the website repo) set against a starry sky. Stars are only
# placed where they have clear background around them, so they never touch the
# brain, the wordmark or the hex rim.

library(magick)

set.seed(2026)

background <- "#13293a"
star_colours <- c(
  "#f7fdfc",
  "#f7fdfc",
  "#a8c5cb",
  "#a8c5cb",
  "#c094b5",
  "#94c0ac",
  "#b7a8cb"
)

hex <- image_read("data-raw/ggsegverse-hex.png")
pixels <- image_data(hex, "rgba")
width <- dim(pixels)[2]
height <- dim(pixels)[3]

is_background <- pixels[4, , ] == as.raw(255)
for (channel in 1:3) {
  is_background <- is_background &
    pixels[channel, , ] == as.raw(col2rgb(background)[channel])
}

has_clearance <- function(x, y, radius) {
  xs <- seq(floor(x - radius), ceiling(x + radius))
  ys <- seq(floor(y - radius), ceiling(y + radius))
  if (min(xs) < 1 || min(ys) < 1 || max(xs) > width || max(ys) > height) {
    return(FALSE)
  }
  all(is_background[xs, ys])
}

scatter_stars <- function(n, radius, clearance, spacing, placed = NULL) {
  stars <- data.frame(x = numeric(), y = numeric(), radius = numeric())
  attempts <- 0
  while (nrow(stars) < n && attempts < n * 500) {
    attempts <- attempts + 1
    candidate <- data.frame(
      x = runif(1, 1, width),
      y = runif(1, 1, height),
      radius = runif(1, radius[1], radius[2])
    )
    others <- rbind(placed, stars)
    crowded <- any(
      sqrt((others$x - candidate$x)^2 + (others$y - candidate$y)^2) < spacing
    )
    clear <- has_clearance(
      candidate$x,
      candidate$y,
      candidate$radius + clearance
    )
    if (clear && !crowded) {
      stars <- rbind(stars, candidate)
    }
  }
  stars
}

sparkles <- scatter_stars(12, radius = c(9, 15), clearance = 6, spacing = 90)
dots <- scatter_stars(
  170,
  radius = c(0.8, 2.6),
  clearance = 5,
  spacing = 16,
  placed = sparkles
)
dots$colour <- rgb(
  t(col2rgb(sample(star_colours, nrow(dots), replace = TRUE))),
  alpha = runif(nrow(dots), 115, 255),
  maxColorValue = 255
)

sparkle_outline <- function(x, y, radius) {
  angles <- seq(0, 2 * pi, length.out = 9)[-9]
  reach <- rep(c(radius, radius * 0.22), 4)
  list(x = x + reach * sin(angles), y = y + reach * cos(angles))
}

canvas <- image_draw(hex)
symbols(
  dots$x,
  dots$y,
  circles = dots$radius,
  inches = FALSE,
  add = TRUE,
  fg = NA,
  bg = dots$colour
)
for (i in seq_len(nrow(sparkles))) {
  polygon(
    sparkle_outline(sparkles$x[i], sparkles$y[i], sparkles$radius[i]),
    col = "#f7fdfc",
    border = NA
  )
}
dev.off()

dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)
logo <- image_resize(canvas, "x600")
image_write(logo, "man/figures/logo.png", format = "png")

# Favicons: realfavicongenerator.net (used by pkgdown::build_favicons) is
# unreliable, so render the standard set locally from the logo with magick.
square <- function(px) {
  geom <- sprintf("%dx%d", px, px)
  image_extent(image_resize(logo, geom), geom, color = "none")
}
favicons <- list(
  "favicon-16x16.png" = 16,
  "favicon-32x32.png" = 32,
  "apple-touch-icon-60x60.png" = 60,
  "apple-touch-icon-76x76.png" = 76,
  "apple-touch-icon-120x120.png" = 120,
  "apple-touch-icon-152x152.png" = 152,
  "apple-touch-icon-180x180.png" = 180,
  "apple-touch-icon.png" = 180
)
dir.create("pkgdown/favicon", recursive = TRUE, showWarnings = FALSE)
for (nm in names(favicons)) {
  image_write(
    square(favicons[[nm]]),
    file.path("pkgdown/favicon", nm),
    format = "png"
  )
}
image_write(
  image_join(square(16), square(32)),
  "pkgdown/favicon/favicon.ico",
  format = "ico"
)
