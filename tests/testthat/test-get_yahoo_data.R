
test_that("get_yahoo data returns a valid data.frame", {
  if(!internet_or_not()) skip()

  symbol <- "VOLCAR-B.ST"
  result <- get_yahoo_data(symbol)

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # verify col
  expected_cols <- c("low", "high", "close", "open", "volume",
                     "timestamp", "date", "currency", "symbol", "shortname",
                     "exchangename", "fullexchangename", "timezone")
  expect_true(all(expected_cols %in% colnames(result)))
})

test_that("get_yahoo data handles invalid input", {

  # empty entry => null
  result <- get_yahoo_data(symbol = character(0), .verbose = F)
 # empty results if empty symbol
  expect_true(is.null(result))

  # several symbol = NA
  expect_warning(result <- get_yahoo_data(symbol = c( "AAPL" ,"GOOGL" ) ))
  expect_true(is.na(result))

# invalid ranges :
  expect_message(result <- get_yahoo_data(symbol = "AAPL", range = "invalid" ))

})

test_that("get_yahoo_data handles non-existent symbols", {
  if(!internet_or_not()) skip()

expect_message( result <- get_yahoo_data(symbol = "INVALID-SYMBOL") )

  # invalid symbol = NA and a warning
  expect_true(is.na(result)|| is.null(result))
})

test_that("get_yahoo_data respect .verbose parameter", {
  if(!internet_or_not()) skip()

  expect_silent(get_yahoo_data(symbol = "invalide", .verbose = FALSE))
})


