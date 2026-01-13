# Retrieve flat meta data for a financial asset

Internal function to fetch flat (non-nested) meta data for a given asset
symbol, such as a stock. Returns a one-row data frame with high-level
market and asset information (e.g., prices, volumes, timezones).

## Usage

``` r
get_asset_value(symbol = "SAAB-B.ST", .verbose = F)
```

## Arguments

- symbol:

  Character. Asset symbol to query (e.g., "AAPL").

- .verbose:

  Logical. If TRUE, enables verbose output for debugging purposes.
  Default is FALSE.

## Value

A data.frame with 1 row per symbol provided and 21 columns see
[`get_values()`](https://clement-lvd.github.io/financr/reference/get_values.md)

## See also

`get_values`

## Examples

``` r
if (FALSE) { # \dontrun{
last_prices <- get_asset_value("SAAB-B.ST")
str(last_prices)
} # }
```
