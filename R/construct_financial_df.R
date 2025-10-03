#' Construct Attributes for a Financial Data Frame
#'
#' This internal function constructs and assigns specific attributes
#' to a financial data frame, providing metadata about its contents.
#' @param df `data.frame` The function compute statistics with the `to` column (if available) or the `currency` column
#' @param ... Attribute(s) to add to the returned `data.frame`
#' @param crypto `logical` Attribute predefined if cryptocurrencies are in the dataset
#' @details
#' Return a `data.frame` with additional attributes:
#' \describe{
#'   \item{n.currencies}{`integer` - Number of unique currencies in the `data.frame`.}
#'   \item{currencies}{`character` - A vector of currency symbols in the `data.frame` (e.g., `"BTC"`, `"ETH"`, `"USD"`).}
#'   \item{exchange}{`character` - A vector of exchange pairs (e.g., `"BTC => USD"`). If not applicable, `NULL` (no entry).}
#'   \item{date.fetch}{`Date` - The date when the data was retrieved, set using `Sys.Date()`.}
#'   \item{crypto}{`logical` - `TRUE` if cryptocurrencies are present, otherwise `FALSE`.}
#'   \item{date.begin}{`POSIXct` - The oldest observation in the dataset.}
#'   \item{date.end}{`POSIXct` - The most recent observation in the dataset.}
#'   \item{date.dif}{`numeric` - The number of *seconds* between date.begin and date.end, equivalent of `difftime` value.}
#' }
#' See `vignette("Functions_summary", package = "financr")`
#' @keywords internal
construct_financial_df <- function(df, crypto = NULL , ...){
if(!is.data.frame(df)) return(NA)
if(length(df) == 0) return(df)
namm <- colnames(df)

# init values
exchange = NULL
n_currencies = NULL
currencies = NULL
to_exchange = NULL
date_old = NULL
date_new = NULL

if("currency" %in% namm) {
  currencies <- unique(df$currency)
  n_currencies <- length(currencies)
  to_exchange = currencies
  }

if("to" %in% namm) {

from = unique(df$from)
to = unique(df$to)
to_exchange = to
# currency variable is sometimes tricky because of cryptocurrencies (reverse behavior from Yahoo or the code ?)
# so we take 'to' columns in any case
currencies <- unique(c(from, to))
n_currencies <- length(currencies)

exchange <- paste(df$from , df$to, sep = " => " )
exchange <-  unique(exchange)
}

if("timestamp"  %in% namm){date_old = min(df$timestamp) ; date_new = max(df$timestamp)}
if("regularmarkettime"  %in% namm){date_old = min(df$regularmarkettime) ; date_new = max(df$regularmarkettime)}

date_dif = as.numeric(date_new - date_old)
if(length(date_dif) == 0) date_dif <- NULL
# return a data.frame
structure(df
            , n.currencies = n_currencies
          , currencies = currencies
            , exchange = exchange
          ,  date.fetch = Sys.Date()
          , crypto = crypto
          , date.begin = date_old
          , date.end = date_new
          , date.dif = date_dif
          , ...)



}

