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
          showcase_layout = "top right",
          value = textOutput(
            NS(id, "total_revenue")
          ),
          p(
            "For time period: ",
            span(
              textOutput(NS(id, "total_revenue_time_period"))
            )
          ),
          theme = "primary"
        ),
        value_box(
          title = "AOV",
          showcase = bsicons::bs_icon("cart-check-fill"),
          showcase_layout = "top right",
          value = textOutput(
            NS(id, "average_order_value")
          ),
          p(
            "For time period: ",
            span(
              textOutput(NS(id, "average_order_value_time_period"))
            )
          ),
          theme = "primary"
        ),
        value_box(
          title = "Total Customers",
          showcase = bsicons::bs_icon("people"),
          showcase_layout = "top right",
          value = textOutput(
            NS(id, "total_customers")
          ),
          theme = "primary"
        ),
        value_box(
          title = "No of return customers",
          showcase = bsicons::bs_icon("people"),
          showcase_layout = "top right",
          value = textOutput(
            NS(id, "return_customers")
          ),
          p(
            "For time period: ",
            span(
              textOutput(NS(id, "return_customers_time_period"))
            )
          ),
          theme = "primary"
        )
      ),
      card(
        navset_tab(
          nav_panel(
            "Trend Analysis",
            # layout_column_wrap(
            #   heights_equal = "row",
            #   width = 1,
            #   height = "700px",
              card(
                class = "border-0",
                card_body(
                  max_height = "700px",
                  height = "600px",
                  min_height = "400px",
                  plotly::plotlyOutput(
                    NS(id, "trend")
                  )
                )
              )
            # )
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
        ),
        dateRangeInput(
          NS(id, "trend_date_range"),
          "Select a date range."
        ),
        actionButton(
          NS(id, "reset_range"),
          "Reset",
          width = "160px"
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


      #### DATA ####
      date_subsetted_data <- reactive({
        input$trend_date_range
        dat()[
          date >= input$trend_date_range[1]
        ][
          date <= input$trend_date_range[2]
        ]
      })

      #### UPDATES ####
      observe(
        updateDateRangeInput(
          inputId = "trend_date_range",
          start = min(dat()[["date"]]),
          end = max(dat()[["date"]])
        )
     ) |>
      bindEvent(
        dat(),
        input$reset_range
      )

      #### VALUE BOXES ####
      output$total_customers <- renderText({
        calculate_unique_customers(date_subsetted_data())
      })

      output$average_order_value <- renderText({
        calculate_average_order_value(dat())
      })

      output$average_order_value_time_period <- renderText({
        calculate_average_order_value(date_subsetted_data())
      })

      output$total_revenue <- renderText({
        calculate_total_revenue(dat())
      })

      output$total_revenue_time_period <- renderText({
        calculate_total_revenue(date_subsetted_data())
      })

      output$return_customers <- renderText({
        calculate_return_customers(dat())[
          no_of_invoices > 1,
          .N
        ]
      })

      output$return_customers_time_period <- renderText({
        calculate_return_customers(date_subsetted_data())[
          no_of_invoices > 1,
          .N
        ]
      })

      #### TABS ####
      output$sales_and_orders_per_month <- renderPlotly({
        calculate_no_of_invoices_per_month(date_subsetted_data()) |>
        plot_no_invoices_per_month()
      })

      output$trend <- renderPlotly({

        if (
          nrow(date_subsetted_data()) == 0
        ) {
          validate("please select a range that contains data")
        }

        trend_analysis(
          date_subsetted_data(),
          col = "sales"
        )
      })

      output$sales_quantity <- renderPlotly({
        plot_sales_and_quantity_by(date_subsetted_data())
      })

      output$market_share_country <- renderPlotly({
        calculate_market_share_by_country(date_subsetted_data()) |>
        plot_market_share_by_country()
      })

    }
  )

}
