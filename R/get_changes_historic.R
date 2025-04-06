#' Get Historic of Exchange Rates For Devises
#'
#' Get a `data.frame` of historical values of exchanges rates, given currencies to exchange.
#' Default parameters will return a period of 1 year (1 obs. per day) and convert to USD.
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
#' @details
#' For each pair of 'from' and 'to' currency, it returns a `data.frame` with the historical exchanges rates on a given period (default is daily results for a year)

#' @inherit get_changes references
#' @return A `data.frame` containing the historical exchanges rates on a given period (default is daily results for a year).
#'   The columns are:
#'   \item{timestamp}{`POSIXct` The opening price for the period (default is each day).}
#'   \item{close}{`numeric` The closing price for the period (default is each day).}
#'   \item{high}{`numeric` The lowest price for the period (default is each day).}
#'   \item{low}{`numeric` The highest price for the period (default is each day).}
#'   \item{open}{`integer` The traded volume.}
#'   \item{from}{`character`, the currency converted into another, e.g., if the `from` value is 1$ ('USD'), you want to receive a certain amount of the other currency to reach 1$.}
#'   \item{to}{`character`, the currency that you want to convert into : **all the `numeric` values (not `integer`) in this line of the `data.frame` are expressed with this currency**.}
#'  Depending on the desired interval, recent observation will be truncated,
#'  e.g., a `'5y'` range  with a `'1d'` interval will answer approximately 30 days of values from 5 years ago.
#' @inherit construct_financial_df details
#' @examples
#' days <- get_changes_historic(from = c("EUR", "JPY"))
#' days_bis <- get_changes_historic(from = c("EUR" = "RON", "USD" = "EUR"))
#' # Or pass paired values as 2 list (equivalent to hereabove line) :
#' same_as_days_bis <- get_changes_historic(from = c("EUR", "USD"), to =c("RON" , "EUR"))
#' months <- get_changes_historic(from = c("EUR", "JPY"), interval = "1mo", range = '5y')
#' @seealso \code{\link{get_changes}}
#' @seealso For more details see the help vignette:
#' \code{vignette("get_changes", package = "financr"))}
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
