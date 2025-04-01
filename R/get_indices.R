#' Get World Financial Indices Latest Values (USD)
#'
#' Get latest stock market indices values and data for more than 40 world-indices,
#' e.g., latest prices, change and percentage change.
#' @inheritParams get_currencies
#' @references Source : Yahoo's world indices page, https://finance.yahoo.com/markets/world-indices
#' @return A data frame with the following columns:
#'   \item{symbol}{`character` - Ticker symbol of the index, aka world indices (e.g., `^GSPC` for S&P 500).}
#'   \item{name}{`character` -  Full name of the index (e.g., "S&P 500").}
#'   \item{price}{`numeric` - Current value of the index (USD).}
#'   \item{change}{`numeric` - Absolute change in index value since the last closing of the exchange place.}
#'   \item{change_percent}{`numeric` - Percentage change in index value since the last closing of the exchange place.}
#'   \item{volume}{`numeric` - The total trading volume of the index components.}
#'   \item{currency}{`character` - Currency associated with the world-indice, i.e. `'USD'`.}
#' @inherit construct_financial_df details
#' @examples
#' \dontrun{
#' indices <- get_indices()
#' head(indices)
#' }
#' @export
get_indices <- function(.verbose = T, keep = NULL){

if(!internet_or_not()) return(NULL)

url = "https://finance.yahoo.com/markets/world-indices/?count=100"
indices <- fetch_yahoo(url, .verbose = .verbose)

if(is.null(indices)) return(NULL)

indices <- standardize_df_cols(indices)

if(!is.null(keep) ) {indices <- indices[which(indices$symbol  %in% keep), ]}

indices$price <- extract_before_sep(indices$price)

indices <- standardize_df_percent_col(indices)

indices$volume <- standardize_df_convert_abbr_to_numeric(indices$volume)

indices$currency <- "USD"

return(construct_financial_df(indices))

}
