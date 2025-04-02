
#### 1) standardize data.frame colnames ####
standardize_df_cols <- function(df, sep = "_"){
  if(length(df) == 0) return(df)

  colnames(df) <- trimws(colnames(df))

  df[, which(nchar( colnames(df)) == 0)] <- NULL

  original_col <- colnames(df)
  # harmonize colnames :
  colnames(df) <- tolower( original_col)
   colnames(df) <- gsub(" +", " ", colnames(df))


  # eject col without char :
  n.char.col <- apply(df, 2, FUN = function(col) sum(nchar(col)) )
  n.char.col <- names(n.char.col)[n.char.col == 0]

if(length(n.char.col) > 0) {
  if(!all(is.na(n.char.col))) df[, n.char.col] <- NULL}

  colnames(df) <- gsub("\\(|\\)", "", colnames(df))
  # todo convert cells values
  colnames(df) <- gsub(" ",sep, colnames(df))
  return(df)
}

### 2) convert cols with "%" symbol or "-" / "--" NA writing style ####
standardize_df_percent_col <- function(df, regex_to_replace_by_na  = "^--?$" , pattern_to_erase = "%|," ){

 colnames(df) <- gsub("%", "percent", colnames(df))

  df2 <-  data.frame(
    lapply( df , FUN = function(col){
    if(!is.character(col)) return(col)
   col <- gsub(regex_to_replace_by_na, NA, col)
   col <-  gsub( x = col, pattern = pattern_to_erase, replacement = "") # erase '%' from col'
     return(   col   )
  }))
# we next search for var to convert to num
 have_no_char <- lapply(df2, FUN = function(col) all(!grepl(x = col, pattern = "[A-z]")))
 have_num <- lapply(df2, FUN = function(col) {
   all(!grepl(x = col, pattern = "\\(|\\)"), # without '(' in the content

   grepl(x = col, pattern = "[0-9]") #and a number
   )

   })

 eligible_vars <- which(unlist(have_no_char) & unlist(have_num))

 if(length(eligible_vars) > 0) df2[eligible_vars] <-  lapply(df2[eligible_vars], function(col) {
   as.numeric(as.character(col))
 })


  return(df2)

}

standardize_df_cols_to_numeric <- function(df){

# 1) search for col : with no char instead of our abbreviations (T, B, M, K at the end of the line)
  have_no_char <- sapply(df, function(col) {
    if(is.numeric(col)) return(NA) #not the already numeric col
    col <- trimws(col)
    all(any(!grepl("\\(|\\)", col, perl = TRUE)), #DON'T HAVE '(' or ')'
    any(!grepl("[A-Za-z]{2}(?!(?<=[0-9])(T|B|M|K)$)", col, perl = TRUE))
    # and have text but not our abbreviations or '-' in our count
 ) })

have_no_char <- which(have_no_char)
# if there is results : col' without char but abbreviation are treated and returned as numeric
if(length(have_no_char) == 0) return(df)

  df[have_no_char] <- lapply(df[, have_no_char], standardize_df_convert_abbr_to_numeric)

  return(df)
}

##### 3) convert billion (B), "Million (M), etc. #####
standardize_df_convert_abbr_to_numeric <- function(x) {

  # x is a vector of caracters
  if (!is.character(x)) {return(x)}

  caracter_regex <- "[0-9]+(T|B|M|K)$"

  x <- gsub(pattern = ",|^-+$", "", x)
  # treatment of each value
  convert_value <- function(val) {
    if(!grepl(caracter_regex, val)) return(val)

    if( val  %in% c("-","--") | is.na(val) ) return(NA)

    if (grepl("T$", val)) {
      return(as.numeric(sub("T$", "", val)) * 1e12)  # Trillion
    }
    if (grepl("B$", val)) {
      return(as.numeric(sub("B$", "", val)) * 1e9)  # Billion
    }

    if (grepl("M$", val)) {
      return(as.numeric(sub("M$", "", val)) * 1e6)  # Million
    }

    if (grepl("K$", val)) {
      return(as.numeric(sub("K$", "", val)) * 1e3)  # Thousand
    }

    return(as.numeric(val) )  }

  # numeric return
  returned <- as.numeric(sapply(USE.NAMES = F, x, convert_value))
  return(returned)
}

