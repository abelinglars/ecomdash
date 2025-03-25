customer_analytics_ui <- function(
  id
) {

  tagList(
    layout_columns(
      value_box(
        title = "Average customer lifetime",
        value = textOutput(NS(id, "average_customer_lifetime"))
      ),
      card(
        "Return customers or not",
        plotly::plotlyOutput(NS(id, "return_customers"))
      )
    ),
    selectizeInput(
      NS(id, "select_customer"),
      "Select a customer",
      choices = c("")
    ),
    layout_columns(
      card(
        DTOutput(NS(id, "most_bought_items"))
      ),
      value_box(
        title = "All time revenue",
        value = textOutput(NS(id, "revenue_for_customer"))
      ),
      card(
        DTOutput(NS(id, "bought_last"))
      )
    ),
    DTOutput(NS(id, "data_for_customer"))
  )

}

customer_analytics_server <- function(
  id,
  dat
) {

  stopifnot(is.reactive(dat))

  moduleServer(
    id,
    function(
      input,
      output,
      session
    ) {

      observe(
        updateSelectizeInput(
          inputId = "select_customer",
          choices = unique(dat()[["customer_id"]]),
          server = TRUE
        )
      ) |>
      bindEvent(
        dat()
      )

      output$data_for_customer <- DT::renderDT({
        req(dat())
        get_customer_data(dat(), input$select_customer)
      })

      output$return_customers <- renderPlotly({
        plot_return_customers(dat())
      })

      output$most_bought_items <- DT::renderDT({
        get_customer_data(dat(), input$select_customer) |>
        product_ranking()
      })

      output$revenue_for_customer <- renderText({
        get_customer_data(dat(), input$select_customer) |>
        calculate_total_revenue()
      })

      output$bought_last <- DT::renderDT({
        get_customer_data(dat(), input$select_customer) |>
        bought_last()
      })

      output$average_customer_lifetime <- renderText({
        calculate_average_customer_lifetime(dat())
      })

    }
  )

}
