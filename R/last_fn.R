
# a last_ prefix indicates that all inputs are optionnal

#### 1) Scraping ####

#' Get Latest Cryptocurrencies Values (USD) and Market Data
#'
#' Return a `data.frame` of latest financial data for 100 cryptocurrencies, e.g., actual values of each cryptocurrency in USD.
#'
#' @references Source : Yahoo Finance 'crypto' page, \url{https://finance.yahoo.com/markets/crypto/all/}
#' @inheritParams last_currencies
#' @return A data frame with 100 observations and 13 variables:
#' \describe{
#'   \item{symbol}{`character` - Cryptocurrency ticker symbol.}
#'   \item{name}{`character` - Name of the cryptocurrency, along with its quoted 'real-world' currency.}
#'   \item{price}{`numeric` - Current price of the cryptocurrency in USD ($).}
#'   \item{change}{`numeric` - Absolute price change in USD since the last closing of the exchange place.}
#'   \item{change_percent}{`numeric` - Percentage price change since the last closing of the exchange place (%).}
#'   \item{market_cap}{`numeric` - Total market capitalization of the cryptocurrency.}
#'   \item{volume}{`numeric` - 24-hour trading volume.}
#'   \item{volume_in_currency_24hr}{`numeric` - 24-hour trading volume in the associated 'real-world' currency (most of the time redundant with the `volume` column).}
#'   \item{total_volume_all_currencies_24hr}{`numeric` - 24-hour total trading volume across all currency pairs.}
#'   \item{circulating_supply}{`numeric` - Total circulating supply of the cryptocurrency.}
#'   \item{X52_wk_change_percent}{`numeric` - Percentage change in price over the last 52 weeks (%).}
#'   \item{from}{`character`, the currency converted into another, e.g., if the `from` value is 1$ ('USD'), you want to receive a certain amount of the other currency to reach 1$.}
#'   \item{to}{`character`, the currency that you want to convert into : **all the `numeric` values (not `integer`) in this line of the `data.frame` are expressed with this currency**.}
#' }
#' @inherit construct_financial_df details
#' @seealso For more details on the 'last_' family of functions see the help vignette:
#' \code{vignette("last_family")}
#' @examples
#' krypto <- last_crypto()
#' head(krypto)
#' @export
last_crypto <- function(keep = NULL, .verbose = T){


  if(!internet_or_not()) return(NA)

  url <- "https://finance.yahoo.com/markets/crypto/all/?count=100"

  krypt <- fetch_yahoo(url, .verbose = .verbose)

  if(is.null(krypt) | all(is.na(krypt))) return(krypt)
  # colnames : erase space, replace '%' by percent, etc.
  krypt <-  standardize_df_cols(df = krypt)
  # extract text : common pattern to several yahoo tables
  krypt$price <- extract_before_sep(krypt$price)
  # capture before and after the -
  capture_groups <- "(.*)-(.*)"
  krypt$from <- gsub(pattern = capture_groups, "\\1" , x = krypt$symbol )
  krypt$to <- gsub(pattern = capture_groups, "\\2" , x = krypt$symbol )

  if(!is.null(keep) ) {krypt <- krypt[which(krypt$from  %in% keep), ]}

  return(construct_financial_df(krypt, crypto = T))
}


#' Get World Financial Indices Latest Values (USD)
#'
#' Get latest stock market indices values and data for more than 40 world-indices,
#' e.g., latest prices, change and percentage change.
#' @inheritParams last_currencies
#' @references Source : Yahoo's world indices page - https://finance.yahoo.com/markets/world-indices
#' @return A data frame with the following columns:
#'   \item{symbol}{`character` - Ticker symbol of the index, aka world indices (e.g., `^GSPC` for S&P 500).}
#'   \item{name}{`character` -  Full name of the index (e.g., "S&P 500").}
#'   \item{price}{`numeric` - Current value of the index (USD).}
#'   \item{change}{`numeric` - Absolute change in index value since the last closing of the exchange place.}
#'   \item{change_percent}{`numeric` - Percentage change in index value since the last closing of the exchange place.}
#'   \item{volume}{`numeric` - The total trading volume of the index components.}
#'   \item{currency}{`character` - Currency associated with the world-indice, i.e. `'USD'`.}
#' @inherit construct_financial_df details
#' @seealso For more details on the 'last_' family of functions see the help vignette:
#' \code{vignette("last_family")}
#' @examples
#' \dontrun{
#' indices <- last_indices()
#' head(indices)
#' }
#' @export
last_indices <- function(.verbose = T, keep = NULL){

  if(!internet_or_not()) return(NA)

  url = "https://finance.yahoo.com/markets/world-indices/?count=100"
  indices <- fetch_yahoo(url, .verbose = .verbose)

  if(is.null(indices)) return(NA)

  indices <- standardize_df_cols(indices)

  if(!is.null(keep) ) {indices <- indices[which(indices$symbol  %in% keep), ]}

  indices$price <- extract_before_sep(indices$price)

  indices$currency <- "USD"

  return(construct_financial_df(indices))

}


#### 2) Fetching the API ####

#' Get Currencies Names, Symbols and Add Latest 'USD' Values
#'
#' Return a `data.frame` of financial indices (currencies) given a vector of symbols, e.g., 'EUR'.
#' Optionally, it can filter the results and add the last market price ('USD') of these currencies.
#'
#' @param keep A character vector of symbols to filter the results (perl expression, ignoring case). If NULL (default),
#'                  no filtering is applied, and all available indices are returned.
#' @param add_usd_values `logical`, default = `FALSE`. If `TRUE`, add latest market values ('USD') from `get_changes()`. See [get_changes()] for the base structure.
#' @param .verbose `logical`, default = `TRUE`. If `TRUE`, send messages to the console if necessary.
#' @return A data frame containing unique financial indices (currencies). The table has
#'         columns like `symbol`, `name`, and other relevant information, with all column names in lowercase.
#'         If `keep` is specified, only the matching currencies are returned. If `add_usd_values` is specified, last financial insights from `get_changes()` will be added, e.g., last market values of each currency ('USD')
#' @examples
#' # Fetch all available indices
#' all_indices <- last_currencies()
#'
#' # Fetch only specific indices
#' selected_indices <- last_currencies(keep = c("^Z", "EUR"))
#' @references Source : https://query2.finance.yahoo.com/v1/finance/currencies
#' @inherit construct_financial_df details
#' @seealso \code{\link{get_changes}}
#' @seealso For more details see the help vignette:
#' \code{vignette("currencies", package = "financr"))}
#' @export
last_currencies <- function(keep = NULL, add_usd_values = F, .verbose = T) {


  if(!internet_or_not()) return(NA)

  url <- retrieve_yahoo_api_chart_url(suffix = "v1/finance/currencies")

  currencies <- fetch_yahoo(url, .verbose = .verbose )

  if(is.null(currencies) | is.na(currencies)) return(currencies) # # nocov

  results <- currencies$currencies$result

  # filter indices
  if(!is.null(keep) ) {results <- results[grep( paste0(keep, collapse = "|"), x = results$symbol, ignore.case = T, perl = T), ]}

results <- standardize_df_cols(results)

  if(add_usd_values) {

    values_to_add <- get_changes(from = results$symbol, .verbose = .verbose)

    values_to_add <- values_to_add[, setdiff(colnames(values_to_add), colnames(results))]

    results <- merge(x = results, y = values_to_add, by.x = "symbol", by.y = "from", all.x = T, all.y = F)
  }

  results <- unique(results)

  return(construct_financial_df(results))
}


#' Retrieve Market Index Summary Latest Data
#'
#' Return a `data.frame` with latest summary information for a set of major financial market indices.
#'
#' @param .verbose `logical`, default = `FALSE` - Logical flag indicating whether to print verbose output for debugging or informational purposes.
#' @param region `character`, default = `NULL` (no filtering) - Select a region for filter out the results.
#'
#' | **Valid `region` values**                                                     |
#' |-------------------------------------------------------------------------------|
#' |  `"US"` , `"AU"` , `"CA"` , `"FR"` , `"DE"` , `"HK"` , `"US"` , `"IT"` , `"ES"` , `"GB"` , `"IN"` |
#'
#' @return A data frame with 15 rows and 38 variables. Each row corresponds to a market index and includes the following information:
#' \itemize{
#'   \item \code{symbol}, \code{shortname}, \code{longname}, \code{exchange}, \code{region}, \code{currency}
#'   \item Market time info: \code{regularmarkettime_raw}, \code{regularmarkettime_fmt}
#'   \item Market pricing info: \code{regularmarketprice_raw}, \code{regularmarketchange_raw}, \code{regularmarketchangepercent_raw}, etc.
#'   \item Metadata such as \code{marketstate}, \code{quotetype}, \code{pricehint}, \code{exchangedatadelayedby}, \code{hasprepostmarketdata}
#'   \item Other fields such as \code{cryptotradeable}, \code{tradeable}, \code{triggerable}, \code{contracts}, etc.
#' }
#' @references Source : https://query2.finance.yahoo.com/v6/finance/quote/marketSummary
#' @seealso For more details on the 'last_' family of functions see the help vignette:
#' \code{vignette("last_family")}
#' @examples
#' df <- last_market_summary()
#'
#' df_fr <- last_market_summary(region = "FR")
#' @export
last_market_summary <- function(region = NULL, .verbose = TRUE){

  if(!internet_or_not()) return(NA)

  lang = "?lang=en"

  if(!is.null(region)) lang <- paste0(lang, "&region=", region)

  url <- retrieve_yahoo_api_chart_url(suffix = paste0("v6/finance/quote/marketSummary", lang) )

  market <- fetch_yahoo(url, .verbose = .verbose)
  # security if yahoo api is not available :
  if(length(market[[1]]) == 1) if(is.na(market[[1]])) return(NA)


  results <- market$marketSummaryResponse$result

  results <- standardize_df_of_dfs(df = results)
  #this run standardize_col for us

  return( construct_financial_df(results) )

}

