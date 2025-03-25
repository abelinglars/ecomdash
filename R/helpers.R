# library(shiny)
# library(bslib)
# library(data.table)
# library(stringr)
# library(DT)
# library(plotly)
# library(thematic)
# usethis::use_pkgdown_github_pages()

start_app <- function(
  #dev = FALSE
  # ui,
  # server
) {


  dev <- Sys.getenv(x = "local_app")


  if (dev) {

    shinyApp(
      ui = ui,
      server = server
    ) |>
    runApp(
      launch.browser = TRUE
    )

  } else  {

    shinyApp(
      ui = ui,
      server = server
    )

  }

}

# options(shiny.autoreload = TRUE)
# options(shiny.port = 8089)
# options(shiny.maxRequestSize = 50 * 1024^2)


