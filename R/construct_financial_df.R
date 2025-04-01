#' Construct Attributes for a Financial Data Frame
#'
#' This internal function constructs and assigns specific attributes
#' to a financial data frame, providing metadata about its contents.
#' @param df `data.frame` The function compute statistics with the `to` column (if available) or the `currency` column
#' @param crypto `logical` Attribute predefined if cryptocurrencies are in the dataset
#' @details
#' Return a `data.frame` with additionnal attributes:
#' \describe{
#'   \item{n.currencies}{`integer` - Number of unique currencies in the `data.frame`.}
#'   \item{currencies}{`character` - A vector of currency symbols in the `data.frame` (e.g., `"BTC"`, `"ETH"`, `"USD"`).}
#'   \item{exchange}{`character` - A vector of exchange pairs (e.g., `"BTC => USD"`). If not applicable, `NULL` (no entry).}
#'   \item{date}{`Date` - The date when the data was retrieved, set using `Sys.Date()`.}
#'   \item{crypto}{`logical` - `TRUE` if cryptocurrencies are present, otherwise `FALSE`.}
#' }
#'
#' @seealso Other functions that use these attributes can reference this documentation.
#'
#' @keywords internal
construct_financial_df <- function(df, crypto = F , ...){

namm <- colnames(df)

# init values
exchange = NULL
n_currencies = NULL
currencies = NULL
to_exchange = NULL

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

# return a data.frame
structure(df
            , n.currencies = n_currencies
          , currencies = currencies
            , exchange = exchange
          ,  date = Sys.Date()
          , crypto = crypto
          , ...)



}

