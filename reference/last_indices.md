# Get World Financial Indices Latest Values (USD)

Get latest stock market indices values and data for more than 40
world-indices, e.g., latest prices, change and percentage change.

## Usage

``` r
last_indices(.verbose = T, keep = NULL)
```

## Arguments

- .verbose:

  `logical`, default = `TRUE` - If `TRUE`, send messages to the console
  if necessary.

- keep:

  `character` - Character vector of symbols to filter the results (perl
  expression, ignoring case). If `NULL` (default), no filtering is
  applied, and all available indices are returned.

## Value

A data frame with the following columns:

- symbol:

  `character` - Ticker symbol of the index, aka world indices (e.g.,
  `'^GSPC'` for S&P 500).

- name:

  `character` - Full name of the index (e.g., "S&P 500").

- price:

  `numeric` - Current value of the index (USD).

- change:

  `numeric` - Absolute change in index value since the last closing of
  the exchange place.

- change_percent:

  `numeric` - Percentage change in index value since the last closing of
  the exchange place.

- volume:

  `numeric` - The total trading volume of the index components.

- currency:

  `character` - Currency associated with the world-indice, i.e. 'USD'.

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

Source : Yahoo's world indices page -
https://finance.yahoo.com/markets/world-indices

## See also

For more details on the 'last\_' family of functions see the help
vignette:
[`vignette("last_family", package = "financr")`](https://clement-lvd.github.io/financr/articles/last_family.md)

## Examples

``` r
if (FALSE) { # \dontrun{
indices <- last_indices()
head(indices)
} # }
```
