# xx <- load_data("ecomData.csv")




# xx[,
#   .(
#     market_share = (sum(sales) / total_rev) * 100,
#     description = description[1],
#     unit_price = mean(unit_price)
#   ),
#   by = "stock_code",
#   env = list(total_rev = "total_rev")
# ][order(-market_share)][1:15]


