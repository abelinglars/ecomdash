library(testthat)
library(data.table)

# Sample data following the e-commerce data structure
ecom_data <- data.table(
  invoice_no = c(1, 1, 2, 2, 3, 4, 5, 5),
  stock_code = c("A", "B", "A", "C", "D", "E", "A", "F"),
  description = c("Item A", "Item B", "Item A", "Item C", "Item D", "Item E", "Item A", "Item F"),
  quantity = c(1, 2, 1, 3, 1, 2, 1, 4),
  unit_price = c(10.0, 20.0, 10.0, 30.0, 40.0, 50.0, 10.0, 60.0),
  customer_id = c(1001, 1001, 1002, 1002, 1003, 1004, 1005, 1005),
  country = c("USA", "USA", "Canada", "Canada", "UK", "Germany", "USA", "France"),
  sales = c(10., 40., 10., 90., 40., 100., 10., 240.),
  date = as.Date(
    c(
      "2024-01-01", "2024-01-04", "2024-01-02", "2024-01-02", "2024-01-03",
      "2024-01-04", "2024-01-05", "2024-01-05"
    )
  ),
  year = c(2024, 2024, 2024, 2024, 2024, 2024, 2024, 2024),
  month = c(1, 1, 1, 1, 1, 1, 1, 1),
  weekday = c(1, 1, 2, 2, 3, 4, 5, 5),
  hour = c(10, 11, 12, 13, 14, 15, 16, 17)
)

ecom_data

# Tests for calculate_market_share_by_country
test_that(
  "calculate_market_share_by_country works correctly", {

    result <- calculate_market_share_by_country(ecom_data)

    expect_true( "country" %in% names(result))
    expect_true("percent_sales" %in% names(result))
    expect_equal(sum(result$percent_sales), 100)
    expect_true(
      any(
        result$country == "other") ||
        length(unique(result$country)) == length(unique(ecom_data$country))
      )
    expect_is(result, "data.table")

})

# Tests for calculate_total_revenue
test_that(
  "calculate_total_revenue returns correct total", {

  expect_equal(
    calculate_total_revenue(ecom_data),
    sum(ecom_data$sales)
  )

})

# Tests for calculate_unique_customers
test_that(
  "calculate_unique_customers counts unique customers correctly", {

  expect_equal(
    calculate_unique_customers(ecom_data), length(unique(ecom_data$customer_id))
  )
  expect_true(
    is.numeric(calculate_unique_customers(ecom_data))
  )
  expect_gt(calculate_unique_customers(ecom_data), 0)
  expect_lte(calculate_unique_customers(ecom_data), nrow(ecom_data))

})

# Tests for calculate_unique_products
test_that(
  "calculate_unique_products counts unique products correctly", {

  expect_equal(
    calculate_unique_products(ecom_data), length(unique(ecom_data$stock_code))
  )
  expect_true(is.numeric(calculate_unique_products(ecom_data)))
  expect_gt(calculate_unique_products(ecom_data), 0)
  expect_lte(calculate_unique_products(ecom_data), nrow(ecom_data))

})

# Tests for calculate_revenue_for
test_that(
  "calculate_revenue_for returns correct revenue", {

  expect_equal(
    calculate_revenue_for(
      ecom_data,
      "country",
      "USA"
    ),
    sum(ecom_data[country == "USA", sales])
  )

  expect_equal(
    calculate_revenue_for(
      ecom_data,
      "customer_id",
      1001
    ),
    sum(ecom_data[customer_id == 1001, sales])
  )
  expect_equal(
    calculate_revenue_for(
      ecom_data,
      "stock_code",
      "A"
    ),
    sum(ecom_data[stock_code == "A", sales])
  )

  expect_equal(
    calculate_revenue_for(
      ecom_data,
      "country",
      "NonExistent"
    ),
    0
  )

  expect_error(
    calculate_revenue_for(
      ecom_data,
      "invalid_column",
      "USA"
    )
  )

})

# Tests for calculate_revenue_for_customer
test_that(
  "calculate_revenue_for_customer works correctly", {

  expect_equal(
    calculate_revenue_for_customer(
      ecom_data,
      1001
    ),
    sum(ecom_data[customer_id == 1001, sales])
  )
  expect_equal(calculate_revenue_for_customer(ecom_data, 1003), sum(ecom_data[customer_id == 1003, sales]))
  expect_equal(calculate_revenue_for_customer(ecom_data, 9999), 0) # Nonexistent customer
  expect_true(is.numeric(calculate_revenue_for_customer(ecom_data, 1001)))

})

# Tests for get_customer_data
test_that(
  "get_customer_data retrieves correct data", {

  expect_equal(nrow(get_customer_data(ecom_data, 1001)), sum(ecom_data$customer_id == 1001))
  expect_equal(ncol(get_customer_data(ecom_data, 1001)), ncol(ecom_data))
  expect_equal(nrow(get_customer_data(ecom_data, 9999)), 0) # Nonexistent customer
  expect_error(get_customer_data(ecom_data, NULL))
  expect_true(is.data.table(get_customer_data(ecom_data, 1001)))

})

# Tests for calculate_revenue_for_product
test_that(
  "calculate_revenue_for_product works correctly", {

  expect_equal(calculate_revenue_for_product(ecom_data, "A"), sum(ecom_data[stock_code == "A", sales]))
  expect_equal(calculate_revenue_for_product(ecom_data, "C"), sum(ecom_data[stock_code == "C", sales]))
  expect_equal(calculate_revenue_for_product(ecom_data, "Z"), 0) # Nonexistent product
  expect_error(calculate_revenue_for_product(ecom_data, NULL))
  expect_true(is.numeric(calculate_revenue_for_product(ecom_data, "A")))

})

# Tests for calculate_bulk_items
test_that(
  "calculate_bulk_items calculates total quantity correctly", {

  result <- calculate_bulk_items(ecom_data)
  expect_true("total_quantity" %in% names(result))
  expect_true("description" %in% names(result))
  expect_true(all(result$total_quantity >= 0))
  expect_is(result, "data.table")

})

# Tests for product_ranking
test_that(
  "product_ranking ranks products correctly", {

  result_top <- product_ranking(ecom_data, "top", 3)
  result_bottom <- product_ranking(ecom_data, "bottom", 3)
  expect_equal(nrow(result_top), 3)
  expect_equal(nrow(result_bottom), 3)
  expect_true("description" %in% names(result_top))
  expect_true("items_sold" %in% names(result_top))

})

# Tests for bought_last
test_that(
  "bought_last returns the most recent transaction", {

  result <- bought_last(ecom_data)
  expect_true("date" %in% names(result))
  expect_true(all(result$date == max(ecom_data$date)))

})

# Tests for calculate_average_order_value
test_that(
  "calculate_average_order_value computes mean order value", {

  result <- calculate_average_order_value(ecom_data)
  expect_true(is.numeric(result))
  expect_gt(result, 0)

})

# Tests for calculate_no_of_invoices_per_month
test_that(
  "calculate_no_of_invoices_per_month counts invoices correctly", {

  result <- calculate_no_of_invoices_per_month(ecom_data)
  expect_true("N" %in% names(result))
  expect_true("sales" %in% names(result))

})

# Tests for calculate_average_customer_lifetime
test_that(
  "calculate_average_customer_lifetime computes average duration", {

  result <- calculate_average_customer_lifetime(ecom_data)
  expect_true(is.double(result))
})

# Tests for calculate_return_customers
test_that(
  "calculate_return_customers counts invoices per customer", {

  result <- calculate_return_customers(ecom_data)
  expect_true("no_of_invoices" %in% names(result))
  expect_true(all(result$no_of_invoices >= 1))

})
