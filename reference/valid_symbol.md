# Validate Financial Symbols

Checks the validity of financial symbols using Yahoo Finance's
validation API. Return a `data.frame` of `logical` values indicating
whether each symbol is recognized by Yahoo Finance.

## Usage

``` r
valid_symbol(symbols = NULL, ..., .verbose = T)
```

## Arguments

- symbols:

  `character` A string or a list of character strings representing
  financial symbols to validate.

- ...:

  Other symbols (char. or list of char.)

- .verbose:

  `logical` If TRUE, messages are displayed when invalid symbols are
  detected. Default is TRUE.

## Value

A `data.frame` boolean `logical` table with one row and as many columns
as the number of unique symbols provided by the user. Each column
corresponds to a symbol, and the `logical` value is `TRUE` if Yahoo
Finance recognizes the symbol, and `FALSE` otherwise.

## References

Source : https://query2.finance.yahoo.com/v6/finance/quote/validate

## Examples

``` r
valid_symbol("AAPL,GOOGL")
#>   GOOGL AAPL
#> 1  TRUE TRUE
valid_symbol(symbols = c("CDF", "SCR", "INVALID"))
#> Invalid financial symbol(s) : CDF, SCR, INVALID
#>     CDF   SCR INVALID
#> 1 FALSE FALSE   FALSE
```
