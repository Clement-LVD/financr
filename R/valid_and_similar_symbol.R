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

  if (!internet_or_not()) return(NA)


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

#' Find Similar Financial Symbols
#'
#' Given symbol(s), retrieve identical symbols (according to Yahoo Finance) and a score of similarity.
#'
#' @param symbols `character` A character string representing a financial symbol to search.
#' @param .verbose `logical` If TRUE, messages are displayed when invalid symbols are detected. Default is TRUE.
#' @param ... Other symbols (char. or list of char.)
#' @return A boolean table with one row and as many columns as the number of *unique* symbols provided by the user.
#' Each column corresponds to a symbol, with TRUE if Yahoo Finance recognizes the symbol, and FALSE otherwise.
#'
#' @examples
#' similar_symbol(symbols =   "AAPL,GOOGL")
#' similar_symbol(symbols =   c("AAPL", "GOOGL"))
#' @references Source : https://query2.finance.yahoo.com/v6/finance/quote/validate
#' @export
similar_symbol <- function(symbols = "SAAB-B.ST", .verbose = F, ...){

  symbols <- c(symbols, ...)

  if(length(symbols) == 0) return(NULL)
if(all(is.na(symbols))) return(NA)

  if(!internet_or_not()) return(NA)

symbols <- symbols[!is.na(symbols)]

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


# function for standardizing symbols
standardize_symbols <- function(symbols){
  symbols <- symbols[!is.na(symbols)] # deal with na values
  symbols <- toupper(gsub(" *", "", symbols, perl = T )) # suppress spaces and uppercase
  return(unique(symbols))
}

