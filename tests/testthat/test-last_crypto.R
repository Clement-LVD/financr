
test_that("last_crypto data returns a valid data.frame", {
  if(!internet_or_not()) skip()

  result <- last_crypto()

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # verify col
  expected_cols <- c( "symbol" ,   "name"  ,   "price"  ,  "change" ,
                      "change_percent" ,    "market_cap" ,"volume"  ,"volume_in_currency_24hr",
                      "total_volume_all_currencies_24hr", "circulating_supply"
                      ,          "x52_wk_change_percent"
                      ,       "from",   "to"      )
  expect_true(all(expected_cols %in% colnames(result)))
  expect_true(nrow(result) > 20)
})

test_that("last_crypto filter according to keep parameter", {
  if(!internet_or_not()) skip()

  symbol ="BTC"
  test <- last_crypto( keep = symbol)

  expect_true(nrow(test) == 1)
  expect_true(test$from==symbol)
  expect_true(  is.character(test$name))

})


