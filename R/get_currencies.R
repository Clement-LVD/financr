#' Get Currencies Names And Symbol
#'
#' Return a `data.frame` of financial indices (currencies) from Yahoo Finance.
#' Optionally, it can filter the results, given a vector of symbols, e.g., 'EUR'.
#'
#' @param keep A character vector of symbols to filter the results. If NULL (default),
#'                  no filtering is applied, and all available indices are returned.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console if necessary.
#' @return A data frame containing unique financial indices (currencies). The table has
#'         columns like `symbol`, `name`, and other relevant information, with all column names in lowercase.
#'         If `keep` is specified, only the matching indices are returned.#'
#' @examples
#' # Fetch all available indices
#' all_indices <- get_currencies()
#'
#' # Fetch only specific indices
#' selected_indices <- get_currencies(keep = c("USD", "EUR"))
#' @references Source : https://query1.finance.yahoo.com/v1/finance/currencies
#' @export
get_currencies <- function(keep = NULL, .verbose = T) {


  if(!internet_or_not()) return(NA)

  url <- retrieve_yahoo_api_chart_url(suffix = "v1/finance/currencies")
  # url <- "https://query1.finance.yahoo.com/"

currencies <- fetch_yahoo(url, .verbose = .verbose )

if(is.null(currencies) | is.na(currencies)) return(currencies)

    results <- currencies$currencies$result

    # filter indices
    if(!is.null(keep) ) {results <- results[which(results$symbol  %in% keep), ]}

    colnames(results) <- tolower(colnames(results))

    return(unique(results))
  }
