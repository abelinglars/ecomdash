# # load packages
# library(shiny)
# library(bslib)
# library(data.table)
# library(stringr)
# library(DT)
# library(plotly)
# library(thematic)

# p <- c(
#   "shiny",
#   "pkgload",
#   "bslib",
#   "data.table",
#   "stringr",
#   "DT",
#   "plotly",
#   "ggplot2",
#   "thematic"
# )
#
# for (i in p) {
#   usethis::use_package(i)
# }

# set shiny options
options(shiny.maxRequestSize = 50 * 1024^2)

pkgload::load_all(".")

thematic_shiny()

start_app()
