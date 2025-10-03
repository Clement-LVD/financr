
test_that("standardize_df_cols works", {

  df <-data.frame(check.names = F, fix.empty.names = F,
                  DoG1 = "pitbull"
                  , `Dog   2` = "rat terrier"
                  , ` D o g 3 ` = 'corgy'
                  , `  ` = "bastard")


  results <- standardize_df_cols(df)

  testthat::expect_s3_class(results, "data.frame")

  testthat::expect_equal(colnames(results), c("dog1", "dog_2", "d_o_g_3", "var1"))

  # deal with 0L char.
  results <- standardize_df_cols(character(0L))

  testthat::expect_equal(results, character(0L))

})

test_that("standardize_df_percent_col works", {

  # proper handle of mistake
  results <- standardize_df_percent_col(NULL)


  df <-data.frame(check.names = F, fix.empty.names = F,
                  d = "58.2%"
                  , `D2%` = "12.4%"
                  , `D3%` = '8,000%'
                  , `%` = "10.500%")


  results <- standardize_df_percent_col(df)

  testthat::expect_s3_class(results, "data.frame")

  testthat::expect_equal(colnames(results), c( "d"  , "D2percent", "D3percent", "percent"))
  testthat::expect_equal(nrow(results), 1)

  testthat::expect_equal(results, data.frame(d = 58.2, D2percent = 12.4, D3percent = 8000, percent = 10.5) )
  # deal with 0L char.
  results <- standardize_df_percent_col(character(0L))

  testthat::expect_equal(results, character(0L))

})



test_that("standardize_df_convert_abbr_to_numeric convert correctly", {

  # Si Internet n'est pas disponible, on saute ce test
  # Tests sur différents types d'entrées
  expect_equal(standardize_df_convert_abbr_to_numeric(c("1T", "2B", "3M", "4K")),
               c(1e12, 2e9, 3e6, 4e3))  # Trillion, Billion, Million, Thousand

  # Test sans abréviation
  expect_equal(standardize_df_convert_abbr_to_numeric(c("123", "456")),
               c(123, 456))  # Valeurs numériques simples

  # Test avec des valeurs contenant des virgules
  expect_equal(standardize_df_convert_abbr_to_numeric(c("1,000K", "2.5B", "3M")),
               c(1e6, 2.5e9, 3e6))  # Test avec virgule et des abréviations

  # Test avec des valeurs invalides ou spéciales
  expect_equal(standardize_df_convert_abbr_to_numeric(c("-","--", NA)),
               as.numeric(c(NA, NA, NA)))  # Valeurs manquantes ou invalides (telles que "--" et "-")

  # invalid entry DON'T raise an error : simply answer text with CONVERTED numbers :)
  expect_silent(standardize_df_convert_abbr_to_numeric(c("1M", "invalid")))

   # invalid entry DON'T raise an error : simply answer text with CONVERTED numbers :)
  skip_on_os("linux")
  expect_equal(standardize_df_convert_abbr_to_numeric(c("2B", "1M", "invalid", "3K")),
               c("2e+09", "1e+06", "invalid", "3000"))

   })

