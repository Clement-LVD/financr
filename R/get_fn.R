# A 'get_' prefix mean that the expected inputs are symbol(s)
# some of these functions have their own files, e.g., get_changes and get_yahoo_data

# function for standardizing symbols
standardize_symbols <- function(symbols){
  symbols <- symbols[!is.na(symbols)] # deal with na values
  symbols <- toupper(gsub(" *", "", symbols, perl = T )) # suppress spaces and uppercase
  return(unique(symbols))
}

#' Retrieve latest financial data
#'
#' Get latest insights, given financial symbols. Data such as latest prices and trading context are returned.
#'
#' @param symbols Character vector. One or more asset symbols (e.g., \code{c("AAPL", "GOOGL")}).
#' @param .verbose Logical. If TRUE, displays verbose output during the fetching process. Default is FALSE.
#' @return A data.frame with 1 row per valid financial symbol and 21 columns, including:
#' \describe{
#'   \item{currency}{`character` - Trading currency of the asset (e.g., "USD").}
#'   \item{symbol}{ `character` - Symbol of the asset, e.g., ticker symbol.}
#'   \item{exchangename}{ `character` - Abbreviated exchange place or financial instrument name.}
#'   \item{fullexchangename}{ `character` - Full name of the exchange place or financial instrument.}
#'   \item{instrumenttype}{ `character` - Type of financial instrument (e.g., "EQUITY").}
#'   \item{firsttradedate}{ `POSIXct` - Datetime when the asset was first traded.}
#'   \item{regularmarkettime}{ `POSIXct` - Timestamp of the latest regular market quote.}
#'   \item{hasprepostmarketdata}{ `logical` - Indicates if pre/post-market data is available.}
#'   \item{gmtoffset}{ `integer` - Offset from GMT in seconds.}
#'   \item{timezone}{ `character` - Abbreviated timezone name of the market.}
#'   \item{exchangetimezonename}{ `character` - Timezone name of the exchange location.}
#'   \item{regularmarketprice}{ `numeric`   - Latest regular market trading price.}
#'   \item{fiftytwoweekhigh}{ `numeric`   - highest price over a 52-weeks period.}
#'   \item{fiftytwoweeklow}{ `numeric`   - lowest price over a  52-weeks period.}
#'   \item{regularmarketdayhigh}{ `numeric`   - Highest price during the current market day.}
#'   \item{regularmarketdaylow}{ `numeric`   - Lowest price during the current market day.}
#'   \item{regularmarketvolume}{ `integer`   - Volume traded during the current market day.}
#'   \item{shortname}{ `character` - Shortened or common name of the asset.}
#'   \item{chartpreviousclose}{ `numeric`   - Closing price shown in charts.}
#'   \item{previousclose}{`numeric`   - Previous official market close price.}
#' }
#' @inherit construct_financial_df details
#' @examples
#' get_values(c("AAPL", "GOOGL","SAAB-B.ST"))
#' @references Source : https://query2.finance.yahoo.com/v8/finance/chart/
#' @export
get_values <- function(symbols = c("AAPL", "GOOGL"), .verbose = F){
if(length(symbols) == 0 ) return(NULL)
if(!is.character(symbols)) return(NA)
if(!internet_or_not(.verbose = .verbose)) return(NA)

symbols <- standardize_symbols(symbols)

results <- lapply(symbols, get_asset_value, .verbose = .verbose )

complete_results <- do.call(rbind, results)

if(length(complete_results) == 0) return(NA)

return( construct_financial_df(complete_results) )
}


# utility func' for hereafter : keep 'normal' column and drop stranges list values
keep_flat_columns <- function(df) {
is_flat <- sapply(df, function(col) {is.atomic(col) && !is.list(col)})
df <- df[ , is_flat, drop = FALSE]
return(df)
}

# internal function to take an asset value (like historic but just flat meta data are returned)

#' Retrieve flat meta data for a financial asset
#'
#' Internal function to fetch flat (non-nested) meta data for a given asset symbol, such as a stock.
#' Returns a one-row data frame with high-level market and asset information (e.g., prices, volumes, timezones).
#'
#' @param symbol Character. Asset symbol to query (e.g., "AAPL").
#' @param .verbose Logical. If TRUE, enables verbose output for debugging purposes. Default is FALSE.
#' @return A data.frame with 1 row per symbol provided and 21 columns see `get_values()`
#' @seealso \code{get_values}
#' @keywords internal
#' @examples
#' \dontrun{
#' last_prices <- get_asset_value("SAAB-B.ST")
#' str(last_prices)
#' }
get_asset_value <- function(symbol = "SAAB-B.ST", .verbose = F){
  if(length(symbol) == 0) return(NULL)
  if(length(symbol) > 1) return(NULL)
  if(all(is.na(symbol))) return(NULL)

  if(!internet_or_not(.verbose = .verbose)) return(NULL)

  url <- retrieve_yahoo_api_chart_url(suffix = paste0("v8/finance/chart/", symbol) )

  raws <- fetch_yahoo(url, .verbose = .verbose)

  if(length(raws) == 0) return(NULL)
  if(length(raws) == 1) if(is.na(raws)) return(NULL)

  results <- raws[[1]][[1]][[1]]

  last_results <- keep_flat_columns(results)

  last_results <- standardize_df_cols(last_results)

  col_2_return <- c('currency', 'symbol', 'exchangename', 'fullexchangename', 'instrumenttype', 'firsttradedate', 'regularmarkettime', 'hasprepostmarketdata', 'gmtoffset', 'timezone', 'exchangetimezonename', 'regularmarketprice', 'fiftytwoweekhigh', 'fiftytwoweeklow', 'regularmarketdayhigh', 'regularmarketdaylow', 'regularmarketvolume'
                    # , 'longname'
                    , 'shortname'
                    , 'chartpreviousclose', 'previousclose')

last_results <- add_missing_var_to_df(last_results, col_2_return)

last_results <- last_results[, col_2_return]


  return(last_results)
}

#' Find Similar Financial Symbols
#'
#' Given symbol(s), retrieve identical symbols (according to Yahoo Finance) and a score of similarity.
#'
#' @param symbols `character` A character string representing a financial symbol to search.
#' @param .verbose `logical` If TRUE, messages are displayed when invalid symbols are detected. Default is TRUE.
#' @param ... Other symbols (char. or list of char.)
#' @return A `data.frame` with the symbols associated with those provided by the user and similarity scores, according to Yahoo Finance.
#' \describe{
#'   \item{from}{`character` - Financial symbol provided by the user.}
#'   \item{symbol}{`character` - Symbol associated with the other 'from' symbol.}
#'   \item{score}{`numeric` - Similarity score, according to Yahoo Finance.}
#'   }
#' @examples
#' get_similar(symbols =   "AAPL,GOOGL")
#' get_similar(symbols =   c("AAPL", "GOOGL"))
#' @references Source : https://query2.finance.yahoo.com/v6/finance/quote/validate
#' @export
get_similar <- function(symbols = "SAAB-B.ST", .verbose = F, ...){

  symbols <- c(symbols, ...)

  if(length(symbols) == 0) return(NULL)
  if(all(is.na(symbols))) return(NA)

  if(!internet_or_not(.verbose = .verbose)) return(NA)

  initial_symbols <- standardize_symbols(symbols)

  symbols <- paste0(initial_symbols, collapse = ",")


  url <- retrieve_yahoo_api_chart_url(suffix = paste0("/v6/finance/recommendationsbysymbol/", symbols) )

  raws <- fetch_yahoo(url, .verbose = .verbose)

  results <- raws[[1]][[1]]

  if(length(results) == 0) return(NA)

  edgelist <- results[[2]]

  names(edgelist) <- results[[1]]

  edgelist <-  Map(function(df, name) { df$from <- name ; return(df) }, edgelist, names(edgelist))

  edgelist <- do.call(rbind, edgelist)

  edgelist <- edgelist[ , c("from", "symbol", "score")]

  return(construct_financial_df(edgelist))
}


#' Get Historical Financial Data For Ticker Symbols
#'
#' Get the historic of stock market data for financial ticker symbols, e.g., values at each closing day.
#' @param symbols `character` A character string representing the financial indices to search for, e.g., ticker symbol(s).
#' @param wait.time `double`, default = `0` A character string representing an additional waiting time between 2 calls to the Yahoo API.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console.
#' @param ... Parameters passed to `get_yahoo_data`
#' @inheritDotParams get_yahoo_data
#' @inherit get_yahoo_data return references
#' @inherit construct_financial_df details
#' @examples
#' datas <- get_historic(symbols = c("VOLCAR-B.ST", "SAAB-B.ST") )
#' str(datas)
#' @seealso \code{\link{get_yahoo_data}}
#' @seealso For more details see the help vignette:
#' \code{vignette("get_info_and_historic", package = "financr")}
#' @export
get_historic <- function(symbols = c("SAAB-B.ST"), wait.time = 0, .verbose = T, ...){
  if(length(symbols) == 0) return(NULL)
  if(all(is.na(symbols))) return(NA)
  if(!is.character(symbols)) return(NA)
  if(!internet_or_not(.verbose = .verbose)) return(NA)

  result_actions = list()

  stocks <- lapply(symbols, FUN = function(symbol) {

    results <- get_yahoo_data(symbol, .verbose = .verbose, ...)

    if(length(results) == 1){ if(is.na(results)) return(NA) }

    results <- as.data.frame(results)

    Sys.sleep(wait.time)

    return(results)

  })

  returned_results <- do.call(rbind, stocks)

  if(is.null(returned_results)) return(NULL) #other problem such as no symbol at all
  if( all(is.na(returned_results))) return(NA)

  returned_results <- construct_financial_df(returned_results  )
  return(returned_results)
}

# Other API source

#' Get Historical Financial Data For Ticker Symbols
#'
#' Get an historic of stock market data for financial ticker symbols, e.g., values at each closing day.
#' @param symbols `character` A character string representing the financial indices to search for, e.g., ticker symbol(s).
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console.
#' @param interval `character`, default = `"1d"`. The interval between 2 rows of the time.series answered
#' | **Valid `interval` values**                                       |
#' |-------------------------------------------------------------------|
#' |  `"1m"`,  `"5m"`, `"15m"`, `"1d"`,  `"1wk"`, `"1mo"` |
#'
#' @param range `character`, default = `"1y"`. The period covered by the time series.
#' | **Valid `range` values**                                                    |
#' |-------------------------------------------------------------------------------|
#' |  `"1d"`, `"5d"`, `"1mo"`, `"3mo"`, `"6mo"`, `"1y"`, `"5y"`, `"max"` |
#'
#' @return A `data.frame` with a historical values :
#' \describe{
#'   \item{symbol}{`character` - Financial ticker symbol.}
#'   \item{timestamp}{`POSIXct` - Date of the observation (closing price).}
#'   \item{close}{`numeric` - Closing price of the asset.}
#'   }
#'
#' @inherit construct_financial_df details
#' @examples
#' histo_light <- get_historic_light(c("SAAB-B.ST", "AAPL"))
#' @export
get_historic_light <- function(symbols = "SAAB-B.ST", interval = '1d', range = '1mo' , .verbose = F){
  if(length(symbols) == 0) return(NULL)
  if(all(is.na(symbols))) return(NA)
  if(!is.character(symbols)) return(NA)
  if(!internet_or_not(.verbose = .verbose)) return(NA)

  histo_light_results <- lapply(symbols, FUN = function(symbol) {

    url <- retrieve_yahoo_api_chart_url(suffix = paste0("v8/finance/spark?interval=", interval, "&range=", range, "&symbols=", symbol) )

    raws <- fetch_yahoo(url, .verbose = .verbose)

    if(length(raws) == 1) if(is.na(raws)) return(raws)

    results <- raws[[1]]

    if(length(results) == 0) return(NA)

    if(length(results$timestamp) != length( results$close)) return(NA)

    short_historic <- data.frame(symbol = results$symbol
                                 , timestamp = as.POSIXct(results$timestamp)
                                 , close = results$close )

    short_historic <- standardize_df_cols(short_historic)
  })


  returned_results <- do.call(rbind, histo_light_results)
  # next function will return na if the data.frame is full of na
  return(construct_financial_df(returned_results))
}


#' Get Historic of Devises Exchanges Rates
#'
#' Get a `data.frame` of historical values of exchanges rates, given currencies to exchange.
#' Default parameters are a period of 1 year (1 obs. per day), and convert to USD ($).
#' @inheritParams get_changes
#' @param interval `character`, default = `"1d"`. The interval between 2 rows of the time.series answered
#' | **Valid `interval` values**                                       |
#' |-------------------------------------------------------------------|
#' |  `"1m"`, `"2m"`, `"3m"`, `"5m"`, `"15m"`, `"30m"`, `"1h"`, `"4h"`, `"1d"`, `"1wk"`, `"1mo"`, `"3mo"` |
#'
#' @param range `character`, default = `"1y"`. The period covered by the time series.
#' | **Valid `range` values**                                                    |
#' |-------------------------------------------------------------------------------|
#' |  `"1d"`, `"5d"`, `"1m"`, `"3m"`, `"6m"`, `"1y"`, `"5y"`, `"ytd"`, `"all"` |
#'
#' @inherit get_changes references
#' @return A `data.frame` with the historic of exchanges rates on a given period, default is daily results for a year.
#'   The columns are:
#'   \item{timestamp}{`POSIXct` The opening price for the period (default is each day).}
#'   \item{close}{`numeric` The closing price for the period (default is each day).}
#'   \item{low}{`numeric` The highest price for the period (default is each day).}
#'   \item{open}{`integer` The traded volume.}
#'   \item{high}{`numeric` The lowest price for the period (default is each day).}
#'   \item{from}{`character` - The currency converted into another, e.g., if the `from` value is 1$ ('USD'), you want to receive a certain amount of the other (`to`) currency to reach 1$.}
#'   \item{to}{`character` -  The currency exchanged back against a value of 1 of the `from` currency. The currencies-related `numeric` values in this line of the `data.frame` are expressed with this currency**.}
#'  Depending on the desired interval, recent observation will be truncated,
#'  e.g., a `'5y'` range  with a `'1d'` interval will answer approximately 30 days of values from 5 years ago.
#' @inherit construct_financial_df details
#' @examples
#' days <- get_changes_historic(from = c("EUR", "JPY"))
#' days_bis <- get_changes_historic(from = c("EUR" = "RON", "USD" = "EUR"))
#'
#' # Or pass paired values as 2 list (equivalent to hereabove line) :
#' same_as_days_bis <- get_changes_historic(from = c("EUR", "USD"), to =c("RON" , "EUR"))
#'
#' # Tweak interval and range
#' months <- get_changes_historic(from = c("EUR", "JPY"), interval = "1mo", range = '5y')
#' str(months)
#' @seealso \code{\link{get_changes}}
#' @seealso For more details see the help vignette:
#' \code{`vignette("currencies", package = "financr")`}
#' @export
get_changes_historic <- function(from = NULL, to = "USD"

                                 , interval = "1d"
                                 , range = "1y",  .verbose = T){

  historic <- get_changes(from = from, to = to, interval = interval, range = range, .verbose = .verbose )

  if(length(historic) == 0) return(historic)
  if(length(historic) == 1) if(is.na(historic)) return(NA)

  historic <- construct_financial_df(historic)

  return(historic)
}


