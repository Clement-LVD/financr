# Example

This vignette show a workflow example, relying on the Yahoo Finance API.

**Search for ticker symbols, given keyword(s).** E.g., search symbols of
all index with ‘Dow jones’ or ‘Euronext’ (case insensitive).

``` r
library(financr)
indices <- search_assets(texts = c("Dow jones", "euronext"), type = "index" )
str(indices)
#> 'data.frame':    9 obs. of  10 variables:
#>  $ symbol        : chr  "^DJI" "^DWRTF" "^DWCPF" "^REIT" ...
#>  $ shortname     : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Select REIT Inde" "Dow Jones U.S. Completion Total" "Dow Jones Equity All REIT Total" ...
#>  $ longname      : chr  "Dow Jones Industrial Average" "Dow Jones U.S. Select REIT Inde" "Dow Jones U.S. Completion Total Stock Market Index" "Dow Jones Equity All REIT Total" ...
#>  $ exchange      : chr  "DJI" "DJI" "DJI" "DJI" ...
#>  $ exchdisp      : chr  "Dow Jones" "Dow Jones" "Dow Jones" "Dow Jones" ...
#>  $ quotetype     : chr  "INDEX" "INDEX" "INDEX" "INDEX" ...
#>  $ typedisp      : chr  "Index" "Index" "Index" "Index" ...
#>  $ score         : num  35415 20667 20294 20159 20005 ...
#>  $ isyahoofinance: logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#>  $ searched      : chr  "dow jones" "dow jones" "dow jones" "dow jones" ...
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
```

------------------------------------------------------------------------

**Search for symbols and latest prices on the exchange places, given
keyword(s).** E.g., search the symbols of ‘Volvo car’ and ‘Saab’ in the
Stockholm exchange place (case insensitive).

``` r
swedish <- search_assets(c("Volvo car", "Saab")
                         , exchange = "STO"
                         , get_values = T)
str(swedish)
#> 'data.frame':    2 obs. of  28 variables:
#>  $ symbol              : chr  "SAAB-B.ST" "VOLCAR-B.ST"
#>  $ shortname           : chr  "SAAB AB ser. B" "Volvo Car AB ser. B"
#>  $ longname            : chr  "Saab AB (publ)" "Volvo Car AB (publ.)"
#>  $ exchange            : chr  "STO" "STO"
#>  $ exchdisp            : chr  "Stockholm" "Stockholm"
#>  $ quotetype           : chr  "EQUITY" "EQUITY"
#>  $ typedisp            : chr  "Equity" "Equity"
#>  $ score               : num  20012 20014
#>  $ isyahoofinance      : logi  TRUE TRUE
#>  $ searched            : chr  "saab" "volvo car"
#>  $ currency            : chr  "SEK" "SEK"
#>  $ exchangename        : chr  "STO" "STO"
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm"
#>  $ instrumenttype      : chr  "EQUITY" "EQUITY"
#>  $ firsttradedate      : POSIXct, format: "2000-01-03 08:00:00" "2021-10-29 07:00:00"
#>  $ regularmarkettime   : POSIXct, format: "2026-01-13 16:29:46" "2026-01-13 16:29:31"
#>  $ hasprepostmarketdata: logi  FALSE FALSE
#>  $ gmtoffset           : int  3600 3600
#>  $ timezone            : chr  "CET" "CET"
#>  $ exchangetimezonename: chr  "Europe/Stockholm" "Europe/Stockholm"
#>  $ regularmarketprice  : num  704.1 32.2
#>  $ fiftytwoweekhigh    : num  709.8 36.5
#>  $ fiftytwoweeklow     : num  208 15.9
#>  $ regularmarketdayhigh: num  709.8 32.5
#>  $ regularmarketdaylow : num  679.8 31.6
#>  $ regularmarketvolume : int  3709372 3418611
#>  $ chartpreviousclose  : num  695.8 32.6
#>  $ previousclose       : num  695.8 32.6
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
#>  - attr(*, "date.begin")= POSIXct[1:1], format: "2026-01-13 16:29:31"
#>  - attr(*, "date.end")= POSIXct[1:1], format: "2026-01-13 16:29:46"
#>  - attr(*, "date.dif")= num 15
```

------------------------------------------------------------------------

**Get historical financial data, given symbols of assets.** Get
historical values, given ticker symbol(s), see below.

``` r
historic <- get_historic(symbols = swedish$symbol)

str(historic)
#> 'data.frame':    1020 obs. of  20 variables:
#>  $ open                : num  698 694 691 686 686 ...
#>  $ close               : num  694 691 686 686 685 ...
#>  $ low                 : num  693 688 686 684 680 ...
#>  $ high                : num  701 695 691 689 686 ...
#>  $ volume              : int  0 54694 44645 48274 68934 34643 25208 20831 28716 37439 ...
#>  $ timestamp           : int  1768291200 1768291260 1768291320 1768291380 1768291440 1768291500 1768291560 1768291620 1768291680 1768291740 ...
#>  $ date                : POSIXct, format: "2026-01-13 08:00:00" "2026-01-13 08:01:00" ...
#>  $ currency            : chr  "SEK" "SEK" "SEK" "SEK" ...
#>  $ symbol              : chr  "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" "SAAB-B.ST" ...
#>  $ shortname           : chr  "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" "SAAB AB ser. B" ...
#>  $ longname            : chr  "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" "Saab AB (publ)" ...
#>  $ exchangename        : chr  "STO" "STO" "STO" "STO" ...
#>  $ fullexchangename    : chr  "Stockholm" "Stockholm" "Stockholm" "Stockholm" ...
#>  $ timezone            : chr  "CET" "CET" "CET" "CET" ...
#>  $ gmtoffset           : int  3600 3600 3600 3600 3600 3600 3600 3600 3600 3600 ...
#>  $ regularmarketprice  : num  704 704 704 704 704 ...
#>  $ fiftytwoweeklow     : num  208 208 208 208 208 208 208 208 208 208 ...
#>  $ fiftytwoweekhigh    : num  710 710 710 710 710 ...
#>  $ regularmarketdaylow : num  680 680 680 680 680 ...
#>  $ regularmarketdayhigh: num  710 710 710 710 710 ...
#>  - attr(*, "n.currencies")= int 1
#>  - attr(*, "currencies")= chr "SEK"
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
#>  - attr(*, "date.begin")= int 1768291200
#>  - attr(*, "date.end")= int 1768321740
#>  - attr(*, "date.dif")= num 30540
```

Additional attributes indicates such as the symbols of currencies in the
`data.frame`, e.g., attributes of the `'historic'` `data.frame` from the
previous example indicates that prices are in the ‘SEK’ currency.

------------------------------------------------------------------------

**Get names of currencies.** And optionally add insights from
[`get_changes()`](https://clement-lvd.github.io/financr/reference/get_changes.md),
e.g., latest market prices of the currency (‘USD’).

``` r
unknown_currencies <- unique(historic$currency)

values_currencies <- last_currencies(keep = unknown_currencies, get_changes = T)

head(values_currencies)
#>   symbol shortname      longname locallongname currency exchangename
#> 1    SEK       SEK Swedish Krona Swedish Krona      USD          CCY
#>   instrumenttype      firsttradedate gmtoffset timezone exchangetimezonename
#> 1       CURRENCY 2001-07-15 23:00:00         0      GMT        Europe/London
#>   regularmarketprice regularmarketdayhigh regularmarketdaylow fiftytwoweekhigh
#> 1             0.1085               0.1085              0.1085           0.1113
#>   fiftytwoweeklow previousclose regular_timezone  to           timestamp
#> 1          0.0888        0.1092              GMT USD 2026-01-13 22:59:34
```
