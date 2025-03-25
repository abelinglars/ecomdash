product_analytics_ui <- function(
  id
) {

  tagList(
    value_box(
      title = "Total Products",
      showcase = bsicons::bs_icon("gift"),
      value = textOutput(NS(id, "total_products")),
      theme = "primary"
    ),
    card(
      class = c("border-0"),
      layout_columns(
        card(
          "Top sellers",
          tableOutput(NS(id, "top_sellers"))
        ),
        card(
          "Bottom sellers",
          tableOutput(NS(id, "bottom_sellers"))
        ),
        card(
          "Bulk sellers",
          tableOutput(NS(id, "bulk_sellers"))
        )
      )
    )
  )

}

product_analytics_server <- function(
  id,
  dat
) {

  moduleServer(id,
    function(
      input,
      output,
      session
    ) {

      output$total_products <- renderText({
        calculate_unique_products(dat())
      })

      output$bulk_sellers<- renderTable({
        calculate_bulk_items(dat())[1:5]
      })

      output$top_sellers <- renderTable({
        product_ranking(dat())
      })

      output$bottom_sellers <- renderTable({
        product_ranking(dat(), what = "bottom")
      })

    }
  )

}
