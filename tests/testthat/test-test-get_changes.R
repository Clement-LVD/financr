# get_changes tests

test_that("get_changes returns a valid data.frame", {
  if(!internet_or_not()) skip()
  from <- c("EUR", "RON")
  result <- get_changes(from = from)


  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # Vérification des colonnes attendues
  expected_cols <- c("currency", "from"  , "to"   ,        "timestamp",
                     "regularmarketprice", "symbol", "shortname",
                     "exchangename", "fullexchangename", "regular_timezone")
  expect_true(all(expected_cols %in% colnames(result)))

  expect_equal(unique(result$to), "USD") # defaut convert to usd
})

test_that("get_changes handles custom 'to' conversion (and empty symbols input)", {
  if(!internet_or_not()) skip()

  result <- get_changes(from = c("USD", character(0)), to = "EUR")

  # empty results if empty symbol + 1 result
  expect_true(nrow(result) == 1)

 expect_true(unique(result$to) == "EUR")
 expect_true(unique(result$from) == "USD")

  })


test_that("get_changes handles custom from list of paired char", {
  if(!internet_or_not()) skip()

  result <- get_changes(from = c("USD" = "EUR", "RON" = "EUR"))

  # empty results if empty symbol + 1 result
  expect_true(nrow(result) == 2)

  expect_true(all(unique(result$from) %in% c("USD" , "RON") ))
  expect_true(unique(result$to) == "EUR")

})


test_that("get_changes handles empty symbols input", {

  result <- get_changes(from = character(0))

  # empty results if empty symbol
  expect_true(is.null(result))


  result <- get_changes(from = NULL)

  # empty results if empty symbol
  expect_true(is.null(result))
})

test_that("get_changes handles non-existent symbols", {
  # skip_on_cran()
  if(!internet_or_not()) skip()

  result <- get_changes(from = c("INVALID-SYMBOL"))

  # invalid symbol = NA and a warning
  expect_true(is.na(result)|| is.null(result))
})

test_that("get_changes respects .verbose parameter", {
  if(!internet_or_not()) skip()

  expect_silent(get_changes(from = c("eerrorr"), .verbose = FALSE))

})

