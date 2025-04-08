
test_that("last_currencies data returns a valid data.frame", {
  if(!internet_or_not()) skip()
  result <- last_currencies()

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # verify col
  expected_cols <- c( "shortname"  ,   "longname"     , "symbol"      ,  "locallongname")
  expect_true(all(expected_cols %in% colnames(result)))
  expect_true(nrow(result) > 20)
})

test_that("last_currencies filter according to keep parameter", {
  if(!internet_or_not()) skip()
  symbol ="PLN"
test <- last_currencies( keep = symbol)

expect_true(nrow(test) == 1)
expect_true(test$symbol==symbol)
expect_true(  is.character(test$longname))

})


test_that("last_currencies add usd values", {
  if(!internet_or_not()) skip()
  symbol ="PLN"
  test <- last_currencies( keep = symbol, get_changes = T)

  expect_true(nrow(test) == 1)
  expect_true(test$symbol==symbol)
  expect_true(  is.character(test$longname))
  expect_equal( test$to, "USD")

  expect_true( is.numeric(test$regularmarketprice ))

})


