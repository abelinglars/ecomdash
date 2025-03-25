shop_analytics_ui <- function(
  id
) {

  tagList(
    layout_columns(
      col_widths = c(2,10),
      layout_column_wrap(
        width = 1,
        value_box(
          title = "Total Revenue",
          showcase = bsicons::bs_icon("currency-dollar"),
          value = textOutput(
            NS(id, "total_revenue")
          ),
          theme = "primary"
        ),
        value_box(
          title = "Total Customers",
          showcase = bsicons::bs_icon("people"),
          value = textOutput(
            NS(id, "total_customers")
          ),
          theme = "primary"
        ),
        value_box(
          title = "Average Order Value",
          showcase = bsicons::bs_icon("cart-check-fill"),
          value = textOutput(
            NS(id, "average_order_value")
          ),
          theme = "primary"
        )
      ),
      card(
        navset_tab(
          nav_panel(
            "Trend Analysis",
            layout_column_wrap(
              heights_equal = "row",
              width = 1,
              height = "700px",
              plotly::plotlyOutput(
                NS(id, "trend")
              )
            )
          ),
          nav_panel(
            "Sales Quantity",
            plotly::plotlyOutput(
              NS(id, "sales_quantity")
            )
          ),
          nav_panel(
            "Sales and market share",
            layout_columns(
              card(
                "Sales and Orders per month",
                plotly::plotlyOutput(
                  NS(id, "sales_and_orders_per_month")
                )
              ),
              card(
                "Market share by country",
                plotly::plotlyOutput(
                  NS(id, "market_share_country")
                )
              )
            )
          )
        )
      )
    )
  )

}

shop_analytics_server <- function(
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

      output$total_customers <- renderText({
        calculate_unique_customers(dat())
      })

      output$average_order_value <- renderText({
        calculate_average_order_value(dat())
      })

      output$total_revenue <- renderText({
        calculate_total_revenue(dat())
      })

      output$sales_and_orders_per_month <- renderPlotly({
        calculate_no_of_invoices_per_month(dat()) |>
        plot_no_invoices_per_month()
      })

      output$trend <- renderPlotly({
        trend_analysis(
          dat(),
          input$trend_date_range,
          col = "sales"
        )
      })

      output$sales_quantity <- renderPlotly({
        plot_sales_and_quantity_by(dat())
      })

      output$market_share_country <- renderPlotly({
        calculate_market_share_by_country(dat()) |>
        plot_market_share_by_country()
      })

    }
  )

}
