#' Calculates combined sales for each country
#'
#' @param x data.table: The dataset as specified in
#'
#' @returns A data.table
#' @export
#'
#' @examples
calculate_market_share_by_country <- function(x) {

  x[,
    .(
      percent_sales = sum(sales) / sum(x[["sales"]])
    ),
    by = "country"
  ][
    percent_sales < 0.009,
    country := "other"
  ][,
    .(percent_sales = sum(percent_sales) * 100),
    by = "country"
  ]


}

calculate_total_revenue <- function(x) {
  x[, sum(sales)]
}

calculate_unique_customers <- function(x) {
  uniqueN(x[["customer_id"]])
}

calculate_unique_products <- function(x) {
  uniqueN(x[["stock_code"]])
}

calculate_revenue_for <- function(x, col, val) {
  col <- as.character(col)
  val <- as.character(val)

  x[
    col == val,
    sum(sales),
    env = list(
      col = col,
      val = "val"
    )
  ]

}

calculate_revenue_for_customer <- function(x, selected_customer) {
  calculate_revenue_for(x, "customer_id", selected_customer)
}

get_customer_data <- function(x, selected_customer) {

    x[
      customer_id == selected_customer,
      env = list(selected_customer = "selected_customer")
    ]

}

calculate_revenue_for_product <- function(x, selected_product) {
  calculate_revenue_for(x, "stock_code", selected_product)
}

calculate_bulk_items <- function(x) {

  x[,
    .(
      total_quantity = sum(quantity),
      description = description[1]
    ),
    by = c("stock_code", "invoice_no")
  ][order(-total_quantity)]

}

product_ranking <- function(x, what = "top", rows = 5) {

  x[,
    .(
      description = unique(description)[1],
      items_sold = .N
    ),
    by = "stock_code"
  ][order(-items_sold)] ->
  ranked

  if (what == "top") {
    head(ranked, n = rows)
  } else {
    tail(ranked, n = rows)
  }

}

bought_last <- function(x) {

  x[
    date == max(date),
    .(
      date = max(date),
      invoice_no = invoice_no,
      description = description,
      items = stock_code
    )
  ]

}

calculate_average_order_value <- function(x) {
  x[,
    .(total = sum(sales)),
    by = "invoice_no"
  ][,
    mean(total)
  ]
}

calculate_no_of_invoices_per_month <- function(x) {

  x[,
    .(
      N = length(unique(invoice_no)),
      sales = (sum(sales) / sum(x[["sales"]])) * 10000
    ),
    by = "month"
  ]

}

calculate_average_customer_lifetime <- function(x) {

  x[,
    .(
      start_date = min(date),
      end_date = max(date)
    ),
    by = "customer_id"
  ][order(customer_id)][,
    duration := end_date - start_date
  ][, mean(duration)]

}

calculate_return_customers <- function(x) {

  x[,
    .(
      no_of_invoices = length(
        unique(invoice_no)
      )
    ),
    by = "customer_id"
  ]

}
