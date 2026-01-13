# Search Financial Asset From Keywords (Multiple Texts)

Get symbols associated with free texts such as companies names or
world-indices. Several ticker symbols associated with various exchanges
places could be returned, with companies names, sector/category (if
available), etc.

## Usage

``` r
search_assets(
  texts,
  exchange = NULL,
  type = NULL,
  get_values = F,
  .verbose = F
)
```

## Arguments

- texts:

  `character` A character string or a list of character representing the
  text(s) to search for, e.g., company names.

- exchange:

  `character` (optionnal) - A character string representing the exchange
  place(s) to consider - exact match, e.g., 'STO' (Stockholm stock
  exchange). Default keep all results.

- type:

  (optionnal) A character string representing a type of asset to search
  for ('quotetype' column value is used to filter out results). Case
  insensitive.

  |            |                                                                         |
  |------------|-------------------------------------------------------------------------|
  | Type       | Description                                                             |
  | ETF        | Exchange-Traded Fund - A basket of stocks or bonds traded like a stock. |
  | EQUITY     | Equity - A stock representing ownership in a company.                   |
  | MUTUALFUND | Mutual Fund - A pooled investment fund.                                 |
  | INDEX      | Index - A benchmark representing a group of stocks (e.g., S&P 500).     |
  | FUTURE     | Future - A contract to buy/sell an asset at a future date and price.    |

- get_values:

  `logical`, default = `FALSE` - If `TRUE`, search for the values of the
  symbols and add columns from
  [`get_values()`](https://clement-lvd.github.io/financr/reference/get_values.md)

- .verbose:

  `logical`, default = `FALSE` If TRUE, messages are displayed, e.g.,
  when invalid symbols are detected.

## Value

Return a `data.frame` with the following columns:

- symbol:

  `character` - The ticker symbol associated with an asset, e.g., "VTI",
  "^DWCPF".

- shortname:

  `character` - A short name for the asset, e.g., ETF or index name.

- longname:

  `character` - The full name of the asset, such as the full ETF or
  index name - sometimes not returned by Yahoo.

- exchange:

  `character` - The exchange where the asset is listed, e.g., "PCX",
  "DJI", "NGM".

- exchdisp:

  `character` - The full name of the exchange place where the asset is
  traded, e.g., "NYSEArca", "Dow Jones".

- quoteType:

  `character` - The type of asset, e.g., "FUTURES", "INDEX".

- typeDisp:

  `character` - The type of asset, formatted for display, e.g.,
  "Futures", "Index").

- score:

  `numeric` - A numerical score assigned by Yahoo in order to indicate
  the relevance of the matched result, i.e. similarity with the text.

- isYahooFinance:

  `logical` - Indicates whether the symbol is recognized by Yahoo
  Finance - should always be `TRUE` in this context.

- searched:

  `character` - The text searched on the Yahoo API, e.g., "Dow Jones".

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

Source : https://query2.finance.yahoo.com/v1/

## See also

For more details see the help vignette:
`vignette("get_info_and_historic", package = "financr"))`

`get_values` `search_assets_quick`

## Examples

``` r
indices <- search_assets(texts = c("Dow jones", "euronext"), type = "index" )

swed <- search_assets(c("VOLVO car", "RENAULT"),  exchange = c("STO", "PAR"))
head(swed)
#>         symbol           shortname             longname exchange  exchdisp
#> 1  VOLCAR-B.ST Volvo Car AB ser. B Volvo Car AB (publ.)      STO Stockholm
#> 8       RNO.PA             RENAULT           Renault SA      PAR     Paris
#> 13      RNL.PA  RENAULTPFRN24OCT49           Renault SA      PAR     Paris
#>    quotetype typedisp score isyahoofinance  searched
#> 1     EQUITY   Equity 20014           TRUE volvo car
#> 8     EQUITY   Equity 20039           TRUE   renault
#> 13    EQUITY   Equity 20001           TRUE   renault

swed_last_values <- search_assets(c("VOLVO car", "SAAB")
,  exchange = "STO", get_values = TRUE )

str(swed_last_values)
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
