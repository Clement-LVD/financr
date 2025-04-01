test_that("retrieve_yahoo_api_chart_url answer text", {

   text_results <- retrieve_yahoo_api_chart_url()
expect_length(text_results, 1)
expect_type(text_results, "character")
expect_true(grepl("https.*yahoo", text_results))
})

# 2nd fn of utils

test_that("add_missing_var_to_df adds missing variables", {
  df <- data.frame(a = 1:3, b = 4:6)
  vars <- c("a", "b", "c", "d")
  df_new <- add_missing_var_to_df(df, vars)

  expect_true(all(vars %in% colnames(df_new)))  #all var ar present
  expect_true(all(is.na(df_new$c)))  # new col have NA
  expect_true(all(is.na(df_new$d)))
})

test_that("add_missing_var_to_df does not modify existing columns", {
  df <- data.frame(a = 1:3, b = 4:6)
  vars <- c("a", "b")
  df_new <- add_missing_var_to_df(df, vars)

  expect_identical(df, df_new)
})

test_that("add_missing_var_to_df handles empty input", {
   vars <- c("x", "y")
# test 1 : null element
   df_new <- add_missing_var_to_df(NULL, vars)
expect_null(df_new)
# test 2
  df <- data.frame(x = character(0L), y = character(0L))
  df_new <- add_missing_var_to_df(df, vars)

  expect_equal(colnames(df_new), vars)  # Vérifie que les colonnes sont bien créées
  expect_true(all(is.na(df_new$x)))
  expect_true(all(is.na(df_new$y)))
})

### Test 3

test_that("remove_na_rows work correctly", {

  df2 <- data.frame(a = c(1, 2, NA), b = c(NA, 5, 6))
  df_filtered <- remove_na_rows(df2)

  expect_equal(nrow(df_filtered), 3)  # verify that there is all the line

  df3 <- data.frame(a = c(NA, 2, NA), b = c(NA, 5, 6))
  df_filtered <- remove_na_rows(df3)

  expect_equal(nrow(df_filtered), 2)  # verify that there is all the line
   expect_true(!any(is.na(df_filtered$a) & is.na(df_filtered$b)))
  # Check if valid data are here (2 & 5)

   df_filtered <- remove_na_rows(df3, na_limit = 1)
   expect_equal(nrow(df_filtered), 1)  # verify that there is all the line
   expect_equal(as.numeric(df_filtered), c(2,5))
})

   test_that("remove_na_rows deal with empty and anormal values", {
   # check empty df management
  df_empty <- remove_na_rows(data.frame(a = c(NA, NA), b = c(NA, NA)))
  expect_equal(nrow(df_empty), 0)

  # check formel character 0
   test <- remove_na_rows(data.frame(a = character(0)))
  expect_equal( nrow(test) , 0)

  test <- remove_na_rows(character(0))
expect_equal(test, character(0))
test <- remove_na_rows(NA)
expect_equal(test, NA)

})

# extract before sep test
   test_that("extract_before_sep work correctly (base case)", {

     vector <- c("100-50", "200+30", "300.00(", "400")
     extracted <- extract_before_sep(vector)
# default extract before a '-' , a '+' or a .00(
     expect_equal(extracted, c(100, 200, 300, 400))  # Vérifie que les nombres sont bien extraits et convertis

     })

   test_that("extract_before_sep works correctly", {

     # Cas par défaut : extraction avant '-' , '+' ou '.00('
     vector1 <- c("100-50", "200+30", "300.00(", "400",  "104.01-0.03(-0.03%)")
     extracted1 <- extract_before_sep(vector1)
     expect_equal(extracted1, c(100, 200, 300, 400, 104.01))

     # Cas sans séparateur : la valeur entière doit être renvoyée
     vector2 <- c("123", "456", "37,120.33-679.67(-1.80%)")
     extracted2 <- extract_before_sep(vector2)
     expect_equal(extracted2, c(123, 456,  37120.33))

     # Cas avec un séparateur présent plusieurs fois dans la chaîne :
     # seule la première occurrence du séparateur est prise en compte
     vector3 <- c("500-200-100", "600+400+200", "62.91-0.13(-0.21%)"   )
     extracted3 <- extract_before_sep(vector3)
     expect_equal(extracted3, c(500, 600, 62.91))

     # Cas avec une chaîne vide et des NA
     vector4 <- c("300.00(", "", NA, "400-", "53,172.97-304.73(-0.57%)")
     extracted4 <- extract_before_sep(vector4)
     # Pour "" et NA, la conversion renvoie généralement NA
     expect_equal(extracted4, c(300, NA, NA, 400, 53172.97))

     # Cas avec un paramètre char_to_sup personnalisé (ici on supprime le symbole '$')
     vector5 <- c("100$-50", "200$+30", "24,759.15-401.95(-1.60%)")
     extracted5 <- extract_before_sep(vector5, char_to_sup = ",|\\$")
     expect_equal(extracted5, c(100, 200, 24759.15))
     # default suppress ',' : without it will   fail to extract a numeric char. and warn us
     expect_warning(extract_before_sep(vector5, char_to_sup = "\\$"))
   })
