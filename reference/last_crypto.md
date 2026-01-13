# Get Latest Cryptocurrencies Values (USD) and Market Data

Return a `data.frame` of latest financial data for 100 cryptocurrencies,
e.g., actual values of each cryptocurrency in USD.

## Usage

``` r
last_crypto(keep = NULL, .verbose = T)
```

## Arguments

- keep:

  `character` - Character vector of symbols to filter the results (perl
  expression, ignoring case). If `NULL` (default), no filtering is
  applied, and all available indices are returned.

- .verbose:

  `logical`, default = `TRUE` - If `TRUE`, send messages to the console
  if necessary.

## Value

A data frame with 100 observations and 13 variables:

- symbol:

  `character` - Cryptocurrency ticker symbol.

- name:

  `character` - Name of the cryptocurrency, along with its quoted
  'real-world' currency.

- price:

  `numeric` - Current price of the cryptocurrency in USD (\$).

- change:

  `numeric` - Absolute price change in USD since the last closing of the
  exchange place.

- change_percent:

  `numeric` - Percentage price change since the last closing of the
  exchange place (%).

- market_cap:

  `numeric` - Total market capitalization of the cryptocurrency.

- volume:

  `numeric` - 24-hour trading volume.

- volume_in_currency_24hr:

  `numeric` - 24-hour trading volume in the associated 'real-world'
  currency (most of the time redundant with the `volume` column).

- total_volume_all_currencies_24hr:

  `numeric` - 24-hour total trading volume across all currency pairs.

- circulating_supply:

  `numeric` - Total circulating supply of the cryptocurrency.

- x52_wk_change_percent:

  `numeric` - Percentage change in price over the last 52 weeks (%).

- from:

  `character` - The currency converted into another, e.g., if the `from`
  value is 1\$ ('USD'), you want to receive a certain amount of the
  other currency to reach 1\$.

- to:

  `character` - The currency that you want to convert into : all the
  currency-related `numeric` values in this line of the `data.frame` are
  expressed with this currency.

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

Source : Yahoo Finance 'crypto' page,
<https://finance.yahoo.com/markets/crypto/all/>

## See also

For more details on the 'last\_' family of functions see the help
vignette:
[`vignette("last_family", package = "financr")`](https://clement-lvd.github.io/financr/articles/last_family.md)

## Examples

``` r
krypto <- last_crypto()
head(krypto)
#>     symbol            name  change change_percent  market_cap      volume
#> 1  BTC-USD     Bitcoin USD 4428.37           4.86 1.90900e+12 5.25980e+10
#> 2  ETH-USD    Ethereum USD  234.15           7.57 4.01588e+11 2.63760e+10
#> 3 USDT-USD Tether USDt USD    0.00           0.06 1.86865e+11 1.07866e+11
#> 4  XRP-USD         XRP USD    0.12           5.80 1.31795e+11 3.56600e+09
#> 5  BNB-USD         BNB USD   40.72           4.50 1.30277e+11 3.22600e+09
#> 6  SOL-USD      Solana USD    7.62           5.47 8.29760e+10 6.53500e+09
#>   volume_in_currency_24hr total_volume_all_currencies_24hr circulating_supply
#> 1             5.25980e+10                      5.25980e+10        1.99760e+07
#> 2             2.63760e+10                      2.63760e+10        1.20695e+08
#> 3             1.07866e+11                      1.07866e+11        1.86933e+11
#> 4             3.56600e+09                      3.56600e+09        6.07000e+10
#> 5             3.22600e+09                      3.22600e+09        1.37733e+08
#> 6             6.53500e+09                      6.53500e+09        5.65201e+08
#>   x52_wk_change_percent x52_wk_range1 x52_wk_range2    price from  to
#> 1                 -5.53      74436.68     126198.07 95587.60  BTC USD
#> 2                 -4.07       1386.80       4953.73  3327.30  ETH USD
#> 3                 -0.08          1.00          1.01     1.00 USDT USD
#> 4                -23.10          1.53          3.65     2.17  XRP USD
#> 5                 29.60        509.84       1370.55   945.86  BNB USD
#> 6                -25.79         96.59        294.33   146.81  SOL USD
```
