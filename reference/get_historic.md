# Get Historical Financial Data

Get the historic of stock market data for financial ticker symbols,
e.g., values at each closing day.

## Usage

``` r
get_historic(symbols = c("SAAB-B.ST"), wait.time = 0, .verbose = T, ...)
```

## Arguments

- symbols:

  `character` - A character string representing the financial indices to
  search for, e.g., ticker symbol(s).

- wait.time:

  `double`, default = `0` - A character string representing an
  additional waiting time between 2 calls to the Yahoo API.

- .verbose:

  `logical`, default = `TRUE` - If `TRUE`, send messages to the console.

- ...:

  Arguments passed on to
  [`get_yahoo_data`](https://clement-lvd.github.io/financr/reference/get_yahoo_data.md)

  `symbol`

  :   `character` - A character string representing the symbol for the
      financial instrument (e.g., "AAPL" for Apple).

  `start_date`

  :   `character` - A character string representing the start date in R
      `date` format (UTC time). If `NULL`, data starts from 1970-01-01.

  `end_date`

  :   `character` - A character string representing the end date in a
      valid R `date` format (UTC time). If `NULL`, data is retrieved up
      to the current date.

  `range`

  :   `character` - A character string representing the range for the
      returned datas : default will return daily values.

      |                                                                                                 |
      |-------------------------------------------------------------------------------------------------|
      | **Valid `range` values**                                                                        |
      | `"1d"`, `"5d"`, `"1mo"`, `"3mo"`, `"6mo"`, `"1y"`, `"2y"`, `"5y"`, `"10y"`, `"ytd"` and `"max"` |
      |                                                                                                 |

## Value

A `data.frame` containing the historical financial data with the
following columns:

- open:

  `numeric` The opening price for the period (default is each day).

- close:

  `numeric` The closing price for the period (default is each day).

- low:

  `numeric` The lowest price for the period (default is each day).

- high:

  `numeric` The highest price for the period (default is each day).

- volume:

  `integer` The traded volume.

- timestamp:

  `integer` Unix timestamps corresponding to each data point.

- date:

  `POSIXct` The day of the financial data point.

- currency:

  `character` The currency in which the data is reported, depending on
  the marketplace.

- symbol:

  `character` The stock or financial instrument symbol (e.g., "AAPL").

- shortname:

  `character` The abbreviated name of the company or financial
  instrument.

- longname:

  `character` The full name of the company or financial instrument.

- exchangename:

  `character` The name of the exchange marketplace where the financial
  instrument is listed.

- fullexchangename:

  `character` The full name of the exchange marketplace.

- timezone:

  `character` The timezone in which the data is reported.

- gmtoffset:

  `integer` The UNIX timestamp of difference between the market local
  time and the GMT time.

- regularMarketPrice:

  `numeric` The actual price if market is open, or last closing price if
  not.

- fiftyTwoWeekLow:

  `numeric` Lowest price for the last 52 weeks.

- fiftyTwoWeekHigh:

  `numeric` Highest price for the last 52 weeks.

- regularMarketDayHigh:

  `numeric` The highest price of the day (local exchange place day).

- regularMarketDayLow:

  `numeric` The lowest price of the day (local exchange place day).

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

Source : https://query1.finance.yahoo.com/v8/finance/chart/

## See also

[`get_yahoo_data`](https://clement-lvd.github.io/financr/reference/get_yahoo_data.md)

For more details see the help vignette:
`vignette("get_info_and_historic", package = "financr")`

## Examples

``` r
datas <- get_historic(symbols = c("VOLCAR-B.ST", "SAAB-B.ST") )
str(datas)
#> 'data.frame':    1020 obs. of  20 variables:
#>  $ open                : num  32.5 32.2 32.3 32.2 32.3 ...
#>  $ close               : num  32.3 32.3 32.3 32.3 32.3 ...
#>  $ low                 : num  32.2 32.2 32.2 32.2 32.3 ...
#>  $ high                : num  32.5 32.3 32.3 32.3 32.3 ...
#>  $ volume              : int  0 5503 9528 3928 395 2079 26656 3851 7439 10 ...
#>  $ timestamp           : int  1768291200 1768291260 1768291320 1768291380 1768291440 1768291500 1768291560 1768291620 1768291680 1768291740 ...
#>  $ date                : POSIXct, format: "2026-01-13 08:00:00" "2026-01-13 08:01:00" ...
#>  $ currency            : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol              : chr  "VOLCAR-B.ST" "VOLCAR-B.ST" "VOLCAR-B.ST" "VOLCAR-B.ST" ...
#>  $ shortname           : chr  "Volvo Car AB ser. B" "Volvo Car AB ser. B" "Volvo Car AB ser. B" "Volvo Car AB ser. B" ...
#>  $ longname            : chr  "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" "Volvo Car AB (publ.)" ...
#>  $ exchangename        : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone            : chr  "CET" "CET" "CET" "CET" ...
#>  $ gmtoffset           : int  3600 3600 3600 3600 3600 3600 3600 3600 3600 3600 ...
#>  $ regularmarketprice  : num  32.2 32.2 32.2 32.2 32.2 ...
#>  $ fiftytwoweeklow     : num  15.9 15.9 15.9 15.9 15.9 ...
#>  $ fiftytwoweekhigh    : num  36.5 36.5 36.5 36.5 36.5 ...
#>  $ regularmarketdaylow : num  31.6 31.6 31.6 31.6 31.6 ...
#>  $ regularmarketdayhigh: num  32.5 32.5 32.5 32.5 32.5 ...
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
#>  - attr(*, "date.begin")= int 1768291200
#>  - attr(*, "date.end")= int 1768321740
#>  - attr(*, "date.dif")= num 30540
```
