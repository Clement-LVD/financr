#' Validate Financial Symbols
#'
#' This function checks the validity of one or multiple financial symbols using Yahoo Finance's validation API.
#' It returns a table of boolean values indicating whether each symbol is recognized by Yahoo Finance.
#'
#' @param symbols `character` A string or a list of character strings representing financial symbols to validate.
#' @param .verbose `logical` If TRUE, messages are displayed when invalid symbols are detected. Default is TRUE.
#' @param ... Other symbols (char. or list of char.)
#' @return A boolean table with one row and as many columns as the number of *unique* symbols provided by the user.
#' Each column corresponds to a symbol, with TRUE if Yahoo Finance recognizes the symbol, and FALSE otherwise.
#'
#' @examples
#' valid_symbol("AAPL,GOOGL")
#' valid_symbol(symbols = c("AAPL", "GOOGL", "INVALID"))
#' @references Source : https://query2.finance.yahoo.com/v6/finance/quote/validate
#' @export
valid_symbol <- function(symbols = NULL, ..., .verbose = T) {

   symbols <- c(symbols, ...)
   symbols <- symbols[!is.na(symbols)] # deal with na values
  symbols <- toupper(gsub(" *", "", symbols, perl = T )) # suppress spaces and uppercase

  symbols <- unique(symbols)

  initial_symbols <- symbols #last trace before concatenation

  symbols <- paste0(initial_symbols, collapse = ",")


   url <- paste0('https://query2.finance.yahoo.com/v6/finance/quote/validate?symbols=', symbols)

  if (!internet_or_not()) {message("No internet access.") ; return(NULL) }

  results <- fetch_yahoo(url)

  # table with one entry per symbols
  validity <- results$symbolsValidation$result

  # reorder with the initial vector
  initial_l <- length(initial_symbols)
  if(all(ncol(validity) == initial_l, initial_l > 1)){ validity <- validity[, initial_symbols ]  }

  if(any(validity == F)) if(.verbose) message("Invalid financial symbol(s) : ", paste0(colnames(validity)[validity == F] , collapse = ", ") )

  return(validity)

}
