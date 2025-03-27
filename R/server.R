options(shiny.maxRequestSize = 50 * 1024 ^ 2)

server <- function(
  input,
  output,
  session
) {


  thematic_shiny()

  #### MAIN DATA ####
  dat <- reactive({

    # trying out automatic load
    file_path <- "ecomData.csv"
    load_data(file_path)
    # req(input$file_input)
    # load_data(
    #   input$file_input$datapath
    # )

  })

  #### SIDEBAR ####

  #### ANALYTICS ####
  shop_analytics_server("shop_analytics", dat)
  customer_analytics_server("customer_analytics", dat)
  product_analytics_server("product_analytics", dat)

  #### RAW DATA PANEL ####
  output$main_data <- DT::renderDT({
    req(input$file_input)
    dat()
  })

}
