#' Get Currencies Names, Symbols and Values
#'
#' Return a `data.frame` of financial indices (currencies) given a vector of symbols, e.g., 'EUR'.
#' Optionally, it can filter the results and add the last market price ('USD') of these currencies.
#'
#' @param keep A character vector of symbols to filter the results. If NULL (default),
#'                  no filtering is applied, and all available indices are returned.
#' @param last_usd_values `logical`, default = `FALSE`. If `TRUE`, add latest market values ('USD') from `get_changes()`. See [get_changes()] for the base structure.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console if necessary.
#' @return A data frame containing unique financial indices (currencies). The table has
#'         columns like `symbol`, `name`, and other relevant information, with all column names in lowercase.
#'         If `keep` is specified, only the matching currencies are returned. If `last_usd_values` is specified, last financial insights from `get_changes()` will be added, e.g., last market values of each currency ('USD')
#' @examples
#' # Fetch all available indices
#' all_indices <- get_currencies()
#'
#' # Fetch only specific indices
#' selected_indices <- get_currencies(keep = c("USD", "EUR"))
#' @references Source : https://query2.finance.yahoo.com/v1/finance/currencies
#' @inherit construct_financial_df details
#' @seealso \code{\link{get_changes}}
#' @seealso For more details see the help vignette:
#' \code{vignette("get_changes", package = "financr"))}
#' @export
get_currencies <- function(keep = NULL, last_usd_values = F, .verbose = T) {


  if(!internet_or_not()) return(NA)

  url <- retrieve_yahoo_api_chart_url(suffix = "v1/finance/currencies")

currencies <- fetch_yahoo(url, .verbose = .verbose )

if(is.null(currencies) | is.na(currencies)) return(currencies) # # nocov

    results <- currencies$currencies$result

    # filter indices
    if(!is.null(keep) ) {results <- results[which(results$symbol  %in% keep), ]}

    colnames(results) <- tolower(colnames(results))

if(last_usd_values) {

values_to_add <- get_changes(from = results$symbol, .verbose = .verbose)

values_to_add <- values_to_add[, setdiff(colnames(values_to_add), colnames(results))]

results <- merge(x = results, y = values_to_add, by.x = "symbol", by.y = "from", all.x = T, all.y = F)
    }

results <- unique(results)

return(construct_financial_df(results))
  }
