% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kpis.R
\name{calculate_market_share_by_country}
\alias{calculate_market_share_by_country}
\title{Calculate Market Share by Country}
\usage{
calculate_market_share_by_country(x)
}
\arguments{
\item{x}{A data.table following the structure defined in the
"E-commerce Data Table Structure" section.}
}
\value{
A data.table with the market share percentage per country.
}
\description{
This function calculates the percentage of total sales per country.
Countries with less than 0.9\% of total sales are grouped under "other".
}
