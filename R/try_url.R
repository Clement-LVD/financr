# this url  url = "https://finance.yahoo.com/markets/world-indices/"
# is xml::tables with post-treatmend needed
# and this is an api call :
#  url <- 'https://query2.finance.yahoo.com/v6/finance/quote/validate?symbols=AAPL'
#' @importFrom curl curl_fetch_memory
#' @importFrom utils URLencode
try_url <- function(url, .verbose = T){
  if(length(url) == 0) return(NULL)
if(!is.character(url) | length(url) > 1) return(NA)
if(is.na(url) ) return(NA)

url <-  utils::URLencode(url)

  safe_curl_fetch <- function(url) {
    tryCatch(
      {
        response <- curl::curl_fetch_memory(url)
        list(success = TRUE, content = rawToChar(response$content), status = response$status_code)
      },
      error = function(e) {
        list(success = FALSE, content = NULL, error_message = conditionMessage(e))
      }
    )
  }


  answer <- safe_curl_fetch(url)

  if(!answer$success) {
    if(.verbose) message("Navigation error : ", answer$error_message, "\n")
    return(NA)
  }

   content <- answer$content

  if(answer$status != 200) {
   if(.verbose) message("Navigation error ", answer$status, " returned from ",dirname(url), " : \n", gsub(pattern = '.*description":|\\{|\\}', replacement = "",content) )
    return(NA)}

return(content)
}
