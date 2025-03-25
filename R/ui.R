library(shiny)
library(bslib)
library(DT)
library(ggplot2)

sidebar_ui <- sidebar(
  fileInput("file_input", "Upload a csv file."),
  hr(),
  dateRangeInput(
    "trend_date_range",
    "Select a date range."
  ),
  actionButton(
    "reset_range",
    "Reset",
    width = "160px"
  )
)

ui <- page_navbar(
  nav_panel(
    title = "Shop Level Analytics",
    shop_analytics_ui(id = "shop_analytics")
  ),
  nav_panel(
    title = "Customer Analytics",
    customer_analytics_ui("customer_analytics")
  ),
  nav_panel(
    title = "Product Analytics",
    product_analytics_ui("product_analytics")
  ),
  nav_panel(
    title = "Raw Data",
    card(
      DT::dataTableOutput("main_data"),
      height = "200px"
    )
  ),
  theme = bs_theme(bootswatch = "minty"),
  title = "E-commerce UK 2010-2011",
  sidebar = sidebar_ui
)
