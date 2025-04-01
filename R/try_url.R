# this url  url = "https://finance.yahoo.com/markets/world-indices/"
# is xml::tables with post-treatmend needed
# and this is an api call :
#  url <- 'https://query2.finance.yahoo.com/v6/finance/quote/validate?symbols=AAPL'
#' @importFrom curl curl_fetch_memory
try_url <- function(url, .verbose = T){

  answer <- curl::curl_fetch_memory(url)
  content <- rawToChar(answer$content)

  if(answer$status_code != 200) {
   if(.verbose) message("Navigation error ", answer$status_code, " returned from ",dirname(url), " : \n", gsub(pattern = '.*description":|\\{|\\}', replacement = "",content) )
    return(NA)}

return(content)
}
