
test_that("get_values returns a valid data.frame", {
  if(!internet_or_not()) skip()

  symbols <- c("VOLCAR-B.ST", "SAAB-B.ST", NA, NULL)
  result <- get_values(symbols)

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")
expect_true(nrow(result) == 2)

# verify col
  expected_cols <- c('currency', 'symbol', 'exchangename', 'fullexchangename', 'instrumenttype', 'firsttradedate', 'regularmarkettime', 'hasprepostmarketdata', 'gmtoffset', 'timezone', 'exchangetimezonename', 'regularmarketprice', 'fiftytwoweekhigh', 'fiftytwoweeklow', 'regularmarketdayhigh', 'regularmarketdaylow', 'regularmarketvolume'
                    # , 'longname'
                    , 'shortname'
                    , 'chartpreviousclose', 'previousclose')
  expect_true(all(expected_cols %in% colnames(result)))

  expect_contains(c("VOLCAR-B.ST", "SAAB-B.ST"  ), result$symbol )

  })

test_that("get_values handles empty symbols input", {

  result <- get_values(symbols = character(0))

  # empty results if empty symbol
  expect_null(result)

  result <- get_values(symbols = NULL)

  # empty results if empty symbol
  expect_null(result)


  result <- get_values(symbols =NA)

  # empty results if empty symbol
  expect_true(is.na(result))

  result <- get_values(symbols = 12)
  expect_true(is.na(result))

})

test_that("get_values handles non-existent symbols", {
  if(!internet_or_not()) skip()

  result <- get_values(symbols = c("INVALID-SYMBOL"))

  # invalid symbol = NA and a warning
  expect_true(is.na(result)|| is.null(result))
})

test_that("get_values respects .verbose parameter", {
  if(!internet_or_not()) skip()

  expect_silent(result <- get_values(symbols = c("SAAB-B.ST", "INVALID-SYMBOOOL"), .verbose = FALSE))
  # result is a good old data.frame
  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) ==1)

  expect_contains("SAAB-B.ST" , result$symbol )

})


# and get_asset_values


test_that("get_asset_value handles empty symbols input", {

  result <- financr:::get_asset_value(character(0))

  # empty results if empty symbol
  expect_null(result)

  result <- financr:::get_asset_value( NULL)

  # empty results if empty symbol
  expect_null(result)


  result <- financr:::get_asset_value(NA)

  # empty results if empty symbol
  expect_null(result)

  result <- financr:::get_asset_value( 12)
  expect_null(result)

})

test_that("get_asset_value handles non-existent symbols", {
  if(!internet_or_not()) skip()

  result <- financr:::get_asset_value("INVALID-SYMBOL")

  # invalid symbol = NA and a warning
  expect_null(result)
})

test_that("get_asset_value respects .verbose parameter", {
  if(!internet_or_not()) skip()

  expect_message(result <- financr:::get_asset_value( "INVALID-SYMBOOOL", .verbose = TRUE))
  expect_silent(result <- financr:::get_asset_value( "INVALID-SYMBOOOL", .verbose = F))

})
