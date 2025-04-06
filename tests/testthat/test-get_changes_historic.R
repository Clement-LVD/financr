# get_changes tests

test_that("get_changes_historic returns a valid data.frame", {
  if(!internet_or_not()) skip()

  from <- c("EUR", "RON")
  result <- get_changes_historic(from = from)

  # result is a good old data.frame
  expect_s3_class(result, "data.frame")

  # Vérification des colonnes attendues
  expected_cols <- c("timestamp" ,"open"   ,   "high"    ,  "close" ,    "low"    ,   "from"    ,  "to"    )
  expect_true(all(expected_cols %in% colnames(result)))

  expect_equal(unique(result$to), "USD") # defaut convert to usd
})

test_that("get_changes_historic handles custom 'to' conversion (and empty symbols input)", {
  if(!internet_or_not()) skip()

  result <- get_changes_historic(from = c( "USD", character(0)), to = "EUR")

  # empty results if empty symbol + 1 result
  expect_true( unique(result$from) == "USD" )

  expect_true(unique(result$to) == "EUR")


})


test_that("get_changes_historic handles custom from list of paired char", {
  if(!internet_or_not()) skip()

  result <- get_changes_historic(from = c("USD" = "EUR", "RON" = "EUR"))

  expect_true(all(unique(result$from) %in% c("USD" , "RON") ))
  expect_true(unique(result$to) == "EUR")

})


test_that("get_changes_historic handles empty symbols input", {

  result <- get_changes_historic(from = character(0))

  # empty results if empty symbol
  expect_true(is.null(result))
})

test_that("get_changes_historic handles non-existent symbols", {
  if(!internet_or_not()) skip()

 expect_message( result <- get_changes_historic(from ="INVALID-SYMBOL") )

  # invalid symbol = NA and a warning
  expect_true(is.na(result)|| is.null(result))
})

test_that("get_changes_historic respects .verbose parameter", {
  if(!internet_or_not()) skip()

  expect_silent(get_changes_historic(from = c("eerrorr"), .verbose = FALSE))
})

