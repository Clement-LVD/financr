
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

Functions are divided into three families:

- ‘search\_’: Search for assets using free-text queries
- ‘get\_’: Retrieve the latest or historical values for symbols
- ‘last\_’: Get market summaries, including the latest values of major
  assets, currencies, and more

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
#>  $ score         : num  58307 20358 20271 20013 20005 ...
#>  $ isyahoofinance: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#>  $ searched      : chr  "dow jones" "dow jones" "dow jones" "euronext" ...
#>  - attr(*, "date.fetch")= Date[1:1], format: "2025-04-08"
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
#>  $ score               : num  58307 20358 20271 20013 20004 ...
#>  $ isyahoofinance      : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#>  $ searched            : chr  "dow jones" "dow jones" "dow jones" "euronext" ...
#>  $ currency            : chr  "USD" "USD" "USD" "EUR" ...
#>  $ exchangename        : chr  "DJI" "DJI" "DJI" "PAR" ...
#>  $ fullexchangename    : chr  "DJI" "DJI" "DJI" "Paris" ...
#>  $ instrumenttype      : chr  "INDEX" "INDEX" "INDEX" "INDEX" ...
#>  $ firsttradedate      : POSIXct, format: "1992-01-02 15:30:00" "2006-08-24 15:30:00" ...
#>  $ regularmarkettime   : POSIXct, format: "2025-04-08 21:21:04" "2025-04-08 21:21:04" ...
#>  $ hasprepostmarketdata: logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ gmtoffset           : int  -14400 -14400 -14400 7200 7200 7200 7200 7200 7200
#>  $ timezone            : chr  "EDT" "EDT" "EDT" "CEST" ...
#>  $ exchangetimezonename: chr  "America/New_York" "America/New_York" "America/New_York" "Europe/Paris" ...
#>  $ regularmarketprice  : num  37585 1786 257 1406 982 ...
#>  $ fiftytwoweekhigh    : num  45074 2471 269 1619 982 ...
#>  $ fiftytwoweeklow     : num  36612 1748 257 1337 982 ...
#>  $ regularmarketdayhigh: num  39427 1908 269 1421 982 ...
#>  $ regularmarketdaylow : num  37521 1782 257 1375 982 ...
#>  $ regularmarketvolume : int  782659263 0 0 0 0 NA 0 NA NA
#>  $ chartpreviousclose  : num  37966 1838 262 1370 968 ...
#>  $ previousclose       : num  37966 1838 262 1370 968 ...
#>  - attr(*, "n.currencies")= int 2
#>  - attr(*, "currencies")= chr [1:2] "USD" "EUR"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2025-04-08"
#>  - attr(*, "crypto")= logi FALSE
#>  - attr(*, "date.begin")= POSIXct[1:1], format: "2025-04-07 22:40:13"
#>  - attr(*, "date.end")= POSIXct[1:1], format: "2025-04-08 21:21:04"
#>  - attr(*, "date.dif")= num 22.7
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
#> 'data.frame':    1020 obs. of  20 variables:
#>  $ open                : num  382 383 387 388 391 ...
#>  $ close               : num  383 387 388 391 387 ...
#>  $ low                 : num  382 383 385 387 387 ...
#>  $ high                : num  387 388 388 391 392 ...
#>  $ volume              : int  0 82991 66592 48022 56124 42464 43116 21731 23716 20243 ...
#>  $ timestamp           : int  1744095600 1744095660 1744095720 1744095780 1744095840 1744095900 1744095960 1744096020 1744096080 1744096140 ...
#>  $ date                : POSIXct, format: "2025-04-08 09:00:00" "2025-04-08 09:01:00" ...
#>  $ currency            : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol              : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname           : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ longname            : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ exchangename        : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone            : chr  "CEST" "CEST" "CEST" "CEST" ...
#>  $ gmtoffset           : int  7200 7200 7200 7200 7200 7200 7200 7200 7200 7200 ...
#>  $ regularmarketprice  : num  400 400 400 400 400 ...
#>  $ fiftytwoweeklow     : num  204 204 204 204 204 ...
#>  $ fiftytwoweekhigh    : num  420 420 420 420 420 420 420 420 420 420 ...
#>  $ regularmarketdaylow : num  382 382 382 382 382 ...
#>  $ regularmarketdayhigh: num  409 409 409 409 409 409 409 409 409 409 ...
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2025-04-08"
#>  - attr(*, "crypto")= logi FALSE
#>  - attr(*, "date.begin")= int 1744095600
#>  - attr(*, "date.end")= int 1744126140
#>  - attr(*, "date.dif")= num 30540
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
