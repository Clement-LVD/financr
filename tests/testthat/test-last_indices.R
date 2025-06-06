
test_that("last_indices data returns a valid data.frame", {
   if(!internet_or_not()) skip()

  result <- last_indices()

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # verify col
  expected_cols <- c( "symbol", "name"    ,  "price"  ,  "change", "change_percent",     "volume", "currency")
  expect_true(all(expected_cols %in% colnames(result)))
  expect_true(nrow(result) > 20)
})

test_that("last_indices filter according to keep parameter", {
   if(!internet_or_not()) skip()

  symbol ="^DJI"
test <- last_indices( keep = symbol)

expect_true(nrow(test) == 1)
expect_true(test$symbol==symbol)
expect_true(  is.numeric(test$price))

})


test_that("last_indices respect .verbose parameter", {

  expect_silent(last_indices( .verbose = FALSE))

  })


