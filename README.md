
# `financr`

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[![CRAN
status](https://www.r-pkg.org/badges/version/financr)](https://CRAN.R-project.org/package=financr)
[![Codecov test
coverage](https://codecov.io/gh/Clement-LVD/financr/graph/badge.svg)](https://app.codecov.io/gh/Clement-LVD/financr)
[![R-CMD-check](https://github.com/Clement-LVD/financr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Clement-LVD/financr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

<figure>
<img
src="https://img.shields.io/badge/Package-bold?style=flat&amp;logoColor=black&amp;logoSize=2&amp;label=R&amp;labelColor=black&amp;color=green"
alt=" " />
<figcaption aria-hidden="true"> </figcaption>
</figure>

Retrieves financial data from Yahoo Finance.

- Historical market data :
  - values of assets
  - currencies exchange rates
- Latest values of major assets, e.g., world-level indices, currencies
  and cryptocurrencies
- Other insights, e.g., latest market summary, assets association
  (related to each other), symbol validation

Functions are divided into 3 family :

- ‘search\_’ assets from free-texts
- ‘get\_’ latest or historical values from symbol
- ‘last\_’ market summary, latest values of major assets, currencies,
  etc.

See the [vignette ‘Summary of financr
Functions’](https://clement-lvd.github.io/financr/articles/Functions_summary.html).

## Installation

You can install the development version of financr:

``` r
devtools::install_github("clement-LVD/financr")
```

## Examples

**Get ticker symbol from free-texts.** Given keyword(s) such as
companies names, search symbols with `search_assets()`.

``` r
library(financr)

indices <- search_assets(c("Dow jones"
                           , "euronext")
                         , type = "index" )

str(indices)
#> 'data.frame':    9 obs. of  10 variables:
#>  $ symbol        : chr  "^DJI" "^DWCPF" "^DWRTF" "^N100" ...
#>  $ shortname     : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Completion Total" "Dow Jones U.S. Select REIT Inde" "Euronext 100 Index" ...
#>  $ longname      : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Completion Total" "Dow Jones U.S. Select REIT Inde" "Euronext 100 Index" ...
#>  $ exchange      : chr  "DJI" "DJI" "DJI" "PAR" ...
#>  $ exchdisp      : chr  "Dow Jones" "Dow Jones" "Dow Jones" "Paris" ...
#>  $ quotetype     : chr  "INDEX" "INDEX" "INDEX" "INDEX" ...
#>  $ typedisp      : chr  "Index" "Index" "Index" "Index" ...
#>  $ score         : num  35777 20125 20116 20011 20005 ...
#>  $ isyahoofinance: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#>  $ searched      : chr  "dow jones" "dow jones" "dow jones" "euronext" ...
#>  - attr(*, "date.fetch")= Date[1:1], format: "2025-04-07"
#>  - attr(*, "crypto")= logi FALSE
```

Optionally use the ‘`get_values`’ parameter to add latest prices to
these results.

``` r
indices2 <- search_assets(
  c("Dow jones", "euronext")
  , type = "index"
  , get_values = TRUE )

str(indices2)
#> 'data.frame':    9 obs. of  28 variables:
#>  $ symbol              : chr  "^DJI" "^DWCPF" "^DWRTF" "^N100" ...
#>  $ shortname           : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Completion Total" "Dow Jones U.S. Select REIT Inde" "Euronext 100 Index" ...
#>  $ longname            : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Completion Total" "Dow Jones U.S. Select REIT Inde" "Euronext 100 Index" ...
#>  $ exchange            : chr  "DJI" "DJI" "DJI" "PAR" ...
#>  $ exchdisp            : chr  "Dow Jones" "Dow Jones" "Dow Jones" "Paris" ...
#>  $ quotetype           : chr  "INDEX" "INDEX" "INDEX" "INDEX" ...
#>  $ typedisp            : chr  "Index" "Index" "Index" "Index" ...
#>  $ score               : num  35777 20125 20116 20011 20004 ...
#>  $ isyahoofinance      : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#>  $ searched            : chr  "dow jones" "dow jones" "dow jones" "euronext" ...
#>  $ currency            : chr  "USD" "USD" "USD" "EUR" ...
#>  $ exchangename        : chr  "DJI" "DJI" "DJI" "PAR" ...
#>  $ fullexchangename    : chr  "DJI" "DJI" "DJI" "Paris" ...
#>  $ instrumenttype      : chr  "INDEX" "INDEX" "INDEX" "INDEX" ...
#>  $ firsttradedate      : POSIXct, format: "1992-01-02 15:30:00" "2006-08-24 15:30:00" ...
#>  $ regularmarkettime   : POSIXct, format: "2025-04-07 22:20:01" "2025-04-07 22:20:04" ...
#>  $ hasprepostmarketdata: logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ gmtoffset           : int  -14400 -14400 -14400 7200 7200 7200 7200 7200 7200
#>  $ timezone            : chr  "EDT" "EDT" "EDT" "CEST" ...
#>  $ exchangetimezonename: chr  "America/New_York" "America/New_York" "America/New_York" "Europe/Paris" ...
#>  $ regularmarketprice  : num  37966 1838 262 1370 968 ...
#>  $ fiftytwoweekhigh    : num  45074 2471 273 1619 968 ...
#>  $ fiftytwoweeklow     : num  36612 1748 256 1337 968 ...
#>  $ regularmarketdayhigh: num  39207 1922 273 1436 968 ...
#>  $ regularmarketdaylow : num  36612 1748 256 1337 968 ...
#>  $ regularmarketvolume : int  1361906582 0 0 0 0 NA 0 NA NA
#>  $ chartpreviousclose  : num  38315 1852 270 1436 989 ...
#>  $ previousclose       : num  38315 1852 270 1436 989 ...
#>  - attr(*, "n.currencies")= int 2
#>  - attr(*, "currencies")= chr [1:2] "USD" "EUR"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2025-04-07"
#>  - attr(*, "crypto")= logi FALSE
#>  - attr(*, "date.begin")= POSIXct[1:1], format: "2025-04-04 22:40:17"
#>  - attr(*, "date.end")= POSIXct[1:1], format: "2025-04-07 22:20:04"
#>  - attr(*, "date.dif")= num 2.99
```

Exploring the results of `search_assets()` is a way to find the symbol
of an asset. `search_assets_quick()` is a variant.

**Get historical financial data.** Given ticker symbol(s), get
historical financial data with `financr::get_historic()`. Default
interval is daily values.

``` r
histo <- get_historic(
  c("SAAB-B.ST", "VOLV-B.ST")
  , .verbose = FALSE)

str(histo)
#> 'data.frame':    1016 obs. of  20 variables:
#>  $ open                : num  344 341 318 NA NA ...
#>  $ close               : num  341 320 311 NA NA ...
#>  $ low                 : num  341 319 311 NA NA ...
#>  $ high                : num  344 343 321 NA NA ...
#>  $ volume              : int  0 78309 35678 NA NA 226045 61094 NA NA 107462 ...
#>  $ timestamp           : int  1744009320 1744009380 1744009440 1744009500 1744009560 1744009620 1744009680 1744009740 1744009800 1744009860 ...
#>  $ date                : POSIXct, format: "2025-04-07 09:02:00" "2025-04-07 09:03:00" ...
#>  $ currency            : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol              : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname           : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ longname            : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ exchangename        : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone            : chr  "CEST" "CEST" "CEST" "CEST" ...
#>  $ gmtoffset           : int  7200 7200 7200 7200 7200 7200 7200 7200 7200 7200 ...
#>  $ regularmarketprice  : num  370 370 370 370 370 ...
#>  $ fiftytwoweeklow     : num  204 204 204 204 204 ...
#>  $ fiftytwoweekhigh    : num  420 420 420 420 420 420 420 420 420 420 ...
#>  $ regularmarketdaylow : num  311 311 311 311 311 ...
#>  $ regularmarketdayhigh: num  382 382 382 382 382 382 382 382 382 382 ...
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2025-04-07"
#>  - attr(*, "crypto")= logi FALSE
#>  - attr(*, "date.begin")= int 1744009320
#>  - attr(*, "date.end")= int 1744039740
#>  - attr(*, "date.dif")= num 30420
```

## Vignettes

- [Summary of financr
  functions](https://clement-lvd.github.io/financr/articles/Functions_summary.html).

- [The ‘last\_ family’ of
  functions](https://clement-lvd.github.io/financr/articles/last_family.html).

- [Currency-related
  functions](https://clement-lvd.github.io/financr/articles/currencies.html).

- [The example
  Vignette](https://clement-lvd.github.io/financr/articles/example.html).

**Yahoo Finance API Licence.** This package retrieves data from Yahoo
Finance, a property of Yahoo Inc. Users must comply with [Yahoo
Finance’s API
terms](https://legal.yahoo.com/us/en/yahoo/terms/product-atos/apiforydn/index.html).
See more informations on the [legal
Vignette](https://clement-lvd.github.io/financr/articles/About_the_Yahoo_Finance_License.html).
