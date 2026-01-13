# Retrieve Market Index Summary Latest Data

Return a `data.frame` with latest summary information for a set of major
financial market indices.

## Usage

``` r
last_market_summary(region = NULL, .verbose = TRUE)
```

## Arguments

- region:

  `character`, default = `NULL` (no filtering) - Select a region for
  filter out the results.

  |                                                                                                  |
  |--------------------------------------------------------------------------------------------------|
  | **Valid `region` values**                                                                        |
  | `"US"` , `"AU"` , `"CA"` , `"FR"` , `"DE"` , `"HK"` , `"US"` , `"IT"` , `"ES"` , `"GB"` , `"IN"` |
  |                                                                                                  |

- .verbose:

  `logical`, default = `FALSE` - Logical flag indicating whether to
  print verbose output for debugging or informational purposes.

## Value

A `data.frame` with 15 rows and 38 variables. Each row corresponds to a
market index and includes the following information:

- Information on the asset: `symbol`, `shortname`, `longname`,
  `exchange`, `region`, `currency`

- Market time info, mostly associated with the pricing info:
  `regularmarkettime_raw`, `regularmarkettime_fmt`

- Market pricing info: `regularmarketprice_raw`,
  `regularmarketchange_raw`, `regularmarketchangepercent_raw`, etc.

- Metadata such as `marketstate`, `quotetype`, `pricehint`,
  `exchangedatadelayedby`, `hasprepostmarketdata`

- Other fields such as `cryptotradeable`, `tradeable`, `triggerable`,
  `contracts`, etc.

## References

Source : https://query2.finance.yahoo.com/v6/finance/quote/marketSummary

## See also

For more details on the 'last\_' family of functions see the help
vignette:
[`vignette("last_family", package = "financr")`](https://clement-lvd.github.io/financr/articles/last_family.md)

## Examples

``` r
df <- last_market_summary()

df_fr <- last_market_summary(region = "FR")
```
