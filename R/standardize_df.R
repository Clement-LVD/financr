#### Reunite data.frame ####

# filter out elements that don't have a proper lenght
standardize_df_of_dfs <- function(df) {
  n <- nrow(df)

  clean_cols <- list()

  process_column <- function(col) {
    if (is.atomic(col)) {
      if (length(col) == 1) list(rep(col, n))
      else if (length(col) == n) list(col)
      else NULL
    } else if (is.data.frame(col)) {
      if (nrow(col) == n) as.list(col)
      else NULL
    } else {
      NULL
    }
  }

  # Apply to all columns
  cols_processed <- lapply(df, process_column)

  # Flat list of list
  flat_cols <- do.call(c, cols_processed)

  names(flat_cols) <- make.unique(names(flat_cols), sep = "_")

  returned_df <- as.data.frame(flat_cols, stringsAsFactors = FALSE)

  returned_df <- standardize_df_cols(df = returned_df)


  return(returned_df)
}

#### Main function ####

standardize_df_cols <- function(df, sep = "_"){
  if(!is.data.frame(df)) return(df)

if(nrow(df) == 0) return(df)
  # harmonize colnames :
  colnames(df) <- trimws(colnames(df))
  # empty colnames fixing
  empty_names <- which(nchar( colnames(df)) == 0)
  colnames(df)[empty_names] <- paste0("var", seq_along(empty_names))

  df <- drop_col_wo_char(df)

# we need to separate cols according to separator values
# space is the default separator for the hereafter func (assuming it's safe separator)
df <-  standardize_df_split_col_w_several_values(df)

df <- standardize_df_percent_col(df) # if there is a % at the end of the chain

df <- standardize_df_colnames(df, sep = sep) # rename (func' hereafter)


# there is exception such as "name" or "time" columns
# price is in a gangbang of var in the Yahoo.com table : function from utils.R
if("price" %in% colnames(df)) df$price <- extract_before_sep(df$price)
# previously created to much col ?
if("price1" %in% colnames(df) & !"price" %in% colnames(df)) {
  df$price <- df$price1
  df$price1 <- NULL
  df$price2 <- NULL }

# transform values into good old numeric
df <- standardize_df_cols_to_numeric(df)

df <- standardize_timestamp_col(df)

return(df)
}

#### Specific function####
# find column to translate into posixct according to names: use hereafter
standardize_timestamp_col <- function(df){
regexx <- "((d|D)ate|(t|T)ime|(t|T)imestamp)($|_raw$|_fmt$)" #""
col_2_translate <- grepl(regexx, names(df), ignore.case = TRUE, perl = T)
col_2_translate <- names(df)[col_2_translate]

if(length(col_2_translate) > 0){

  col_without_char <- unlist(lapply(df[col_2_translate], FUN = function(col) all(!grepl(pattern = "[A-z]", col))))
  col_2_translate <- col_2_translate[col_without_char]
if(length(col_2_translate) > 0) df[col_2_translate] <- lapply( df[col_2_translate], as.POSIXct)}

return(df)
}

#### 1) standardize data.frame colnames ####
# standardize colnames
standardize_df_colnames <- function(df, sep = "_"){
colnames(df) <- make.names(colnames(df), unique = TRUE)

colnames(df) <- gsub(" +|\\.+", " ", colnames(df))
colnames(df) <- tolower( colnames(df) )
colnames(df) <- gsub("\\(|\\)", "", colnames(df))
colnames(df) <- trimws(colnames(df))

colnames(df) <- gsub(" ",sep, colnames(df))
return(df)
}

# handle 'price' column with a generic extract_before_sep function (utils.R)


# utility func : separate several values
#' Split df cols according to a separator (space the default)
#'
#' @param df `data.frame` of raw values
#' @param separator `character` of safe separator for spliting values
#' @param col_tolerate_separator `character` of regex for colname that DON'T need to be split
#'
standardize_df_split_col_w_several_values <- function(df, separator = "  ?", col_tolerate_separator = "name|symbol|date|time|exch" ){
  # col with separator :
  contain_sep <- vapply(df, FUN = function(col) any(grepl(separator, col)), FUN.VALUE = logical(1))

  colname_with_sep <- colnames( df[, contain_sep] )
# supress col accordingly to a regex
  colname_with_sep <- colname_with_sep[!grepl(pattern = col_tolerate_separator, colname_with_sep, ignore.case = T) ]

   if(length(colname_with_sep) == 0) return(df)

  # herafter we loop on these cols with our separator :
  split_col <- function(x, separator = " ", name = "var") {

    x <- trimws(x)

    # cut values accordingly to the separator
    parts <- strsplit(as.character(x), separator, fixed = FALSE)

    # max
    maxlen <- max(lengths(parts))

    # stack into several col NA for missing
    mat <- do.call(rbind, lapply(parts, function(y) c(y, rep(NA, maxlen - length(y)))))

    # data.frame to return
    out <- as.data.frame(mat, stringsAsFactors = FALSE)
    colnames(out) <- paste0(name, seq_len(maxlen))
    out
  }


  df_without_col <- df[setdiff(names(df), colname_with_sep)]

  splitted_list <- lapply(colname_with_sep, function(col){
    tmp <- split_col(df[[col]], separator = separator, name = col)

    return(tmp)
  } )

  complete_df <- cbind(df_without_col, do.call(cbind, splitted_list))

  return(as.data.frame(complete_df, stringsAsFactors = FALSE) )

}


# drop col without char :
drop_col_wo_char <- function(df){
  if(!is.data.frame(df)) return(df)

n.char.col <- apply(df, 2, FUN = function(col) sum(nchar(keepNA = F, col)) )

if(length(n.char.col== 0) > 0) df[, n.char.col == 0] <- NULL

return(df)
}

### 2) convert cols with "%" symbol or "-" / "--" NA writing style ####
standardize_df_percent_col <- function(df, regex_to_replace_by_na  = "^--?$" , pattern_to_erase = "%|," ){
  if(!is.data.frame(df)) return(df)

 colnames(df) <- gsub("%", "percent", colnames(df))

  df2 <- data.frame(

    lapply( df , FUN = function(col){
      # don't apply on numeric col or col without '%' at each row
    if(!is.character(col)) return(col)
      col <- trimws(col)
    if(!all(grepl("^--?$|\\%$", col))) return(col)
# character col with a percent sign
   col <- gsub(regex_to_replace_by_na, NA, col)

   col <- gsub( x = col, pattern = pattern_to_erase, replacement = "") # erase '%' from col'
     return(   as.numeric(col)   )
  }))

  return(df2)

}

standardize_df_cols_to_numeric <- function(df){
  if(!is.data.frame(df)) return(df)
# 1) search within col and return logical when have no char
have_no_char <- sapply(df, function(col) {
    if(is.numeric(col)  ) return(F) #not the already numeric col

  col <- trimws(col)
    # we supress the last char if its abbr. numeric (e.g., B is billion)
col <- gsub(pattern = "(T|B|M|K)$", "", col)

# return logical values
have_no_parenthesis <- !grepl("\\(|\\)", col, perl = TRUE)
have_character <- grepl("[A-Za-z]", col, perl = TRUE) # na.values are FALSE

logi_text <- all(have_no_parenthesis, !have_character )

return(logi_text)
})

have_no_char <- which(have_no_char)
# if there is results : col' without char but abbreviation are treated and returned as numeric
if(length(have_no_char) == 0) return(df)
if(length(have_no_char) == 1) df[have_no_char] <- standardize_df_convert_abbr_to_numeric(df[have_no_char])
if(length(have_no_char) > 1) df[have_no_char] <- lapply(df[, have_no_char], standardize_df_convert_abbr_to_numeric)

  return(df)
}


# search for var to convert to num
# have_no_char <- lapply(df2, FUN = function(col) all(!grepl(x = col, pattern = "[A-z]")))
#
# have_num <- lapply(df2, FUN = function(col) {
#   all(!grepl(x = col, pattern = "\\(|\\)"), # without '(' in the content
#
#       grepl(x = col, pattern = "[0-9]") #and a number
#   )   })
#
# eligible_vars <- which(unlist(have_no_char) & unlist(have_num))
#
# if(length(eligible_vars) > 0) df2[eligible_vars] <- lapply(df2[eligible_vars] , function(col) {
#   return(as.numeric(as.character(col)) ) })


##### 3) convert billion (B), "Million (M), etc. #####
standardize_df_convert_abbr_to_numeric <- function(x, na_characters = c("-", "--")) {

  # x is a vector of caracters
  if (!is.character(x)) {return(x)}

  caracter_regex <- "[0-9]+(T|B|M|K)?$"

  # suprress begining '+' and the ','
  x <- gsub(pattern = ",|^\\+", "", x)

  x[x %in% na_characters] <- NA
  # treatment of each value
  convert_value <- function(val) {

    if(is.na(val)) return(as.numeric(NA))

    if(!grepl(caracter_regex, val)) return(val)

    if( val  %in% c("-","--") | is.na(val) ) return(val)

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
# here warning are naturally raised by R
  # numeric return
  returned <- sapply(USE.NAMES = F, x, convert_value)
  return(returned)
}

