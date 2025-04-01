# url of yahoo api is from here. Default is V8 API
retrieve_yahoo_api_chart_url <- function(suffix = "v8/finance/chart/"){return(paste0("https://query1.finance.yahoo.com/", suffix) )}


#  add a var full of na, given a list of vars that are supposed to be present
add_missing_var_to_df <- function(df, vars, .verbose = T){
if(length(df) == 0) return(df)
  if(nrow(df) == 0) return(df)
  col_to_retain <- vars
  # add fake col
  missing_col <- setdiff(col_to_retain, colnames(df) )
  if(length(missing_col) > 0){

    df[ , missing_col] <- NA
  }
  return(df)
}



# Filter out junk observations : columns full of na
remove_na_rows <- function(df, na_limit = ncol(df)) {
  if(!is.data.frame(df)) return(df)
  # Verify df is not empty
  if (nrow(df) == 0) return(df)

  if(na_limit < 1) na_limit =1

  # Count NA per row
  na_counts <- rowSums(is.na(df))

  # Keep only rows where NA count is below the limit
  return(df[na_counts < na_limit, , drop = FALSE])
}

#### 0) extract from yahoo tables ####
# sometimes we scrap yahoo table and one value is inside another values
extract_before_sep <- function(vector
                               , char_to_sup = ","
                               ,sep = "-|\\+|\\.00\\("
 # value before a -, a + or a .00( will be extracted
){

  first_element <- sub( paste0("(", sep , ").*"),  "", vector)
  # typically : "(-|\\+|\\.00\\().*"
  first_element <- as.numeric(gsub(char_to_sup, "", first_element))
  return(first_element)
}


##### 2) connect to yahoo ####
# check if the user have internet
internet_or_not <- function(url_to_ping = "https://www.google.com", timeout = 2) {
  old_timeout <- getOption("timeout")

  options(timeout = timeout)
  on.exit(options(timeout = old_timeout))

test <-  tryCatch({
    con <- url(url_to_ping, open = "r")
     close(con)
    return(TRUE)

  }, error = function(e) {
    # error (after 2 seconds of timeout)

    FALSE

  }, warning = function(w){
    # warning is "no access to google.fr"

    FALSE
  }

  ) #end trycatch
if(!test) warning("No Internet connection. Please check your network")

return(test)
}

