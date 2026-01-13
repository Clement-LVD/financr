# Search Financial Assets From Keyword(s)

Search for financial data based on texts and retrieve asset symbol(s),
name(s), exchanges place(s), and asset type(s). It's a variant of
[`search_assets()`](https://clement-lvd.github.io/financr/reference/search_assets.md).

## Usage

``` r
search_assets_quick(
  texts = "Dow Jones",
  .verbose = TRUE,
  region = NULL,
  lang = "en"
)
```

## Arguments

- texts:

  `character` string representing the texts to search. This can be a
  company name, index, or financial term.

- .verbose:

  `logical` If `TRUE`, print additional details about the search
  process. Default is `TRUE`.

- region:

  A character string specifying the region for the search (e.g., "US",
  "EU"). Default is `NULL`, meaning no region filter is applied.

- lang:

  A character string specifying the language of the data returned.
  Default is "en" for English.

## Value

A `data.frame` with assets symbols and names.

- `symbol` - The financial symbol (e.g., stock ticker or index).

- `name` - The full name of the financial entity (e.g., 'Dow Jones
  Industrial Average').

- `exch` - The exchange on which the symbol is listed (e.g., 'DJI',
  'CBT').

- `type` - The type of financial instrument (e.g., I for Index, F for
  Futures, E for Exchange Traded Fund).

- `exchdisp` - The exchange name displayed (e.g., 'Dow Jones').

- `typedisp` - A long name for the type of financial instrument (e.g.,
  'Index', 'Futures' or 'ETF' for 'Exchange Traded Fund').

## Examples

``` r
# Example of searching for financial data related to "Dow Jones"
results <- search_assets_quick(texts = "Dow Jones")
str(results)
#> 'data.frame':    10 obs. of  7 variables:
#>  $ symbol  : chr  "^DJI" "YM=F" "RX=F" "MYM=F" ...
#>  $ name    : chr  "Dow Jones Industrial Average" "Mini Dow Jones Indus.-$5 Mar 26" "Dow Jones US Real Estate Index" "Micro E-mini Dow Jones Industri" ...
#>  $ exch    : chr  "DJI" "CBT" "CBT" "CBT" ...
#>  $ type    : chr  "I" "F" "F" "F" ...
#>  $ exchdisp: chr  "Dow Jones" "Chicago Board of Trade" "Chicago Board of Trade" "Chicago Board of Trade" ...
#>  $ typedisp: chr  "Index" "Futures" "Futures" "Futures" ...
#>  $ searched: chr  "Dow Jones" "Dow Jones" "Dow Jones" "Dow Jones" ...
#>  - attr(*, "date.fetch")= Date[1:1], format: "2026-01-13"
```
