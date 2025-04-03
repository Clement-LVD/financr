#' Get Latest Cryptocurrencies Values (USD) and Market Data
#'
#' Return a `data.frame` of latest financial data for 100 cryptocurrencies, e.g., actual values of each cryptocurrency in USD.
#'
#' @references Source : Yahoo Finance 'crypto' page, \url{https://finance.yahoo.com/markets/crypto/all/}
#' @inheritParams get_currencies
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
#' @examples
#' krypto <- get_crypto()
#' head(krypto)
#' @export
get_crypto <- function(keep = NULL, .verbose = T){


  if(!internet_or_not()) return(NA)

  url <- "https://finance.yahoo.com/markets/crypto/all/?count=100"

  krypt <- fetch_yahoo(url, .verbose = .verbose)

  if(is.null(krypt) | all(is.na(krypt))) return(krypt)
# colnames : erase space, replace '%' by percent, etc.
  krypt <-  standardize_df_cols(krypt)
# extract text : common pattern to several yahoo tables
  krypt$price <- extract_before_sep(krypt$price)
  krypt <- standardize_df_cols_to_numeric(krypt)
# capture before and after the -
  capture_groups <- "(.*)-(.*)"
krypt$from <- gsub(pattern = capture_groups, "\\1" , x = krypt$symbol )
krypt$to <- gsub(pattern = capture_groups, "\\2" , x = krypt$symbol )

if(!is.null(keep) ) {krypt <- krypt[which(krypt$from  %in% keep), ]}

return(construct_financial_df(krypt, crypto = T))
}
