# Get Historical Financial Data For Ticker Symbols

Get an historic of stock market data for financial ticker symbols, e.g.,
values at each closing day.

## Usage

``` r
get_historic_light(
  symbols = "SAAB-B.ST",
  interval = "1d",
  range = "1mo",
  .verbose = F
)
```

## Arguments

- symbols:

  `character` A character string representing the financial indices to
  search for, e.g., ticker symbol(s).

- interval:

  `character`, default = `"1d"`. The interval between 2 rows of the
  time.series answered.

  |                                                   |
  |---------------------------------------------------|
  | **Valid `interval` values**                       |
  | `"1m"`, `"5m"`, `"15m"`, `"1d"`, `"1wk"`, `"1mo"` |
  |                                                   |

- range:

  `character`, default = `"1y"`. The period covered by the time series.

  |                                                                    |
  |--------------------------------------------------------------------|
  | **Valid `range` values**                                           |
  | `"1d"`, `"5d"`, `"1mo"`, `"3mo"`, `"6mo"`, `"1y"`, `"5y"`, `"max"` |
  |                                                                    |

- .verbose:

  `logical`, default = `TRUE`. If `TRUE`, send messages to the console.

## Value

A `data.frame` with a historical values :

- symbol:

  `character` - Financial ticker symbol.

- timestamp:

  `POSIXct` - Date of the observation (closing price).

- close:

  `numeric` - Closing price of the asset.

## Details

Return a `data.frame` with additional attributes:

- n.currencies:

  `integer` - Number of unique currencies in the `data.frame`.

- currencies:

  `character` - A vector of currency symbols in the `data.frame` (e.g.,
  `"BTC"`, `"ETH"`, `"USD"`).

- exchange:

  `character` - A vector of exchange pairs (e.g., `"BTC => USD"`). If
  not applicable, `NULL` (no entry).

- date.fetch:

  `Date` - The date when the data was retrieved, set using
  [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html).

- crypto:

  `logical` - `TRUE` if cryptocurrencies are present, otherwise `FALSE`.

- date.begin:

  `POSIXct` - The oldest observation in the dataset.

- date.end:

  `POSIXct` - The most recent observation in the dataset.

- date.dif:

  `numeric` - The number of *seconds* between date.begin and date.end,
  equivalent of `difftime` value.

See
[`vignette("Functions_summary", package = "financr")`](https://clement-lvd.github.io/financr/articles/Functions_summary.md)

## Examples

``` r
histo_light <- get_historic_light(c("SAAB-B.ST", "AAPL"))
```
