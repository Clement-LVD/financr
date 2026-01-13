# Find Similar Financial Symbols

Given symbol(s), retrieve identical symbols (according to Yahoo Finance)
and a score of similarity.

## Usage

``` r
get_similar(symbols = "SAAB-B.ST", .verbose = F, ...)
```

## Arguments

- symbols:

  `character` - A character string representing a financial symbol to
  search.

- .verbose:

  `logical` - If TRUE, messages are displayed when invalid symbols are
  detected. Default is TRUE.

- ...:

  - Other symbols (char. or list of char.)

## Value

A `data.frame` with the symbols associated with those provided by the
user and similarity scores, according to Yahoo Finance.

- from:

  `character` - Financial symbol provided by the user.

- symbol:

  `character` - Symbol associated with the other 'from' symbol.

- score:

  `numeric` - Similarity score, according to Yahoo Finance.

## References

Source : https://query2.finance.yahoo.com/v6/finance/quote/validate

## Examples

``` r
get_similar(symbols =   "AAPL,GOOGL")
#>          from symbol    score
#> AAPL.1   AAPL   AMZN 0.226553
#> AAPL.2   AAPL   TSLA 0.213704
#> AAPL.3   AAPL   GOOG 0.199551
#> AAPL.4   AAPL   META 0.191065
#> AAPL.5   AAPL   MSFT 0.170397
#> GOOGL.1 GOOGL   NFLX 0.122028
#> GOOGL.2 GOOGL   BABA 0.120002
#> GOOGL.3 GOOGL   AVGO 0.118111
#> GOOGL.4 GOOGL      V 0.116899
#> GOOGL.5 GOOGL   PYPL 0.114654
get_similar(symbols =   c("AAPL", "GOOGL"))
#>          from symbol    score
#> AAPL.1   AAPL   AMZN 0.226553
#> AAPL.2   AAPL   TSLA 0.213704
#> AAPL.3   AAPL   GOOG 0.199551
#> AAPL.4   AAPL   META 0.191065
#> AAPL.5   AAPL   MSFT 0.170397
#> GOOGL.1 GOOGL   NFLX 0.122028
#> GOOGL.2 GOOGL   BABA 0.120002
#> GOOGL.3 GOOGL   AVGO 0.118111
#> GOOGL.4 GOOGL      V 0.116899
#> GOOGL.5 GOOGL   PYPL 0.114654
```
