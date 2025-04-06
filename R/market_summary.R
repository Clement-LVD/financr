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
#'
#' @examples
#' df <- market_summary()
#'
#' df_fr <- market_summary(region = "FR")
#' @export
market_summary <- function(region = NULL, .verbose = TRUE){

    if(!internet_or_not()) return(NA)

  lang = "?lang=en"

if(!is.null(region)) lang <- paste0(lang, "&region=", region)

url <- retrieve_yahoo_api_chart_url(suffix = paste0("v6/finance/quote/marketSummary", lang) )

market <- fetch_yahoo(url, .verbose = .verbose)
# security if yahoo api is not available :
if(length(market[[1]]) == 1) if(is.na(market[[1]])) return(NA)


results <- market$marketSummaryResponse$result

results <- standardize_df_of_dfs(df = results) #from utils.R

results <- standardize_df_posixct_for_big_number(results)

return( construct_financial_df(results) )

}



