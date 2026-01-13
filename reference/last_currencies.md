# Get Currencies Names, Symbols and Add Latest 'USD' Values

Return a `data.frame` of financial indices (currencies) given a vector
of symbols, e.g., 'EUR'. Optionally, it can filter the results and add
the last market price ('USD') of these currencies.

## Usage

``` r
last_currencies(keep = NULL, get_changes = F, .verbose = T)
```

## Arguments

- keep:

  `character` - Character vector of symbols to filter the results (perl
  expression, ignoring case). If `NULL` (default), no filtering is
  applied, and all available indices are returned.

- get_changes:

  `logical`, default = `FALSE` - If `TRUE`, add latest market values
  ('USD') from
  [`get_changes()`](https://clement-lvd.github.io/financr/reference/get_changes.md).
  See
  [`get_changes()`](https://clement-lvd.github.io/financr/reference/get_changes.md)
  for the base structure.

- .verbose:

  `logical`, default = `TRUE` - If `TRUE`, send messages to the console
  if necessary.

## Value

A `data.frame` containing unique financial indices (currencies). The
table has columns like `symbol`, `name`, and other relevant information,
with all column names in lowercase. If `keep` is specified, only the
matching currencies are returned. If `get_changes` is specified, last
market values in 'USD' will be added, see
[`get_changes()`](https://clement-lvd.github.io/financr/reference/get_changes.md).

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

Source : https://query2.finance.yahoo.com/v1/finance/currencies

## See also

[`get_changes`](https://clement-lvd.github.io/financr/reference/get_changes.md)

For more details see the help vignette:
[`vignette("currencies", package = "financr")`](https://clement-lvd.github.io/financr/articles/currencies.md)

## Examples

``` r
# Fetch all available indices
all_indices <- last_currencies( keep = "LBP" , get_changes = TRUE)

# Fetch only specific indices
selected_indices <- last_currencies(keep = c("^Z", "EUR"))
```
