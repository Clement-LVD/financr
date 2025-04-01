#' Get Historical Financial Data Indices
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
#' @seealso \code{\link{get_yahoo_data}}
#' @export
get_historic <- function(symbols = c("SAAB-B.ST"), wait.time = 0, .verbose = T, ...){

  if(!internet_or_not()) return(NA)

   # n_operations = length(symbols)

  # if(.verbose){ cat("\n=>", n_operations, "request(s) to Yahoo Finance (ETA : ", ( (wait.time + 0.3) * n_operations  ) ,  " sec')" )}

  result_actions = list()

stocks <- lapply(symbols, FUN = function(symbol) {

  results <- get_yahoo_data(symbol, .verbose = .verbose, ...)
# if only one result and it's a na : return na
if(length(results) == 1){ if(is.na(results)) return(NA) }

    results <- as.data.frame(results)

     Sys.sleep(wait.time)

if(.verbose){ cat("\r"); cat(' ', symbol, "[OK]", rep(" ", 50))}

    return(results)

    })

   returned_results <- do.call(rbind, stocks)
   if(.verbose){cat("\r"); cat("\n")}


if(is.null(returned_results)) return(NULL) #other problem such as no symbol at all
if( all(is.na(returned_results))) return(NA)

   returned_results <- construct_financial_df(returned_results  )
   return(returned_results)
}
