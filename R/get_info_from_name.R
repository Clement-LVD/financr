#' Get Latest Financial Information and Ticker Symbol From Company Name(s)
#'
#' Get latest overall insights and ticker symbols associated with free texts, such as companies names.
#' Several ticker symbols associated with various exchanges places could be returned, with
#' , companies names, last price on the marketplace,
#' sector/category (if available), etc.
#'
#' @param names A character string representing the company name to search for.
#' @param exchange (optionnal) A character string representing the exchange place(s) to consider (exact match). Default keep all the exchange places.
#' @param sector (optionnal)  A character string representing the sector(s) to consider (exact match). Default keep all results.
#' @return A data frame with columns:
#'
#' \describe{
#'   \item{symbol}{`character` - The ticker symbol associated with an asset, e.g., "VTI", "^DWCPF".}
#'   \item{name}{`character` - Name of the asset, e.g., ETF or index name.}
#'   \item{last_price}{`numeric` - The last price of the asset.}
#'   \item{sector}{`character` -  The sector or industry category if available, e.g., 'Industrials', 'Consumer Cyclical'.}
#'   \item{type}{`character` -   The type of asset (certainly "stocks").}
#'   \item{exchange}{`character` -   The stock exchange place for this asset, e.g., 'PAR' is Paris (FR) exchange place.}
#'   \item{searched}{`character` - The text searched on Yahoo, e.g., "Dow Jones".}
#'  }
#' @examples
#' oil <- get_info_from_name(names = c("Dow Jones", "Euronext"))
#' #Get data on marketplace(s)
#' cars <- get_info_from_name(names = c("RENAULT", "VOLVO"),  exchange = c("STO", "PAR"))
#' @seealso \code{\link{get_yahoo_data}}
#' @inherit construct_financial_df details
#' @references Source : search on https://finance.yahoo.com/lookup/
#' @export
get_info_from_name <- function(names, exchange = NULL, sector = NULL) {

  if(!internet_or_not()) return(NA)

 # loop over the names#
results <- lapply(names, function(name) {

base_url = "https://finance.yahoo.com/lookup/equity/?s="
url_complete <- paste0(base_url, name)
# fetch yahoo data
     table <-  fetch_yahoo(url_complete)

if(!is.list(table)) return(table) # certainly NA

     table$searched <- name
     return(table)
        })

results <- do.call(rbind, results)

if(is.null(results)) return(results)

results <- standardize_df_cols(results)

colnames(results)[grep("sector", colnames(results) )] <- "sector"

if(!is.null(sector)) results <- results[which(results$sector %in% sector), ]

# filter exchange
if(!is.null(exchange) ) {results <- results[which(results$exchange %in% exchange), ]}

return(construct_financial_df(unique(results)))
}



