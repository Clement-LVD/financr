
test_that("get_indices data returns a valid data.frame", {
  skip_on_cran()
  result <- get_indices()

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # verify col
  expected_cols <- c( "symbol", "name"    ,  "price"  ,  "change", "change_percent",     "volume", "currency")
  expect_true(all(expected_cols %in% colnames(result)))
  expect_true(nrow(result) > 20)
})

test_that("get_indices filter according to keep parameter", {
  skip_on_cran()
  symbol ="^DJI"
test <- get_indices( keep = symbol)

expect_true(nrow(test) == 1)
expect_true(test$symbol==symbol)
expect_true(  is.numeric(test$price))

})


test_that("get_indices respect .verbose parameter", {
  skip_on_cran()
  expect_silent(get_indices( .verbose = FALSE))

  })


