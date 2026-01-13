# Get Historic of Devises Exchanges Rates

Get a `data.frame` of historical values of exchanges rates, given
currencies to exchange. Default parameters are a period of 1 year (1
obs. per day), and convert to USD (\$).

## Usage

``` r
get_changes_historic(
  from = NULL,
  to = "USD",
  interval = "1d",
  range = "1y",
  .verbose = T
)
```

## Arguments

- from:

  default = `NULL` A character string representing the base currency
  (e.g., "USD"). The user must provide `from` values with one of the
  following method :

  - passing a paired character list, e.g., c("EUR" = "USD", "RON" =
    "EUR") ;

  - or passing one or several `from` values :

    - associated with a single `to` value, e.g.,
      `from = c('EUR', "RON"), to = "USD"`

    - or associated with a list of `from` values of the same length,
      e.g., `from = c('EUR', "RON"), to = c("USD", "EUR")` .

- to:

  default = `"USD"` A character string representing the target
  currencies, e.g., `c("EUR", "USD")`.

- interval:

  `character`, default = `"1d"`. The interval between 2 rows of the
  time.series answered

  |                                                                                                     |
  |-----------------------------------------------------------------------------------------------------|
  | **Valid `interval` values**                                                                         |
  | `"1m"`, `"2m"`, `"3m"`, `"5m"`, `"15m"`, `"30m"`, `"1h"`, `"4h"`, `"1d"`, `"1wk"`, `"1mo"`, `"3mo"` |
  |                                                                                                     |

- range:

  `character`, default = `"1y"`. The period covered by the time series.

  |                                                                          |
  |--------------------------------------------------------------------------|
  | **Valid `range` values**                                                 |
  | `"1d"`, `"5d"`, `"1m"`, `"3m"`, `"6m"`, `"1y"`, `"5y"`, `"ytd"`, `"all"` |
  |                                                                          |

- .verbose:

  `logical` If TRUE, messages are displayed, e.g., when invalid symbols
  are detected. Default is FALSE.

## Value

A `data.frame` with the historic of exchanges rates on a given period,
default is daily results for a year. The columns are:

- timestamp:

  `POSIXct` - The opening price for the period (default is each day).

- close:

  `numeric` - The closing price for the period (default is each day).

- low:

  `numeric` - The highest price for the period (default is each day).

- open:

  `integer` - The traded volume.

- high:

  `numeric` - The lowest price for the period (default is each day).

- from:

  `character` - The currency converted into another, e.g., if the `from`
  value is 1\$ ('USD'), you want to receive a certain amount of the
  other (`to`) currency to reach 1\$.

- to:

  `character` - The currency exchanged back against a value of 1 of the
  `from` currency. The currencies-related `numeric` values in this line
  of the `data.frame` are expressed with this currency\*\*.

Depending on the desired interval, recent observation will be truncated,
e.g., a `'5y'` range with a `'1d'` interval will answer approximately 30
days of values from 5 years ago.

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

## References

Source : https://query2.finance.yahoo.com/v8/finance/chart/

## See also

[`get_changes`](https://clement-lvd.github.io/financr/reference/get_changes.md)

For more details see the help vignette:
[`vignette("currencies", package = "financr")`](https://clement-lvd.github.io/financr/articles/currencies.md)

## Examples

``` r
convert_to_usd <- get_changes_historic(from = c("EUR", "JPY"))

days_bis <- get_changes_historic(from = c("EUR" = "RON", "USD" = "EUR"))

# (equivalent to the previous line)
# same_as_days_bis <- get_changes_historic(from = c("EUR", "USD"), to =c("RON" , "EUR"))

# Tweak interval and range
months <- get_changes_historic(from = c("EUR", "JPY"), interval = "1mo", range = '5y')
str(months)
#> 'data.frame':    122 obs. of  7 variables:
#>  $ timestamp: POSIXct, format: "2021-02-01 00:00:00" "2021-03-01 00:00:00" ...
#>  $ low      : num  1.2 1.17 1.17 1.2 1.18 ...
#>  $ high     : num  1.22 1.21 1.22 1.23 1.23 ...
#>  $ close    : num  1.21 1.17 1.21 1.22 1.19 ...
#>  $ open     : num  1.21 1.21 1.17 1.2 1.22 ...
#>  $ from     : chr  "EUR" "EUR" "EUR" "EUR" ...
#>  $ to       : chr  "USD" "USD" "USD" "USD" ...
#>  - attr(*, "n.currencies")= int 3
#>  - attr(*, "currencies")= chr [1:3] "EUR" "JPY" "USD"
#>  - attr(*, "exchange")= chr [1:2] "EUR => USD" "JPY => USD"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
#>  - attr(*, "date.begin")= POSIXct[1:1], format: "2021-02-01"
#>  - attr(*, "date.end")= POSIXct[1:1], format: "2026-01-13 22:59:15"
#>  - attr(*, "date.dif")= num 1808
```
