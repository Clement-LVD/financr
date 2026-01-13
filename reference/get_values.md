# Retrieve latest financial data

Get latest insights, given financial symbols. Data such as latest prices
and trading context are returned.

## Usage

``` r
get_values(symbols = c("AAPL", "GOOGL"), .verbose = F)
```

## Arguments

- symbols:

  Character vector. One or more asset symbols (e.g.,
  `c("AAPL", "GOOGL")`).

- .verbose:

  Logical. If TRUE, displays verbose output during the fetching process.
  Default is FALSE.

## Value

A `data.frame` with 1 row per valid financial symbol and 21 columns,
including:

- currency:

  `character` - Trading currency of the asset (e.g., "USD").

- symbol:

  `character` - Symbol of the asset, e.g., ticker symbol.

- exchangename:

  `character` - Abbreviated exchange place or financial instrument name.

- fullexchangename:

  `character` - Full name of the exchange place or financial instrument.

- instrumenttype:

  `character` - Type of financial instrument (e.g., "EQUITY").

- firsttradedate:

  `POSIXct` - Datetime when the asset was first traded.

- regularmarkettime:

  `POSIXct` - Timestamp of the latest regular market quote.

- hasprepostmarketdata:

  `logical` - Indicates if pre/post-market data is available.

- gmtoffset:

  `integer` - Offset from GMT in seconds.

- timezone:

  `character` - Abbreviated timezone name of the market.

- exchangetimezonename:

  `character` - Timezone name of the exchange location.

- regularmarketprice:

  `numeric` - Latest regular market trading price.

- fiftytwoweekhigh:

  `numeric` - Highest price over a 52-weeks period.

- fiftytwoweeklow:

  `numeric` - Lowest price over a 52-weeks period.

- regularmarketdayhigh:

  `numeric` - Highest price during the current market day.

- regularmarketdaylow:

  `numeric` - Lowest price during the current market day.

- regularmarketvolume:

  `integer` - Volume traded during the current market day.

- shortname:

  `character` - Shortened or common name of the asset.

- chartpreviousclose:

  `numeric` - Closing price shown in charts.

- previousclose:

  `numeric` - Previous official market close price.

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

## Examples

``` r
get_values(c("AAPL", "GOOGL","SAAB-B.ST"))
#>   currency    symbol exchangename fullexchangename instrumenttype
#> 1      USD      AAPL          NMS         NasdaqGS         EQUITY
#> 2      USD     GOOGL          NMS         NasdaqGS         EQUITY
#> 3      SEK SAAB-B.ST          STO        Stockholm         EQUITY
#>        firsttradedate   regularmarkettime hasprepostmarketdata gmtoffset
#> 1 1980-12-12 14:30:00 2026-01-13 21:00:02                 TRUE    -18000
#> 2 2004-08-19 13:30:00 2026-01-13 21:00:01                 TRUE    -18000
#> 3 2000-01-03 08:00:00 2026-01-13 16:29:46                FALSE      3600
#>   timezone exchangetimezonename regularmarketprice fiftytwoweekhigh
#> 1      EST     America/New_York             261.05           288.62
#> 2      EST     America/New_York             335.97           340.48
#> 3      CET     Europe/Stockholm             704.10           709.80
#>   fiftytwoweeklow regularmarketdayhigh regularmarketdaylow regularmarketvolume
#> 1          169.21               261.81              258.39            41482227
#> 2          140.53               340.48              333.62            33429925
#> 3          208.00               709.80              679.80             3709372
#>        shortname chartpreviousclose previousclose
#> 1     Apple Inc.             260.25        260.25
#> 2  Alphabet Inc.             331.86        331.86
#> 3 SAAB AB ser. B             695.80        695.80
```
