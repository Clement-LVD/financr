
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

`'financr'` retrieves financial data from Yahoo Finance.

- Get historical market data (e.g., market prices, currencies exchange
  rates)
- Get latest insights on financial assets such as companies, major
  indices, currencies and crypto-currencies exchanges rates
- And other helper functions, such as converting currencies and
  cryptocurrencies using the latest exchange rates.

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
`financr::search_from_text()`.

``` r
library(financr)

indices <- search_from_text(texts = c("Dow jones", "euronext"), type = "index" )

str(indices) # Ticker symbols of index (all exchange places)
#> 'data.frame':    9 obs. of  10 variables:
#>  $ symbol        : chr  "^DJI" "^DWRTF" "^DWCPF" "^N100" ...
#>  $ shortname     : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Select REIT Inde" "Dow Jones U.S. Completion Total" "Euronext 100 Index" ...
#>  $ longname      : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Select REIT Inde" "Dow Jones U.S. Completion Total" "Euronext 100 Index" ...
#>  $ exchange      : chr  "DJI" "DJI" "DJI" "PAR" ...
#>  $ exchdisp      : chr  "Dow Jones" "Dow Jones" "Dow Jones" "Paris" ...
#>  $ quotetype     : chr  "INDEX" "INDEX" "INDEX" "INDEX" ...
#>  $ typedisp      : chr  "Index" "Index" "Index" "Index" ...
#>  $ score         : num  52196 20477 20444 20011 20005 ...
#>  $ isyahoofinance: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#>  $ searched      : chr  "dow jones" "dow jones" "dow jones" "euronext" ...
#>  - attr(*, "date")= Date[1:1], format: "2025-04-03"
#>  - attr(*, "crypto")= logi FALSE
```

Or retrieve the symbols and latest values on the stocks exchange places
with `financr::get_info_from_name()`.

``` r
swed_indices <- get_info_from_name(names = c("SAAB", "VOLVO"), exchange = "STO")

str(swed_indices) # More or less similar than the previous example + latest values of the day
#> 'data.frame':    4 obs. of  7 variables:
#>  $ symbol    : chr  "SAAB-B.ST" "VOLCAR-B.ST" "VOLV-B.ST" "VOLV-A.ST"
#>  $ name      : chr  "SAAB AB ser. B" "Volvo Car AB ser. B" "Volvo, AB ser. B" "Volvo, AB ser. A"
#>  $ last price: chr  "411.65" "17.81" "255.80" "255.80"
#>  $ sector    : chr  "Industrials" "Consumer Cyclical" "Industrials" "Industrials"
#>  $ type      : chr  "Stocks" "Stocks" "Stocks" "Stocks"
#>  $ exchange  : chr  "STO" "STO" "STO" "STO"
#>  $ searched  : chr  "SAAB" "VOLVO" "VOLVO" "VOLVO"
#>  - attr(*, "date")= Date[1:1], format: "2025-04-03"
#>  - attr(*, "crypto")= logi FALSE
```

If you don’t know the ticker symbol of an asset, exploring the results
of `financr::get_info_from_name()` or `search_from_text()` is a way to
find it.

**Get historical financial data.** Given ticker symbol(s), get historic
of financial values with `financr::get_historic()` :

``` r

# Fetch historical values, given ticker symbol(s)
histo <- get_historic(symbols = c("SAAB-B.ST", "VOLV-B.ST"), .verbose = FALSE)
# Default interval is daily values.

str(histo)
#> 'data.frame':    1018 obs. of  20 variables:
#>  $ open                : num  382 378 384 388 392 ...
#>  $ close               : num  378 384 388 392 393 ...
#>  $ low                 : num  377 378 384 387 392 ...
#>  $ high                : num  383 384 388 392 395 ...
#>  $ volume              : int  0 70004 110268 46645 49735 43420 36154 22047 28342 24174 ...
#>  $ timestamp           : int  1743663600 1743663660 1743663720 1743663780 1743663840 1743663900 1743663960 1743664020 1743664080 1743664140 ...
#>  $ date                : POSIXct, format: "2025-04-03 09:00:00" "2025-04-03 09:01:00" ...
#>  $ currency            : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol              : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname           : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ longname            : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ exchangename        : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone            : chr  "CEST" "CEST" "CEST" "CEST" ...
#>  $ gmtoffset           : int  7200 7200 7200 7200 7200 7200 7200 7200 7200 7200 ...
#>  $ regularmarketprice  : num  412 412 412 412 412 ...
#>  $ fiftytwoweeklow     : num  204 204 204 204 204 ...
#>  $ fiftytwoweekhigh    : num  417 417 417 417 417 ...
#>  $ regularmarketdaylow : num  377 377 377 377 377 ...
#>  $ regularmarketdayhigh: num  412 412 412 412 412 ...
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date")= Date[1:1], format: "2025-04-03"
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

See the vignette on [`get_info_from_names()` and
`get_historic()`](https://clement-lvd.github.io/financr/articles/get_info_and_historic.html).

## Licence

This package retrieves data from Yahoo Finance, a property of Yahoo
Inc. Users must comply with [Yahoo Finance’s API
terms](https://legal.yahoo.com/us/en/yahoo/terms/product-atos/apiforydn/index.html).
See more informations on the [legal
Vignette](https://clement-lvd.github.io/financr/articles/About_the_Yahoo_Finance_License.html).
