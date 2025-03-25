#
load_data <- function(
  data_path = NULL,
  data_dir = NULL
) {

  cols_to_keep <-
  c(
    "InvoiceNo",
    "StockCode",
    "Description",
    "Quantity",
    "UnitPrice",
    "CustomerID",
    "Country",
    "Sales",
    "Date",
    "Year",
    "Month",
    "Weekday",
    "Hour"
  )

  month_names <- c(
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  )

  if (is.null(data_dir)) {
    list(
      invoice_no = NA_integer_,
      stock_code = NA_character_,
      description = NA_character_,
      quantity = NA_integer_,
      unit_price = NA_real_,
      customer_id = NA_integer_,
      country = NA_character_,
      sales = NA_real_,
      date = NA_real_,
      year = NA_integer_,
      month = NA_integer_,
      weekday = NA_integer_,
      hour = NA_integer_
    ) |>
    as.data.table() ->
    data_dir
  }

  # if (is.null(data_path)) {
  #   data_path <- "./ecomData.csv"
  # }

  tryCatch(
    fread(data_path,
          select = cols_to_keep
    ),
    error = function(e) {
      data_dir
    }
  ) ->
  dat


  setnames(dat, names(dat), names(data_dir))
  dat <- na.omit(dat)
  dat <- unique(dat)
  dat[,
    old_date := date]
  dat[,
    date := as.Date(old_date, format = "%Y-%m-%d")
  ]

  # convert to factor and assign levels
  dat[,
    month := as.factor(month)
  ]

  levels(dat[["month"]]) <- month_names

  dat

}


