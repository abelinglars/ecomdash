trend_analysis <- function(x, date_range = NULL, col) {

  if (!is.null(date_range)) {
    x[
      date >= date_range[1] &
      date <= date_range[2]
    ] ->
    x
  }

  x[,
    list(summation = sum(col)),
    by = "date",
    env = list(
      col = col
    )
  ] ->
  plot_data

  if (nrow(plot_data) < 2) {

    plot_data |>
    ggplot(
      aes(
        x = date,
        y = summation
      )
    ) +
    geom_bar(
      stat = "identity"
    ) +
    labs(
      title = "Sales trend",
      y = paste0(col, "in Euro"),
      x = element_text("")
    ) +
    theme_minimal() ->
    p

    ggplotly(
      p,
      font = list(family = "sans-serif")
    )

  } else {

    plot_data |>
    ggplot(
      aes(
        x = date,
        y = summation
      )
    ) +
    geom_line() +
    labs(
      title = "Sales trend",
      y = paste0(col, " in Euro")
    ) +
    theme_minimal() ->
    p

    ggplotly(p)

  }

}

plot_no_invoices_per_month <- function(x) {
  ggplot(
    x,
    aes(
      x = month
    )
  ) +
  geom_line(
    aes(y = N, linetype = "dotted", linewidth = 1)
  ) +
  geom_line(
    aes(y = sales)
  ) +
  theme_minimal() ->
  p

  ggplotly(p)

}

plot_sales_and_quantity_by <- function( x ) {

  x[,
    .(
      sales = sum(sales),
      quantity = as.numeric(sum(quantity))
    ),
    by = "month"
  ]|>
  melt(
    measure.vars = c("sales", "quantity")
  ) |>
  ggplot(
    aes(
      x = month,
      y = value,
      fill = variable
    )
  ) +
  geom_bar(
    position = "dodge",
    stat = "identity"
  ) +
  labs(
    title = "Sales and Quantity over time",
    y = "Sales in Euro"
  ) +
  theme_minimal() ->
  p

  ggplotly(p)

}

plot_return_customers <- function(x) {

  return_customers <- calculate_return_customers(x)

  data.table(
    customer_type = c("return", "no return"),
    val = c(
      return_customers[
        no_of_invoices > 1,
        .N
      ],
      return_customers[
        no_of_invoices < 2,
        .N
      ]
    )
  ) |>
  ggplot(
    aes(
      x = customer_type,
      y = val
    )
  ) +
  geom_col() +
  theme_minimal() ->
  p

  ggplotly(p)

}

plot_market_share_by_country <- function(x) {

  x |>
  ggplot(
    aes(
      x = forcats::fct_reorder(country, percent_sales),
      y = percent_sales
    )
  ) +
  geom_col() +
  theme_minimal() ->
  p

  ggplotly(p)

}

