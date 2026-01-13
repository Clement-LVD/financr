# Get Latest Exchange Rates For Devises

Returns a `data.frame` with the latest exchange rate(s) for the given
currencies. Default will convert to USD (\$).

## Usage

``` r
get_changes(from = NULL, to = "USD", .verbose = T, ...)
```

## Arguments

- from, :

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

- to, :

  default = `"USD"` A character string representing the target
  currencies, e.g., `c("EUR", "USD")`.

- .verbose:

  `logical` If TRUE, messages are displayed, e.g., when invalid symbols
  are detected. Default is FALSE.

- ...:

  (internal use : the user have
  [`get_changes_historic()`](https://clement-lvd.github.io/financr/reference/get_changes_historic.md)
  to pass `range` and `interval` parameters)

## Value

The returned `data.frame` contains daily exchange rates, and the
following columns:

- currency:

  `character` - The base currency.

- symbol:

  `character` - The Yahoo Finance symbol (e.g., "EURUSD=X").

- exchangename:

  `character` - The exchange place name, i.e. 'CCY' for currencies.

- intrumenttype:

  `character` - The type of financial instrument, supposed to be
  'CURRENCY'.

- firsttradedate:

  `POSIXct` - The oldest date available on the Yahoo Finance API for an
  exchange rates historic.

- gmtoffset:

  `numeric` - The difference with GMT time (seconds).

- timezone:

  `character` - The market's timezone.

- exchangetimezonename:

  `character` - The name of the market's timezone, e.g.,
  'Europe/London'.

- regularmarketprice:

  `numeric` - The latest market price.

- regularmarketdayhigh:

  `numeric` - The market highest price of this day.

- regularmarketdaylow:

  `numeric` - The market lowest price of this day.

- fiftytwoweekhigh:

  `numeric` - The highest price in the last 52 weeks.

- fiftytwoweeklow:

  `numeric` - The lowest price in the last 52 weeks.

- previousclose:

  `numeric` - The last closing price.

- regular_timezone:

  `character` - The regular market's timezone.

- from:

  `character` - The currency converted, exchange rate is a value of 1 of
  this currency against another currency.

- to:

  `character` - The currency exchanged back in return: most of the
  currency-related `numeric` values of the row are expressed with this
  currency.

- timestamp:

  `POSIXct` - The corresponding date (YYYY-MM-DD).

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

For more details on currencies-related functions, see:
[`vignette("currencies", package = "financr")`](https://clement-lvd.github.io/financr/articles/currencies.md)

## Examples

``` r
if (FALSE) { # \dontrun{
df <- get_changes(from = c("EUR", "JPY"))
str(df)
df2 <- get_changes(from = c("EUR" = "RON", "USD" = "EUR"))
same_as_df2 <- get_changes(from = c("EUR", "USD"), to =c("RON" , "EUR"))
str(same_as_df2)
} # }
```
