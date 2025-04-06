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
#' \code{vignette("get_info_and_historic", package = "financr"))}
#' @export
get_historic <- function(symbols = c("SAAB-B.ST"), wait.time = 0, .verbose = T, ...){
  if(length(symbols) == 0) return(NULL)
  if(all(is.na(symbols))) return(NA)
  if(!is.character(symbols)) return(NA)
  if(!internet_or_not()) return(NA)

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
#' @return A `data.frame` with a few historical values :
#' \describe{
#'   \item{symbol}{`character` - Financial ticker symbol.}
#'   \item{timestamp}{`POSIXct` - Date of the observation (closing price).}
#'   \item{close}{`numeric` - Closing price of the asset.}
#'   }
#' @examples
#' histo_light <- get_historic_light(c("SAAB-B.ST", "AAPL"))
#' @export
get_historic_light <- function(symbols = "SAAB-B.ST", interval = '1d', range = '1mo' , .verbose = F){
if(length(symbols) == 0) return(NULL)
if(all(is.na(symbols))) return(NA)
if(!is.character(symbols)) return(NA)
if(!internet_or_not()) return(NA)

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



