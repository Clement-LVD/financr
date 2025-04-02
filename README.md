
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ‘`financr`’

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

[![CRAN
status](https://www.r-pkg.org/badges/version/financr)](https://CRAN.R-project.org/package=financr)
<!-- badges: end -->

<figure>
<img
src="https://img.shields.io/badge/Package-bold?style=flat&amp;logoColor=black&amp;logoSize=2&amp;label=R&amp;labelColor=black&amp;color=green"
alt=" " />
<figcaption aria-hidden="true"> </figcaption>
</figure>

`'financr'` retrieves financial data from Yahoo Finance.

- Get historical market data (e.g., market prices, currencies exchange
  rates) ;
- Get latest insights on companies, financial symbols, major indices,
  currencies and crypto-currencies exchanges rates ;
- Convert currencies and crypto-currencies with latest exchange rates.

See the [Vignette ‘Summary of financr
Functions’](https://clement-lvd.github.io/financr/articles/Functions_summary.html).

## Installation

You can install the development version of financr:

``` r
devtools::install_github("clement-LVD/financr")
```

## Examples

**Get ticker symbol and actual values.** Given keyword(s) such as
companies names, search latest stock values with
`financr::get_info_from_name()`.

``` r
library(financr)

swed_indices <- get_info_from_name(names = c("SAAB", "VOLVO"))

str(swed_indices) # Results of the day, over all marketplaces
#> 'data.frame':    41 obs. of  7 variables:
#>  $ symbol    : chr  "SAAB-B.ST" "SDV1.F" "SAABF" "SAABBS.XC" ...
#>  $ name      : chr  "SAAB AB ser. B" "Saab AB                       N" "Saab AB" "Saab AB" ...
#>  $ last price: chr  "387.20" "36.14" "40.31" "393.88" ...
#>  $ sector    : chr  "Industrials" "Industrials" "Industrials" "Industrials" ...
#>  $ type      : chr  "Stocks" "Stocks" "Stocks" "Stocks" ...
#>  $ exchange  : chr  "STO" "FRA" "PNK" "CXE" ...
#>  $ searched  : chr  "SAAB" "SAAB" "SAAB" "SAAB" ...
#>  - attr(*, "date")= Date[1:1], format: "2025-04-02"
#>  - attr(*, "crypto")= logi FALSE
```

If you don’t know the ticker symbol of a financial value, exploring the
results of `financr::get_info_from_name()` is a way to find it.

**Get historical financial data.** Given ticker symbol(s), get historic
of financial values with `financr::get_historic()` :

``` r

# Fetch historical values, given ticker symbol(s)
histo <- get_historic(symbols = c("SAAB-B.ST", "VOLV-B.ST"), .verbose = FALSE)

str(histo)
#> 'data.frame':    1020 obs. of  20 variables:
#>  $ open                : num  403 403 405 407 407 ...
#>  $ close               : num  403 405 407 407 409 ...
#>  $ low                 : num  402 403 405 406 407 ...
#>  $ high                : num  404 406 407 407 409 ...
#>  $ volume              : int  0 44058 30302 31561 27720 31097 23914 37929 11939 13352 ...
#>  $ timestamp           : int  1743577200 1743577260 1743577320 1743577380 1743577440 1743577500 1743577560 1743577620 1743577680 1743577740 ...
#>  $ date                : POSIXct, format: "2025-04-02 09:00:00" "2025-04-02 09:01:00" ...
#>  $ currency            : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol              : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname           : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ longname            : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ exchangename        : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone            : chr  "CEST" "CEST" "CEST" "CEST" ...
#>  $ gmtoffset           : int  7200 7200 7200 7200 7200 7200 7200 7200 7200 7200 ...
#>  $ regularmarketprice  : num  387 387 387 387 387 ...
#>  $ fiftytwoweeklow     : num  204 204 204 204 204 ...
#>  $ fiftytwoweekhigh    : num  417 417 417 417 417 ...
#>  $ regularmarketdaylow : num  383 383 383 383 383 ...
#>  $ regularmarketdayhigh: num  410 410 410 410 410 ...
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date")= Date[1:1], format: "2025-04-02"
#>  - attr(*, "crypto")= logi FALSE
```

Each lines of this `data.frame` are daily values.

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
