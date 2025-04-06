#' Get Latest Exchange Rates For Devises
#'
#' Returns a `data.frame` with the latest exchange rate(s) for the given currencies. Default will convert to USD ($).
#'
#' @param from, default = `NULL` A character string representing the base currency (e.g., "USD").
#'  The user must provide `from` values with one of the following method :
#'  - passing a paired character list, e.g., c("EUR" = "USD", "RON" = "EUR") ;
#'  - or passing one or several `from` values :
#'    - associated with a single `to` value, e.g., `from = c('EUR', "RON"), to = "USD"`
#'    - or associated with a list of `from` values of the same length, e.g., `from = c('EUR', "RON"), to = c("USD", "EUR")` .
#' @param to, default = `"USD"` A character string representing the target currencies, e.g., `c("EUR", "USD")`.
#' @param .verbose `logical` If TRUE, messages are displayed, e.g., when invalid symbols are detected. Default is FALSE.
#' @param ...  Other parameters passed to get_a_change - internal mecanism for get_changes_historic
#' @return The returned dataframe contains daily exchange rates, and the following columns:
#' \describe{
#'   \item{currency}{`character` - The base currency.}
#'   \item{symbol}{`character` - The Yahoo Finance symbol (e.g., "EURUSD=X").}
#'   \item{exchangename}{`character` - The exchange place name, i.e. 'CCY' for currencies.}
#'   \item{intrumenttype}{`character` - The type of financial instrument, supposed to be 'CURRENCY'.}
#'   \item{firsttradedate}{`POSIXct` - The oldest date available on the Yahoo Finance API for an exchange rates historic.}
#'   \item{gmtoffset}{`numeric` - The difference with GMT time (seconds).}
#'   \item{timezone}{`character` - The market's timezone.}
#'   \item{exchangetimezonename}{`character` - The name of the market's timezone, e.g., 'Europe/London'.}
#'   \item{regularmarketprice}{`numeric` - The latest market price.}
#'   \item{regularmarketdayhigh}{`numeric` - The market highest price of this day.}
#'   \item{regularmarketdaylow}{`numeric` - The market lowest price of this day.}
#'   \item{fiftytwoweekhigh}{`numeric` - The highest price in the last 52 weeks.}
#'   \item{fiftytwoweeklow}{`numeric` - The lowest price in the last 52 weeks.}
#'   \item{previousclose}{`numeric` - The last closing price.}
#'   \item{regular_timezone}{`character` - The regular market's timezone.}
#'   \item{from}{`character` - The currency converted into another, e.g., if the `from` value is 1$ ('USD'), you want to receive a certain amount of the other currency to reach 1$.}
#'   \item{to}{`character` - The currency that you want to convert into : **all the `numeric` values (not `integer`) of the row are expressed with this currency**.}
#'   \item{timestamp}{`POSIXct` - The corresponding date (YYYY-MM-DD).}
#' }
#' @inherit construct_financial_df details
#' @references Source : https://query2.finance.yahoo.com/v8/finance/chart/
#' @seealso For more details see the help vignette:
#' \code{vignette("get_changes", package = "financr"))}
#' @examples
#' # Latest exchange rates from € and ¥ to $ (default convert to 'USD")
#' df <- get_changes(from = c("EUR", "JPY"))
#' str(df)
#' # User could pass a named list of character
#' df2 <- get_changes(from = c("EUR" = "RON", "USD" = "EUR"))
#' # Or pass paired values as 2 list (equivalent to hereabove line) :
#' same_as_df2 <- get_changes(from = c("EUR", "USD"), to =c("RON" , "EUR"))
#' @export
get_changes <- function(from = NULL, to = "USD", .verbose = T, ...){

# User have to indicate currencies to get_changes()
if(any(is.na(c(from, to)))) return(NA)

if(is.null(from)) return(NULL)
if(is.null(to)) to = "USD"

if(!internet_or_not()) return(NA)

if(length(names(from)) > 0){to <- as.character(from) ; from <- names(from) }

if(length(to) == 0 | length(from) == 0) return(NULL)

# User have to pass a list of equal lenght or only one element
if(all(length(from) != length(to), length(from) > 1, length(to) > 1) ) {return(NA)}
# here we have maybe a list of equal length, or only one value to translate for other

  # check for invalid currencies symbol :
  symbs.valids <- valid_symbol(from, to,  .verbose  =  .verbose )
  if(!all(symbs.valids)) {
    filter_out <- symbs.valids[, !as.logical(symbs.valids)]
    from <- from[!from %in% filter_out]
    to <- to[!to %in% filter_out]
    }

# if there is a fake symbol => maybe we should answer NA ?

  # Thus results are guaranteed and filtering out of invalid symbols is unnecessary
 # get exchanges rates from the yahoo API url
  url =  retrieve_yahoo_api_chart_url()
  url = paste0(url, from, to, '=X')
# multiply url according to paste() behavior

# if null interval and null range : will return latest values
changes <- lapply(url, get_a_change,  .verbose = .verbose, ...)

changes <- do.call(rbind, changes)

if(all(sapply(changes, is.na) )) return(NA)

changes <- unique(changes)
# erase the junks col' that yahoo chart give us (need yahoo-account management)
if("volume" %in% colnames(changes)) changes$volume <- NULL

changes <- standardize_df_posixct_for_big_number(changes)
#convert columns : Replace all values unix by posixct

changes <- remove_na_rows(changes, na_limit = ncol(changes) - 1) # timestamp, from & to are always here

return(construct_financial_df(changes))

}

# non - vectorized func for a couple
#url = "https://query2.finance.yahoo.com/v8/finance/chart/FJDUSD=X"
get_a_change <- function(url, range = NULL, interval = NULL, .verbose = F){

# other columns, e.g., "fullexchangename"  ,
col_2_return = c("currency" ,"symbol" , "exchangename",  "instrumenttype" ,  "firsttradedate"
, "gmtoffset"     ,       "timezone"  ,       "exchangetimezonename"
,"regularmarketprice" ,"regularmarketdayhigh"  ,"regularmarketdaylow"
,  "fiftytwoweekhigh"  , "fiftytwoweeklow",  "previousclose"
,  "regular_timezone"  , "from", "to", "timestamp"
                    )

suffix = ""
  # add special keyword to each of the url :
 if(any(!is.null(range), !is.null(interval))) suffix = "?"
  # add optionnal special keywords (used by get_changes_historic) :
  if(!is.null(interval)) suffix = paste0(suffix, "&interval=", interval)
  if(!is.null(range)) suffix = paste0(suffix, "&range=", range)

  url = paste0(url, suffix)
  # get values
  currencies <-  fetch_yahoo( url, .verbose = .verbose )[[1]]

  if(length(currencies) == 1 ) if(is.na(currencies)) return(NA)

# extrat financial symbol from the url :
symbs_reconstitued <- basename(url)
# official devise symbols always have 3 letters
# 2 first letters are country code ISO 3166-1 alpha-2.
deduced_from <- substr(symbs_reconstitued, 1,3)
deduced_to <- substr(symbs_reconstitued, 4,6)

# 2 possib. of exploration : historic or latest

#we have results. Extract main info :
main <- data.frame(currencies$result)
# this is an hybrid object : df with list that contain only a df
global_changes <- extract_changes_meta_list_of_tables(main$meta)

global_changes$from <- deduced_from
global_changes$currency <- deduced_to
global_changes$to <- deduced_to

# here varnames are hardcoded :
# if there is no 'timestamp' var we try regularmarkettime
colns <- colnames(global_changes)
if(!"timestamp" %in% colns){
  if("regularmarkettime" %in% colns) {
    global_changes$timestamp <- global_changes$regularmarkettime
  global_changes$regularmarkettime <- NULL}
}

global_changes <- standardize_df_cols(global_changes)
global_changes <- add_missing_var_to_df(global_changes, col_2_return)
global_changes <- global_changes[, col_2_return ]
# global_changes$date <- as.POSIXct(global_changes$timestamp)

# if no interval indicated :
if(  all(is.null(interval), is.null(range)) ) return(global_changes)

# if no timestamp entry : no historic is available for this currency
if(!'timestamp' %in% names(main)) return(NA)

# if not we have to pursue :
historic <- unlist_df_with_list_of_leng1(main$indicators$quote[[1]]
            , df_to_add = data.frame(timestamp = main$timestamp[[1]]) )

# a 'timestamp' column is created above, herafter we convert it to posixct
# (maintain names with the other case)
  # create our from and to var
  historic$from <- deduced_from
  historic$to <- deduced_to
 #return historical tables
  return( historic  )

}

# get the latest insights : dataframe with list of one dataframe inside too
extract_changes_meta_list_of_tables <- function(table){

  lengs <- sapply(table,  FUN = function(cell) length(cell))
  listt <- sapply(table, is.list)
# construct a df with normal data.frame columns
  global_changes <- data.frame(table[lengs == 1 & !listt])

  # construct a df to add with list values :
  meta_tables <- table[lengs > 1][[1]] #1st object with length > 1
  # it's supposed to be several df with values (timestamp)
  # made a proper list of dataframe and tweaking colnames :
  dataframe_meta <- lapply(names(meta_tables), FUN = function(name){
    tble <-  as.data.frame(meta_tables[[name]])
    colnames(tble) <- paste0(name, "_", colnames(tble))
    tble
  }
  )
  # we are maybe extracting some useless subtables here
  dataframe_meta <- do.call(cbind,dataframe_meta)

  #add our metainformation, whatever they are
  global_changes <- cbind(global_changes, dataframe_meta)

 global_changes <- standardize_df_cols(global_changes)

  return(global_changes)

}

unlist_df_with_list_of_leng1 <- function(df, df_to_add = NULL){
  # Q1-2025: extract from 'indicators' a data.frame of 1 obs and one value
  # with 'quote' list of 1 value=> a data.frame
  #extract time.series info : a naimed list of values
  complete_df <- data.frame(do.call(cbind, lapply(df, unlist)))

  if(!is.null(df_to_add))  { complete_df <- data.frame(df_to_add,  complete_df) }

  return(complete_df)

}
