# this url  url = "https://finance.yahoo.com/markets/world-indices/"
# is a html table and this is an api call :
# url <- 'https://query2.finance.yahoo.com/v6/finance/quote/validate?symbols=AAPL&format=CSV'
fetch_yahoo <- function(url, .verbose = T){

  response_text <- try_url(url, .verbose =  .verbose   )

  if(is.na(response_text)) return(NA)

  # test for json
  if(grepl("^\\{", response_text)) {
    data <- read_json_content(response_text)
  } else data <- extract_first_html_table(response_text)

  return(data)
}


# yahoo finance API answer json :
#' @importFrom jsonlite fromJSON
read_json_content <- function(content){ jsonlite::fromJSON(paste(content, collapse = "")) }

# but sometimes we want to read html table
#' @importFrom XML readHTMLTable
extract_first_html_table <- function(content){

  tables <-  XML::readHTMLTable(content,  stringsAsFactors = FALSE)

  if(length(tables) == 0) return(NA)

  # Verify results
  if ( length(tables) > 0) {

    tables  <- tables[[1]]  # get first table

  } else {  return(NA) }

  return(tables)

}
