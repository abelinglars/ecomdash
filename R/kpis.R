#' E-commerce Data Table Structure
#'
#' The functions in this package operate on a `data.table` containing
#' e-commerce transaction data.
#' The table must have the following columns:
#'
#' - `invoice_no` (integer): Invoice number
#' - `stock_code` (character): Product stock code
#' - `description` (character): Product description
#' - `quantity` (integer): Quantity sold
#' - `unit_price` (numeric): Price per unit
#' - `customer_id` (integer): Customer ID
#' - `country` (character): Country of purchase
#' - `sales` (numeric): Total sales amount
#' - `date` (numeric): Date of transaction
#' - `year` (integer): Year of transaction
#' - `month` (integer): Month of transaction
#' - `weekday` (integer): Weekday of transaction
#' - `hour` (integer): Hour of transaction

#' Calculate Market Share by Country
#'
#' This function calculates the percentage of total sales per country.
#' Countries with less than 0.9% of total sales are grouped under "other".
#'
#' @param x A data.table following the structure defined in the
#' "E-commerce Data Table Structure" section.
#' @return A data.table with the market share percentage per country.
#' @export
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

#' Calculate Total Revenue
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @return Total revenue (sum of sales).
#' @export
calculate_total_revenue <- function(x) {
  x[, sum(sales)]
}

#' Calculate Unique Customers
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @return Number of unique customers.
#' @export
calculate_unique_customers <- function(x) {
  uniqueN(x[["customer_id"]])
}

#' Calculate Unique Products
#'
#' @param x A data.table following the structure defined in the
#' "E-commerce Data Table Structure" section.
#' @return Number of unique products.
#' @export
calculate_unique_products <- function(x) {
  uniqueN(x[["stock_code"]])
}

#' Calculate Revenue for a Specific Column Value
#'
#' @param x A data.table following the structure defined in the
#' "E-commerce Data Table Structure" section.
#' @param col The column name to filter on.
#' @param val The value to filter for.
#' @return Total revenue for the specified column value.
#' @export
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

#' Calculate Revenue for a Customer
#'
#' @param x A data.table following the structure defined in the
#' "E-commerce Data Table Structure" section.
#' @param selected_customer The customer ID.
#' @return Total revenue for the selected customer.
#' @export
calculate_revenue_for_customer <- function(x, selected_customer) {
  calculate_revenue_for(x, "customer_id", selected_customer)
}

#' Get Customer Data
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @param selected_customer The customer ID.
#' @return A data.table with data for the selected customer.
#' @export
get_customer_data <- function(x, selected_customer) {
  x[
    customer_id == selected_customer,
    env = list(selected_customer = "selected_customer")
  ]
}

#' Calculate Revenue for a Product
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @param selected_product The product stock code.
#' @return Total revenue for the selected product.
#' @export
calculate_revenue_for_product <- function(x, selected_product) {
  calculate_revenue_for(x, "stock_code", selected_product)
}

#' Calculate Bulk Items Sold
#'
#' @param x A data.table following the structure defined in the
#' "E-commerce Data Table Structure" section.
#' @return A data.table with total quantity and descriptions, sorted in descending order.
#' @export
calculate_bulk_items <- function(x) {
  x[,
    .(
      total_quantity = sum(quantity),
      description = description[1]
    ),
    by = c("stock_code", "invoice_no")
  ][order(-total_quantity)]
}

#' Product Ranking
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @param what "top" for best sellers, "bottom" for least sold.
#' @param rows Number of rows to return.
#' @return A data.table with ranked products.
#' @export
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

#' Find Items Bought in the Last Transaction
#'
#' @param x A data.table following the structure defined in the
#' "E-commerce Data Table Structure" section.
#' @return A data.table of items bought in the most recent transaction.
#' @export
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

#' Calculate Average Order Value
#'
#' @param x A data.table following the structure defined in the
#' "E-commerce Data Table Structure" section.
#' @return Average order value.
#' @export
calculate_average_order_value <- function(x) {
  x[,
    .(total = sum(sales)),
    by = "invoice_no"
  ][,
    mean(total)
  ]
}

#' Calculate Number of Invoices Per Month
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @return A data.table with the number of invoices and sales percentage per month.
#' @export
calculate_no_of_invoices_per_month <- function(x) {
  x[,
    .(
      N = length(unique(invoice_no)),
      sales = (sum(sales) / sum(x[["sales"]])) * 10000
    ),
    by = "month"
  ]
}

#' Calculate Average Customer Lifetime
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @return Average customer lifetime duration.
#' @export
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

#' Calculate Returning Customers
#'
#' @param x A data.table following the structure defined in the "E-commerce Data Table Structure" section.
#' @return A data.table with the number of invoices per customer.
#' @export
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
