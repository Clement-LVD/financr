#### Search from free-text(s) ####

###### 1) Fetch Yahoo API ######

#' Search Financial Asset From Keywords (Multiple Texts)
#'
#' Get ticker symbols associated with free texts, such as companies names.
#' Several ticker symbols associated with various exchanges places could be returned, with
#'  companies names, sector/category (if available), etc.
#'
#' @param texts `character` A character string or a list of character representing the text(s) to search for, e.g., company names.
#' @param type (optionnal) A character string representing a type of asset to search for ('quotetype' column value is used to filter out results). Case insensitive.
#'
#' |Type       |Description                                                             |
#' |:----------|:-----------------------------------------------------------------------|
#' |ETF        |Exchange-Traded Fund - A basket of stocks or bonds traded like a stock. |
#' |EQUITY     |Equity - A stock representing ownership in a company.                   |
#' |MUTUALFUND |Mutual Fund - A pooled investment fund.                                 |
#' |INDEX      |Index - A benchmark representing a group of stocks (e.g., S&P 500).     |
#' |FUTURE     |Future - A contract to buy/sell an asset at a future date and price.    |
#'
#' @param exchange (optionnal)  A character string representing the exchange place(s) to consider - exact match, e.g., 'STO' (Stockholm stock exchange). Default keep all results.
#' @param .verbose `logical`, default = `FALSE` If TRUE, messages are displayed, e.g., when invalid symbols are detected.
#' @return A data frame with the following columns:
#' \describe{
#'   \item{symbol}{`character` - The ticker symbol associated with an asset, e.g., "VTI", "^DWCPF".}
#'   \item{shortname}{`character` - A short name for the asset, e.g., ETF or index name.}
#'   \item{longname}{`character` - The full name of the asset, such as the full ETF or index name - sometimes not returned by Yahoo.}
#'   \item{exchange}{`character` - The exchange where the asset is listed, e.g., "PCX", "DJI", "NGM".}
#'   \item{exchdisp}{`character` - The full name of the exchange place where the asset is traded, e.g., "NYSEArca", "Dow Jones".}
#'   \item{quoteType}{`character` - The type of asset, e.g., "FUTURES", "INDEX".}
#'   \item{typeDisp}{`character` - The type of asset, formatted for display, e.g., "Futures", "Index").}
#'   \item{score}{`numeric` - A numerical score assigned by Yahoo in order to indicate the relevance of the matched result, i.e. similarity with the text.}
#'   \item{isYahooFinance}{`logical` - Indicates whether the symbol is recognized by Yahoo Finance - should always be `TRUE` in this context.}
#'   \item{searched}{`character` - The text searched on the Yahoo API, e.g., "Dow Jones".}
#' }
#' @examples
#' indices <- search_assets(texts = c("Dow jones", "euronext"), type = "index" )
#'
#' swedish <- search_assets(c("VOLVO car", "RENAULT"),  exchange = c("STO", "PAR"))
#' head(swedish)
#' @inherit construct_financial_df details
#' @references Source : https://query2.finance.yahoo.com/v1/
#' @seealso For more details see the help vignette:
#' \code{vignette("get_info_and_historic", package = "financr"))}
#' @export
search_assets <- function(texts, .verbose = F, exchange = NULL,  type = NULL){
# url = "https://query2.finance.yahoo.com/v1/finance/search?q=saab"
if (!is.character(texts)) { return(texts) }

texts <- texts[!is.na(texts)]
if(length(texts) == 0) return(NULL)

texts <- as.character(unique(texts))
texts <- tolower(texts)
if(!internet_or_not()) return(NA)

url = retrieve_yahoo_api_chart_url(suffix ="v1/finance/search?q=" )

urls  = paste0(url, texts)

results <- lapply(urls, function(urll) {

searched_value <- gsub(pattern = ".*search\\?q\\=", "",x =  urll )

  datas <- fetch_yahoo(url = urll, .verbose = .verbose)

  if(length(datas) == 0) return(NULL)

 main <- datas$quotes

 if(length(main) == 0) return(NULL)


main <- standardize_df_cols(df = main)

cols_to_keep <- c( "symbol",  "shortname", "longname" ,"exchange", "exchdisp"
               , "quotetype", "typedisp", "searched"
               # , "index"
               , "score", "isyahoofinance"
                  )
cols_existing <- intersect(cols_to_keep, colnames(main))
main <- main[, cols_existing, drop = FALSE]

main <- add_missing_var_to_df(main, cols_to_keep)

main$searched <- searched_value

return(main)
}
)


if(length(results) == 0) return(results)

returned_results <- do.call(rbind, results)
if(is.null(returned_results)) return(NA)
# filtering and return a financial_df

if(!is.null(type   )) returned_results <- returned_results[which(tolower(returned_results$quotetype)   %in% tolower(type)   ), ]

if(!is.null(exchange) ) {returned_results <- returned_results[which(tolower(returned_results$exchange) %in% tolower(exchange)), ]}

return(construct_financial_df( returned_results) )

 }


#' Search Financial Asset From a Keyword (Single Text)
#'
#' Searches for financial data based on a free-text texts and retrieve asset symbol(s), name(s), exchange, and asset type.
#'
#' @param texts `character` string representing the search texts. This can be a company name, index, or financial term. Default is "Dow Jones".
#' @param .verbose `logical` If `TRUE`, print additional details about the search process. Default is `TRUE`.
#' @param region A character string specifying the region for the search (e.g., "US", "EU"). Default is `NULL`, meaning no region filter is applied.
#' @param lang A character string specifying the language of the data returned. Default is "en" for English.
#'
#' @return A `data.frame` with assets symbols and names.
#' \itemize{
#'   \item \code{symbol}: The financial symbol (e.g., stock ticker or index).
#'   \item \code{name}: The full name of the financial entity (e.g., 'Dow Jones Industrial Average').
#'   \item \code{exch}: The exchange on which the symbol is listed (e.g., 'DJI', 'CBT').
#'   \item \code{type}: The type of the financial instrument (e.g., I for Index, F for Futures, E for Exchange Traded Fund).
#'   \item \code{exchdisp}: The exchange name displayed (e.g., 'Dow Jones').
#'   \item \code{typedisp}: A long name for the type of financial instrument (e.g., 'Index', 'Futures' or 'ETF' for 'Exchange Traded Fund').
#' }
#'
#' @examples
#' \dontrun{
#' # Example of searching for financial data related to "Dow Jones"
#' results <- search_asset_quick(texts = "Dow Jones")
#' }
#' @export
search_asset_quick <- function(texts =  "Dow Jones", .verbose = TRUE, region =NULL, lang = "en"){
   if(length(texts) == 0) return(NULL)
   if(!is.character(texts)) return(NA)

  if(!internet_or_not()) return(NA)

texts <- texts[!is.na(texts)]

  if(!is.null(region)) region <- paste0("&region=", region) # e.g., US
  if(!is.null(lang)) lang <- paste0("&lang=", lang) # 'en'
  suffixx = paste0(region, lang)

results <- lapply(texts, FUN = function(text){

      url <- retrieve_yahoo_api_chart_url(suffix = paste0( "/v6/finance/autocomplete?&query=", text, suffixx) )

  stocks <- fetch_yahoo(url, .verbose = .verbose)

  data <- stocks[[1]]$Result

  data <- standardize_df_cols(data)

  data$searched <- text

  return(data)
  })

data <- do.call(rbind, results)

return(construct_financial_df(data) )
}


###### 2) Scrap Yahoo Finance ######

#' Get Latest Financial Information and Ticker Symbol From Company Name(s)
#'
#' Get latest overall insights and ticker symbols associated with free texts, such as companies texts.
#' Several ticker symbols associated with various exchanges places could be returned, with
#' , companies texts, last price on the marketplace,
#' sector/category (if available), etc.
#'
#' @param texts A character string representing the company name to search for.
#' @param exchange (optionnal) A character string representing the exchange place(s) to consider (exact match). Default keep all the exchange places.
#' @param sector (optionnal)  A character string representing the sector(s) to consider (exact match). Default keep all results.
#' @return A data frame with columns:
#'
#' \describe{
#'   \item{symbol}{`character` - The ticker symbol associated with an asset, e.g., "VTI", "^DWCPF".}
#'   \item{name}{`character` - Name of the asset, e.g., ETF or index name.}
#'   \item{last_price}{`numeric` - The last price of the asset.}
#'   \item{sector}{`character` - The sector or industry category if available, e.g., 'Industrials', 'Consumer Cyclical'.}
#'   \item{type}{`character` - The type of asset (certainly "stocks").}
#'   \item{exchange}{`character` - The stock exchange place for this asset, e.g., 'PAR' is Paris (FR) exchange place.}
#'   \item{searched}{`character` - The text searched on Yahoo, e.g., "Dow Jones".}
#'  }
#' @examples
#' oil <- search_summary(texts = c("Dow Jones", "Euronext"))
#' #Get data on marketplace(s)
#' cars <- search_summary(texts = c("RENAULT", "VOLVO"),  exchange = c("STO", "PAR"))
#' @seealso For more details see the help vignette:
#' \code{vignette("get_info_and_historic", package = "financr")}
#' @inherit construct_financial_df details
#' @references Source : search on https://finance.yahoo.com/lookup/
#' @export
search_summary <- function(texts, exchange = NULL, sector = NULL) {

  if(!internet_or_not()) return(NA)

  # loop over the texts#
  results <- lapply(texts, function(name) {

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

  results <- standardize_df_cols(df = results)

  colnames(results)[grep("sector", colnames(results) )] <- "sector"

  if(!is.null(sector)) results <- results[which(results$sector %in% sector), ]

  # filter exchange
  if(!is.null(exchange) ) {results <- results[which(results$exchange %in% exchange), ]}

  return(construct_financial_df(unique(results)))
}



