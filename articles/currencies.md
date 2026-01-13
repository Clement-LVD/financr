# Currency-related functions

This vignette presents methods for working with currency exchange rates.

#### get_changes() & get_changes_historic()

- [`get_changes()`](https://clement-lvd.github.io/financr/reference/get_changes.md)
  fetch the latest exchange rate, given currencies symbols :

``` r
library(financr)

changes <- get_changes(from = c("RON", "USD"), to = "EUR")

changes[ , c("from", "to",  "regularmarketprice", "currency", "timestamp")]
#>   from  to regularmarketprice currency           timestamp
#> 1  RON EUR             0.1960      EUR 2026-01-13 22:57:01
#> 2  USD EUR             0.8587      EUR 2026-01-13 22:59:01
```

- Or get the historic of exchange rates, given currencies symbols :

``` r

changes <- get_changes_historic(from = c("EUR", "RON") )

str(changes)
#> 'data.frame':    524 obs. of  7 variables:
#>  $ timestamp: POSIXct, format: "2025-01-13 00:00:00" "2025-01-14 00:00:00" ...
#>  $ low      : num  1.02 1.02 1.03 1.03 1.03 ...
#>  $ high     : num  1.03 1.03 1.04 1.03 1.03 ...
#>  $ close    : num  1.02 1.03 1.03 1.03 1.03 ...
#>  $ open     : num  1.02 1.03 1.03 1.03 1.03 ...
#>  $ from     : chr  "EUR" "EUR" "EUR" "EUR" ...
#>  $ to       : chr  "USD" "USD" "USD" "USD" ...
#>  - attr(*, "n.currencies")= int 3
#>  - attr(*, "currencies")= chr [1:3] "EUR" "RON" "USD"
#>  - attr(*, "exchange")= chr [1:2] "EUR => USD" "RON => USD"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
#>  - attr(*, "date.begin")= POSIXct[1:1], format: "2025-01-13"
#>  - attr(*, "date.end")= POSIXct[1:1], format: "2026-01-13 22:59:27"
#>  - attr(*, "date.dif")= num 366
```

Currencies are indicated with the same syntax across
[`get_changes_historic()`](https://clement-lvd.github.io/financr/reference/get_changes_historic.md)
and
[`get_changes()`](https://clement-lvd.github.io/financr/reference/get_changes.md),
and both are converting to ‘USD’ by default. E.g., pass a named list of
character vectors, or two separate lists of equal length.

``` r
df2_days <- get_changes_historic(from = c("EUR" = "RON", "USD" = "EUR"))
 
same_as_df2_days <- get_changes_historic(from = c("EUR", "USD"), to =c("RON" , "EUR"))
```

**Range and Interval Parameters.** Default is 1 row per day for a 1-year
period if no ‘`interval`’ and ‘`range`’ parameters are indicated. E.g.,
retrieve one observation per month over a five-year period.

``` r
df_month <- get_changes_historic(
  from = c("EUR", "JPY")
  , interval = "1mo", range = '5y')

str(df_month)
#> 'data.frame':    122 obs. of  7 variables:
#>  $ timestamp: POSIXct, format: "2021-02-01 00:00:00" "2021-03-01 00:00:00" ...
#>  $ close    : num  1.21 1.17 1.21 1.22 1.19 ...
#>  $ low      : num  1.2 1.17 1.17 1.2 1.18 ...
#>  $ high     : num  1.22 1.21 1.22 1.23 1.23 ...
#>  $ open     : num  1.21 1.21 1.17 1.2 1.22 ...
#>  $ from     : chr  "EUR" "EUR" "EUR" "EUR" ...
#>  $ to       : chr  "USD" "USD" "USD" "USD" ...
#>  - attr(*, "n.currencies")= int 3
#>  - attr(*, "currencies")= chr [1:3] "EUR" "JPY" "USD"
#>  - attr(*, "exchange")= chr [1:2] "EUR => USD" "JPY => USD"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
#>  - attr(*, "date.begin")= POSIXct[1:1], format: "2021-02-01"
#>  - attr(*, "date.end")= POSIXct[1:1], format: "2026-01-13 22:59:29"
#>  - attr(*, "date.dif")= num 1808
```

------------------------------------------------------------------------

### last_currencies()

Get a `data.frame` of currencies symbols and names.

``` r
currencies <- last_currencies()
str(currencies)
#> 'data.frame':    160 obs. of  4 variables:
#>  $ shortname    : chr  "FJD" "MXN" "SCR" "CDF" ...
#>  $ longname     : chr  "Fijian Dollar" "Mexican Peso" "Seychellois Rupee" "Congolese Franc" ...
#>  $ symbol       : chr  "FJD" "MXN" "SCR" "CDF" ...
#>  $ locallongname: chr  "Fijian Dollar" "Mexican Peso" "Seychellois Rupee" "Congolese Franc" ...
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
```

It is helpful to understand the currency symbols used by the Yahoo
Finance API, such as those found in the currency column of the
`data.frame` returned by
[`get_historic()`](https://clement-lvd.github.io/financr/reference/get_historic.md).

**Parameters.**

- Add the latest market values (‘USD’) for each currency with
  ‘`add_usd_values`’ parameter,

- And/or filter symbols with the ‘`keep`’ parameter (case insensitive).
  Hereafter we filter out the results with a regular expression.

``` r
few_currencies <- last_currencies(keep = c("R.N",  "^Z")
                                  , get_changes = T )
few_currencies
#>   symbol shortname           longname      locallongname currency exchangename
#> 1    RON       RON       Romanian Leu       Romanian Leu      USD          CCY
#> 2    ZAR       ZAR South African Rand South African Rand      USD          CCY
#> 3    ZMW       ZMW                ZMW                ZMW      USD          CCY
#>   instrumenttype      firsttradedate gmtoffset timezone exchangetimezonename
#> 1       CURRENCY 2005-06-30 23:00:00         0      GMT        Europe/London
#> 2       CURRENCY 2003-12-01 00:00:00         0      GMT        Europe/London
#> 3       CURRENCY 2013-01-03 00:00:00         0      GMT        Europe/London
#>   regularmarketprice regularmarketdayhigh regularmarketdaylow fiftytwoweekhigh
#> 1             0.2288               0.2290              0.2288           0.2348
#> 2             0.0610               0.0611              0.0610           0.0648
#> 3             0.0515               0.0515              0.0511           0.0518
#>   fiftytwoweeklow previousclose regular_timezone  to           timestamp
#> 1          0.2055        0.2295              GMT USD 2026-01-13 22:59:29
#> 2          0.0502        0.0610              GMT USD 2026-01-13 22:59:29
#> 3          0.0345        0.0514              GMT USD 2026-01-13 21:45:14
```
