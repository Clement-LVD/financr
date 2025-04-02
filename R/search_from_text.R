#' Get Latest Financial Information and Ticker Symbol From Company Name(s)
#'
#' Get latest overall insights and ticker symbols associated with free texts, such as companies names.
#' Several ticker symbols associated with various exchanges places could be returned, with
#' , companies names, last price on the marketplace,
#' sector/category (if available), etc.
#'
#' @param texts `character` A character string or a list of character representing the text(s) to search for, e.g., company names.
#' @param quotetype (optionnal) A character string representing the type of entry to search for, e.g., a stock market ('ETF', 'EQUITY' or 'MUTUALFUND') or a major indice ('INDEX').
#' @param exchange (optionnal)  A character string representing the exchange place(s) to consider - exact match, e.g., 'STO' (Stockholm stock exchange). Default keep all results.
#' @param .verbose `logical`, default = `FALSE` If TRUE, messages are displayed, e.g., when invalid symbols are detected.
#' @return A data frame with the following columns:
#'   \item{symbol}{`numeric` - The ticker symbol associated with an entry.}
#'   \item{exchange}{`character` - .}
#'   \item{shortname}{`character` - .}
#'   \item{quotetype}{`numeric` - .}
#'   \item{index}{`character` - .}
#'   \item{score}{`numeric` - .}
#'   \item{typedisp}{`character` - .}
#'   \item{longname}{`character` - .}
#'   \item{exchdisp}{`character` - .}
#'   \item{isyahoofinance}{`character` - .}
#'   \item{searched}{`character` - .}
#' @examples
#' oil <- search_from_text(texts = c("TOTAL", "SHELL", "BP"),  quotetype = "EQUITY")
#' #Get data on marketplace(s)
#' swedish <- search_from_text(c("SAAB", "VOLVO"),  exchange = c("STO", "PAR"))
#' @inherit construct_financial_df details
#' @references Source : https://query2.finance.yahoo.com/v1/
#' @export
search_from_text <- function(texts, .verbose = F, exchange = NULL, quotetype = NULL){
# url = "https://query2.finance.yahoo.com/v1/finance/search?q=saab"
if(length(texts) == 0) return(NULL)
  if(length(texts) == 0) if(is.na(texts)) return(NA)

  if(!internet_or_not()) return(NA)

url = retrieve_yahoo_api_chart_url(suffix ="v1/finance/search?q=" )

urls  = paste0(url, texts)

  results <- lapply(urls, function(urll) {

searched_value <- gsub(pattern = ".*search\\?q\\=", "",x =  urll )

  datas <- fetch_yahoo(urll, .verbose = .verbose)

 main <- datas$quotes

 if(length(main) == 0) return(NULL)

# news <- datas$news

main <- standardize_df_cols(df = main)

cols_to_keep <- c("exchange", "shortname" , "quotetype", "symbol",  "index"
                  , "score", "typedisp", "longname", "exchdisp", "isyahoofinance", "searched")

main <- main[, colnames(main) %in% cols_to_keep]

main <- add_missing_var_to_df(main, cols_to_keep)

main$searched <- searched_value

return(main)
}
)


if(length(results) == 0) return(results)

returned_results <- do.call(rbind, results)


if(!is.null(quotetype   )) returned_results <- returned_results[which(tolower(returned_results$quotetype)   %in% tolower(quotetype)   ), ]

# filter exchange
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
