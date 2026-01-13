# Summary of Functions

This vignette explains the functions offered by `'financr'`.

## Overview

**Source.** Yahoo Finance is used consistently as a data source across
the package.

**Inputs.** Each function expects a specific type of input, based on its
prefix.

| Prefix   | Example                                                                             | Expected_input                                                                                                           |
|:---------|:------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| search\_ | `search_assets('Saab')`                                                             | Free-text(s)                                                                                                             |
| get\_    | `get_historic('^DJI')`                                                              | Financial symbol(s) such as a ticker symbol[¹](#fn1) (e.g., ‘AAPL’) or ISO 3-letter currency code[²](#fn2) (e.g., ‘USD’) |
| last\_   | [`last_indices()`](https://clement-lvd.github.io/financr/reference/last_indices.md) | Do not require any input. All arguments are optional                                                                     |

------------------------------------------------------------------------

**Outputs.** All the `'financr'` functions return a standardized
`data.frame`, see the last section [‘Return
Conventions’](#return-conventions).

Functions with the `'_historic'` suffix return an historic of financial
data, while the others retrieve latest financial data.

------------------------------------------------------------------------

## Details

**search\_ family.**

| Example                                 | Returned `data.frame`                                              |
|:----------------------------------------|:-------------------------------------------------------------------|
| `search_assets('Saab', get_values = T)` | Assets names, ticker symbols, latest insights and financial values |
| `search_assets('Saab')`                 | Assets names and symbol(s) associated with the texts searched      |
| `search_assets_quick('Saab')`           | Assets names and symbol(s) associated with the text searched       |

Functions with the prefix `'search_'` retrieve latest data and expect
free-text input(s).

- Source : Yahoo Finance API (<https://query2.finance.yahoo.com>)

------------------------------------------------------------------------

**get\_ family.**

[TABLE]

Functions with the prefix `'get_'` retrieve the historical or latest
financial values, given financial symbol(s)

- Source : Yahoo Finance API (<https://query2.finance.yahoo.com>)

------------------------------------------------------------------------

**last\_ family.**

| Example                                                                                           | data.frame_returned                                                             |
|:--------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------|
| [`last_market_summary()`](https://clement-lvd.github.io/financr/reference/last_market_summary.md) | Latest summary information for a set of major financial market indices\*        |
| [`last_indices()`](https://clement-lvd.github.io/financr/reference/last_indices.md)               | World indices latest insights and values (USD)^(‡)                              |
| [`last_currencies()`](https://clement-lvd.github.io/financr/reference/last_currencies.md)         | ISO currency codes for currencies, names and (optionally) latest values\* (USD) |
| [`last_crypto()`](https://clement-lvd.github.io/financr/reference/last_crypto.md)                 | 100 major crypto-currencies latest insights and values (USD)^(‡)                |

Functions with the prefix `'last_'` retrieve latest data and do not
require any input (all arguments are optional).

- \* : Retrieve latest data from Yahoo Finance API
  (<https://query2.finance.yahoo.com>)

- ‡ : Scraping latest data from Yahoo Finance pages,
  i.e. <https://finance.yahoo.com/markets/world-indices/> or
  \[…\]/markets/crypto

See the vignette of the ‘last\_’ functions.

[`vignette("last_family", package = "financr")`](https://clement-lvd.github.io/financr/articles/last_family.md)

------------------------------------------------------------------------

**Other function.**

| Example                 | Input             | Data.frame_returned                              |
|:------------------------|:------------------|:-------------------------------------------------|
| `valid_symbol("SAABF")` | Text(s) to verify | (logical values) Validity of financial symbol(s) |

Other helper functions

- Source : Yahoo Finance API (<https://query2.finance.yahoo.com>)

------------------------------------------------------------------------

## Return Conventions

Regarding a `data.frame` returned by `'financr'` functions, the column
names are:

- following the ‘snake_case’ conventions[³](#fn3), e.g., in lowercase
  and without spaces;
- and symbols are replaced (e.g., “%’ is replaced by ‘percent’).

------------------------------------------------------------------------

1.  <https://en.wikipedia.org/wiki/Ticker_symbol>

2.  <https://en.wikipedia.org/wiki/ISO_4217>

3.  <https://wikipedia.org/wiki/Snake_case>
