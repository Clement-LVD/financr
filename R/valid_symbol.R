#' Validate Financial Symbols
#'
#' Checks the validity of one or multiple financial symbols using Yahoo Finance's validation API.
#' Return a `data.frame` of boolean values indicating whether each symbol is recognized by Yahoo Finance.
#'
#' @param symbols `character` A string or a list of character strings representing financial symbols to validate.
#' @param .verbose `logical` If TRUE, messages are displayed when invalid symbols are detected. Default is TRUE.
#' @param ... Other symbols (char. or list of char.)
#' @return A boolean table with one row and as many columns as the number of *unique* symbols provided by the user.
#' Each column corresponds to a symbol, with TRUE if Yahoo Finance recognizes the symbol, and FALSE otherwise.
#'
#' @examples
#' valid_symbol("AAPL,GOOGL")
#' valid_symbol(symbols = c("CDF", "SCR", "INVALID"))
#' @references Source : https://query2.finance.yahoo.com/v6/finance/quote/validate
#' @export
valid_symbol <- function(symbols = NULL, ..., .verbose = T) {

   symbols <- c(symbols, ...)

   if(length(symbols) == 0) return(NULL)

  if (!internet_or_not(.verbose = .verbose)) return(NA)


     initial_symbols <- standardize_symbols(symbols)

    symbols <- paste0(initial_symbols, collapse = ",")

   url <- retrieve_yahoo_api_chart_url( paste0('v6/finance/quote/validate?symbols=', symbols))


  results <- fetch_yahoo(url)

  # table with one entry per symbols
  validity <- results$symbolsValidation$result

  # reorder with the initial vector
  initial_l <- length(initial_symbols)
  if(all(ncol(validity) == initial_l, initial_l > 1)){ validity <- validity[, initial_symbols ]  }

  if(any(validity == F)) if(.verbose) message("Invalid financial symbol(s) : ", paste0(colnames(validity)[validity == F] , collapse = ", ") )

  return(validity)

}

