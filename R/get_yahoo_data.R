#' Get Historical Financial Data For a Given Symbol
#'
#'  Get historical financial values associated with a ticker symbol.
#'  The data includes open stock price, high, low, close, volume, along with timestamps.
#'
#' The default `data.frame` have a line for each day.
#' If the user provide another range than '1d' (one day), lines will be filtered out, in order to match the desired range.
#'  Valid ranges are: "1d", "5d", "1mo", "3mo", "6mo", "1y", "2y", "5y", "10y", "ytd", and "max".
#'
#' The function allows the user to specify a date range using start and end dates. If no date range is specified,
#' it retrieves all available data from the beginning of time (default for start) to the current date (default for end).
#'
#' @param symbol `character` A character string representing the symbol for the financial instrument (e.g., "AAPL" for Apple).
#' @param start_date `character` A character string representing the start date in R `date` format (UTC time). If `NULL`, data starts from 1970-01-01.
#' @param end_date `character` A character string representing the end date in a valid R `date` format (UTC time). If `NULL`, data is retrieved up to the current date.
#' @param range `character` A character string representing the range for the returned datas : default will return daily values.
#' | **Valid `range` values**                                       |
#' |-------------------------------------------------------------------|
#' | `"1d"`, `"5d"`, `"1mo"`, `"3mo"`, `"6mo"`, `"1y"`, `"2y"`, `"5y"`, `"10y"`, `"ytd"` and `"max"` |
#' Other ranges will filter out some of these daily values, depending on the desired range.
#' Valid ranges are "1d", "5d", "1mo", "3mo", "6mo", "1y", "2y", "5y", "10y", "ytd", and "max".
#' @param add_dividends_and_splits default = `TRUE` - Add insights on dividends
#' @param .verbose `logical` If TRUE, messages are displayed, e.g., when invalid symbols are detected.
#' @return A data frame containing the historical financial data with the following columns:
#'   \item{open}{`numeric` The opening price for the period (default is each day).}
#'   \item{close}{`numeric` The closing price for the period (default is each day).}
#'   \item{low}{`numeric` The lowest price for the period (default is each day).}
#'   \item{high}{`numeric` The highest price for the period (default is each day).}
#'   \item{volume}{`integer` The traded volume.}
#'   \item{timestamp}{`integer` Unix timestamps corresponding to each data point.}
#'   \item{date}{`POSIXct` The day of the financial data point.}
#'   \item{currency}{`character` The currency in which the data is reported, depending on the marketplace.}
#'   \item{symbol}{`character` The stock or financial instrument symbol (e.g., "AAPL").}
#'   \item{shortname}{`character` The abbreviated name of the company or financial instrument.}
#'   \item{longname}{`character` The full name of the company or financial instrument.}
#'   \item{exchangename}{`character` The name of the exchange marketplace where the financial instrument is listed.}
#'   \item{fullexchangename}{`character` The full name of the exchange marketplace.}
#'   \item{timezone}{`character` The timezone in which the data is reported.}
#'   \item{gmtoffset}{`integer` The UNIX timestamp of difference between the market local time and the GMT time.}
#'   \item{regularMarketPrice}{`numeric` The actual price if market is open, or last closing price if not.}
#'   \item{fiftyTwoWeekLow}{`numeric`  Lowest price for the last 52 weeks.}
#'   \item{fiftyTwoWeekHigh}{`numeric` Highest price for the last 52 weeks.}
#'   \item{regularMarketDayHigh}{`numeric` The highest price of the day (local exchange place day).}
#'   \item{regularMarketDayLow}{`numeric`  The lowest price of the day (local exchange place day).}
#' @keywords internal
#' @references Source : https://query1.finance.yahoo.com/v8/finance/chart/
#' #example : data <- get_yahoo_data(symbol = "SAAB-B.ST", start_date = "2020-01-01", range = "1d")
get_yahoo_data <- function(symbol = "AAPL", start_date = NULL, end_date = NULL
                           , range = "1d"
                           , add_dividends_and_splits = TRUE
                           , .verbose = T) {
#### 1. Verify input ####
n_symbs <- length(symbol)
if( n_symbs > 1 ) {
  if( .verbose ) warning(immediate. = T, "get_yahoo_data() accept only 1 symbol and several have been indicated")
  return(NA)      }

if( n_symbs == 0 ) return(NULL)
if(!is.character(symbol)) return(NA)

  if(!all(valid_symbol(symbol, .verbose = .verbose))){ return(NA) }

  valid_ranges <- c( "1d" , "5d" , "1mo", "3mo" ,"6mo" ,"1y"  ,"2y" , "5y" , "10y", "ytd","max")
  if(!range %in% valid_ranges){
if( .verbose ) message("Specified range ('",range, "') is not a valid range. \nChoices are : ", paste0(collapse= ", ", valid_ranges ))
  return(NA)
  }


start_timestamp <- 0  # 0 timestamp is the default (01/01/1970)
end_timestamp <- as.integer(Sys.time())  # today is the default

# convert date to timestamps Unix
if(!is.null(start_date)) {
    start_date <- as.Date(start_date)
    start_timestamp <- as.integer(as.POSIXct(start_date, tz = "UTC")) }

if(!is.null(end_date)) {
    start_date <- as.Date(end_date)
    end_timestamp <- as.integer(as.POSIXct(end_date, tz = "UTC")) }

#### 2. Construct API request ####
url <- paste0(retrieve_yahoo_api_chart_url(), symbol)

# add parameters to the url for the yahoo api
params <- list(period1 = start_timestamp
             , period2 = end_timestamp
             , range = range )
# Paste params names and content with sep ('=' between names and content) AND collapse ('&')
query_string <- paste(names(params), params, sep = "=", collapse = "&")
full_url <- paste(url, "?", query_string, sep = "")

# Add other data : post market data and maybe dividends and splits
full_url <- paste0(full_url, "&includePrePost=true")

if(add_dividends_and_splits) full_url <-  paste0(full_url, "&events=div%7Csplit")

#### 3. Get data ####
data <- fetch_yahoo(full_url, .verbose = .verbose)

# deal with historical 'indicators' list and, after, 'timestamp' list
indicators <- data$chart$result$indicators$quote[[1]]

df_historic <-  data.frame(lapply(indicators, unlist))

col_to_retain <- c("open","close"  ,"low" , "high" , "volume" )
# add fake col
df_historic <- add_missing_var_to_df(df = df_historic, col_to_retain, .verbose = .verbose)

df_historic <- df_historic[ , col_to_retain ]

# add timestamp
df_historic$timestamp <- data$chart$result$timestamp[[1]]
df_historic$date <- as.POSIXct(df_historic$timestamp)


#1) global informations : we have func' for these meta list
# return to the "data" original dataset
meta_datas <- extract_changes_meta_list_of_tables(data$chart$result$meta)
# and the overall datas interesting for us :
meta_datas <- data$chart$result$meta

to_retain <-  c("currency", "symbol",  "shortName" , "longName", "exchangeName", "fullExchangeName"
                ,"timezone", "gmtoffset"
                , "regularMarketPrice", "fiftyTwoWeekLow", "fiftyTwoWeekHigh","regularMarketDayLow", "regularMarketDayHigh"
                # ,  "regularMarketVolume"
                )
meta_datas <- add_missing_var_to_df(df = meta_datas, to_retain, .verbose = .verbose)

col_to_add <- meta_datas[, to_retain]
# "regularMarketPrice" is the ADJUSTED price at closing time or the opening so it's shitty data

df_historic <- data.frame( df_historic,  col_to_add, check.names = FALSE, row.names = NULL)
# lot of redundancy but that's okaysh for the sake of limiting errors and misunderstood
colnames(df_historic) <- tolower(colnames(df_historic))

return(unique(df_historic))
}
