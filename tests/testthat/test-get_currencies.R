
test_that("get_currencies data returns a valid data.frame", {
  skip_on_cran()
  result <- get_currencies()

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # verify col
  expected_cols <- c( "shortname"  ,   "longname"     , "symbol"      ,  "locallongname")
  expect_true(all(expected_cols %in% colnames(result)))
  expect_true(nrow(result) > 20)
})

test_that("get_currencies filter according to keep parameter", {
  skip_on_cran()
  symbol ="PLN"
test <- get_currencies( keep = symbol)

expect_true(nrow(test) == 1)
expect_true(test$symbol==symbol)
expect_true(  is.character(test$longname))

})


