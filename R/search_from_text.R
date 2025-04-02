#' Get Ticker Symbol From a Text Search
#'
#' Get ticker symbols associated with free texts, such as companies names.
#' Several ticker symbols associated with various exchanges places could be returned, with
#'  companies names, sector/category (if available), etc.
#'
#' @param texts `character` A character string or a list of character representing the text(s) to search for, e.g., company names.
#' @param quotetype (optionnal) A character string representing the type of asset to search for.
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
#'   \item{searched}{`character` - The character searched on the Yahoo API, e.g., "Dow Jones".}
#' }
#' @examples
#' # Get data on all marketplace(s):
#' oil <- search_from_text(texts = c("TOTAL", "DOW JONES", "BP"))
#'
#' # Or get data on specific exchanges places:
#' swedish <- search_from_text(c("VOLVO car", "RENAULT"),  exchange = c("STO", "PAR"))
#' head(swedish)
#' @inherit construct_financial_df details
#' @references Source : https://query2.finance.yahoo.com/v1/
#' @export
search_from_text <- function(texts, .verbose = F, exchange = NULL, quotetype = NULL){
# url = "https://query2.finance.yahoo.com/v1/finance/search?q=saab"

texts <- texts[!is.na(texts)]
if (!is.character(texts)) { return(NA) }
if(length(texts) == 0) return(NULL)

texts <- as.character(unique(texts))

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

if(!is.null(quotetype   )) returned_results <- returned_results[which(tolower(returned_results$quotetype)   %in% tolower(quotetype)   ), ]

if(!is.null(exchange) ) {returned_results <- returned_results[which(tolower(returned_results$exchange) %in% tolower(exchange)), ]}

return(construct_financial_df( returned_results) )
 }
  # optionnal criterius :
  # "quotesCount": self.max_results,
  # "enableFuzzyQuery": self.enable_fuzzy_query,
  # "newsCount": self.news_count,
  # "quotesQueryId": "tss_match_phrase_query",
  # "newsQueryId": "news_cie_vespa",
  # "listsCount": self.lists_count,
  # "enableCb": self.include_cb,
  # "enableNavLinks": self.nav_links,
  # "enableResearchReports": self.enable_research,
  # "enableCulturalAssets": self.enable_cultural_assets,
  # "recommendedCount": self.recommended
