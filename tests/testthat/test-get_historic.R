# Load testthat and your package

test_that("get_historic returns a valid data.frame", {
   if(!internet_or_not()) skip()

  symbols <- c("VOLCAR-B.ST", "SAAB-B.ST")
  result <- get_historic(symbols)

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # verify col
  expected_cols <- c("low", "high", "close", "open", "volume",
                     "timestamp", "date", "currency", "symbol", "shortname",
                     "exchangename", "fullexchangename", "timezone")
  expect_true(all(expected_cols %in% colnames(result)))
})

test_that("get_historic handles empty symbols input", {
   if(!internet_or_not()) skip()

  result <- get_historic(symbols = character(0))

  # empty results if empty symbol
  expect_true(is.null(result))
})

test_that("get_historic handles non-existent symbols", {
   if(!internet_or_not()) skip()

  result <- get_historic(symbols = c("INVALID-SYMBOL"))

  # invalid symbol = NA and a warning
  expect_true(is.na(result)|| is.null(result))
})

test_that("get_historic respects .verbose parameter", {
   if(!internet_or_not()) skip()

  expect_silent(get_historic(symbols = c("SAAB-B.ST"), .verbose = FALSE))
})

