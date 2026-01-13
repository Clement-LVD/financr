# Get Historical Financial Data For a Given Symbol

Get historical financial values associated with a ticker symbol. The
data includes open stock price, high, low, close, volume, along with
timestamps.

## Usage

``` r
get_yahoo_data(
  symbol = "AAPL",
  start_date = NULL,
  end_date = NULL,
  range = "1d",
  .verbose = T
)
```

## Arguments

- symbol:

  `character` - A character string representing the symbol for the
  financial instrument (e.g., "AAPL" for Apple).

- start_date:

  `character` - A character string representing the start date in R
  `date` format (UTC time). If `NULL`, data starts from 1970-01-01.

- end_date:

  `character` - A character string representing the end date in a valid
  R `date` format (UTC time). If `NULL`, data is retrieved up to the
  current date.

- range:

  `character` - A character string representing the range for the
  returned datas : default will return daily values.

  |                                                                                                 |
  |-------------------------------------------------------------------------------------------------|
  | **Valid `range` values**                                                                        |
  | `"1d"`, `"5d"`, `"1mo"`, `"3mo"`, `"6mo"`, `"1y"`, `"2y"`, `"5y"`, `"10y"`, `"ytd"` and `"max"` |
  |                                                                                                 |

- .verbose:

  `logical` If TRUE, messages are displayed, e.g., when invalid symbols
  are detected.

## Value

A `data.frame` containing the historical financial data with the
following columns:

- open:

  `numeric` The opening price for the period (default is each day).

- close:

  `numeric` The closing price for the period (default is each day).

- low:

  `numeric` The lowest price for the period (default is each day).

- high:

  `numeric` The highest price for the period (default is each day).

- volume:

  `integer` The traded volume.

- timestamp:

  `integer` Unix timestamps corresponding to each data point.

- date:

  `POSIXct` The day of the financial data point.

- currency:

  `character` The currency in which the data is reported, depending on
  the marketplace.

- symbol:

  `character` The stock or financial instrument symbol (e.g., "AAPL").

- shortname:

  `character` The abbreviated name of the company or financial
  instrument.

- longname:

  `character` The full name of the company or financial instrument.

- exchangename:

  `character` The name of the exchange marketplace where the financial
  instrument is listed.

- fullexchangename:

  `character` The full name of the exchange marketplace.

- timezone:

  `character` The timezone in which the data is reported.

- gmtoffset:

  `integer` The UNIX timestamp of difference between the market local
  time and the GMT time.

- regularMarketPrice:

  `numeric` The actual price if market is open, or last closing price if
  not.

- fiftyTwoWeekLow:

  `numeric` Lowest price for the last 52 weeks.

- fiftyTwoWeekHigh:

  `numeric` Highest price for the last 52 weeks.

- regularMarketDayHigh:

  `numeric` The highest price of the day (local exchange place day).

- regularMarketDayLow:

  `numeric` The lowest price of the day (local exchange place day).

## Details

The default `data.frame` have a line for each day. If the user provide
another range than '1d' (one day), lines will be filtered out, in order
to match the desired range. Valid ranges are: "1d", "5d", "1mo", "3mo",
"6mo", "1y", "2y", "5y", "10y", "ytd", and "max".

The function allows the user to specify a date range using start and end
dates. If no date range is specified, it retrieves all available data
from the beginning of time (default for start) to the current date
(default for end).

## References

Source : https://query1.finance.yahoo.com/v8/finance/chart/

## Examples

``` r
if (FALSE) { # \dontrun{
data <- get_yahoo_data(symbol = "SAAB-B.ST", start_date = "2020-01-01", range = "1d")
} # }
```
