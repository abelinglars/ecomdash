test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

calculate_revenue_for(dat, "customer_id", 14729)
calculate_revenue_for_customer(dat, 14729)
calculate_revenue_for_product(dat, 21122)

calculate_unique_products(dat)
calculate_unique_customers(dat)
calculate_total_revenue(dat)
