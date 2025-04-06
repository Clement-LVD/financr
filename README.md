
<!-- README.md is generated from README.Rmd. Please edit that file -->

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

`'financr'` retrieves financial data from Yahoo Finance :

- historical market data, e.g., market prices, currency exchange rates.
- latest insights on financial assets such as companies, major indices,
  currencies and cryptocurrency exchange rates.
- Other insights, e.g., validity of financial symbol(s) and other assets
  associated with.

See the [Vignette ‘Summary of financr
Functions’](https://clement-lvd.github.io/financr/articles/Functions_summary.html).

## Installation

You can install the development version of financr:

``` r
devtools::install_github("clement-LVD/financr")
```

## Examples

**Get ticker symbol from free-texts.** Given keyword(s) such as
companies names, search financial ticker symbols with
`financr::search_assets()`.

``` r
library(financr)

indices <- search_assets(c("Dow jones", "euronext"), type = "index" )

str(indices)
#> 'data.frame':    9 obs. of  10 variables:
#>  $ symbol        : chr  "^DJI" "^DWCPF" "^DWRTF" "ESG1N.AS" ...
#>  $ shortname     : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Completion Total" "Dow Jones U.S. Select REIT Inde" "Euronext Eurozone 100 ESG NR" ...
#>  $ longname      : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Completion Total" "Dow Jones U.S. Select REIT Inde" "Euronext Eurozone 100 ESG NR" ...
#>  $ exchange      : chr  "DJI" "DJI" "DJI" "AMS" ...
#>  $ exchdisp      : chr  "Dow Jones" "Dow Jones" "Dow Jones" "Amsterdam" ...
#>  $ quotetype     : chr  "INDEX" "INDEX" "INDEX" "INDEX" ...
#>  $ typedisp      : chr  "Index" "Index" "Index" "Index" ...
#>  $ score         : num  51005 20280 20174 20005 20005 ...
#>  $ isyahoofinance: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#>  $ searched      : chr  "dow jones" "dow jones" "dow jones" "euronext" ...
#>  - attr(*, "date")= Date[1:1], format: "2025-04-06"
#>  - attr(*, "crypto")= logi FALSE
```

Or retrieve the symbols and latest values on the stocks exchange places
with `financr::search_summary()`.

``` r
swed_indices <- search_summary( c("SAAB", "VOLVO"), exchange = "STO")

str(swed_indices) # More or less similar than the previous example + latest values of the day
#> 'data.frame':    4 obs. of  7 variables:
#>  $ symbol    : chr  "SAAB-B.ST" "VOLCAR-B.ST" "VOLV-B.ST" "VOLV-A.ST"
#>  $ name      : chr  "SAAB AB ser. B" "Volvo Car AB ser. B" "Volvo, AB ser. B" "Volvo, AB ser. A"
#>  $ last_price: chr  "379.40" "17.72" "245.10" "244.80"
#>  $ sector    : chr  "Industrials" "Consumer Cyclical" "Industrials" "Industrials"
#>  $ type      : chr  "Stocks" "Stocks" "Stocks" "Stocks"
#>  $ exchange  : chr  "STO" "STO" "STO" "STO"
#>  $ searched  : chr  "SAAB" "VOLVO" "VOLVO" "VOLVO"
#>  - attr(*, "date")= Date[1:1], format: "2025-04-06"
#>  - attr(*, "crypto")= logi FALSE
```

If you don’t know the ticker symbol of an asset, exploring the results
of `financr::search_summary()` or `search_from_text()` is a way to find
it.

**Get historical financial data.** Given ticker symbol(s), get historic
of financial values with `financr::get_historic()` :

``` r

# Fetch historical values, given ticker symbol(s)
histo <- get_historic(c("SAAB-B.ST", "VOLV-B.ST"), .verbose = FALSE)
# Default interval is daily values.

str(histo)
#> 'data.frame':    1020 obs. of  20 variables:
#>  $ open                : num  411 410 414 416 418 ...
#>  $ close               : num  410 414 416 418 419 ...
#>  $ low                 : num  409 409 413 416 417 ...
#>  $ high                : num  412 415 418 418 419 ...
#>  $ volume              : int  0 36745 56432 18363 43626 34211 51050 34181 45256 36016 ...
#>  $ timestamp           : int  1743750000 1743750060 1743750120 1743750180 1743750240 1743750300 1743750360 1743750420 1743750480 1743750540 ...
#>  $ date                : POSIXct, format: "2025-04-04 09:00:00" "2025-04-04 09:01:00" ...
#>  $ currency            : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol              : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname           : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ longname            : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ exchangename        : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone            : chr  "CEST" "CEST" "CEST" "CEST" ...
#>  $ gmtoffset           : int  7200 7200 7200 7200 7200 7200 7200 7200 7200 7200 ...
#>  $ regularmarketprice  : num  379 379 379 379 379 ...
#>  $ fiftytwoweeklow     : num  204 204 204 204 204 ...
#>  $ fiftytwoweekhigh    : num  420 420 420 420 420 420 420 420 420 420 ...
#>  $ regularmarketdaylow : num  365 365 365 365 365 365 365 365 365 365 ...
#>  $ regularmarketdayhigh: num  420 420 420 420 420 420 420 420 420 420 ...
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date")= Date[1:1], format: "2025-04-06"
#>  - attr(*, "crypto")= logi FALSE
```

## Vignettes

**Change currencies at current exchange rates and get historic of
exchange rates.** See the Vignette of [`get_changes()` and
`get_currencies()`](https://clement-lvd.github.io/financr/articles/Get_changes.html).

**Get latest financial values and insights on major world-indices and
crypto-currencies.** See the [vignette of `get_indices()` and
`get_crypto()`](https://clement-lvd.github.io/financr/articles/get_indices_and_get_crypto.html).

**Cascading functionnality.** `'financr'` offer the possibility to chain
these process, e.g.,

1.  get ticker symbol and latest insights from keyword(s) such as
    company names,
2.  then get the financial historic associated with these ticker symbol,
3.  and finally convert their values in a given standardized currency,
    e.g., ‘USD’.

See the vignette on [`search_summarys()` and
`get_historic()`](https://clement-lvd.github.io/financr/articles/get_info_and_historic.html).

## Licence

This package retrieves data from Yahoo Finance, a property of Yahoo
Inc. Users must comply with [Yahoo Finance’s API
terms](https://legal.yahoo.com/us/en/yahoo/terms/product-atos/apiforydn/index.html).
See more informations on the [legal
Vignette](https://clement-lvd.github.io/financr/articles/About_the_Yahoo_Finance_License.html).
