
test_that("Validation works and answer unique values" , {
  if(!internet_or_not()) skip()
# answer is in the same order : simple case
test_vector = c("AAPL", "SAAB", "SAAB")
  test <- valid_symbol(test_vector, .verbose = F)

expect_equal(as.logical(test), expected =c(T, F) )
expect_equal(colnames(test), expected =unique(test_vector))

# 3 fakes and one good
test_vector <- c("AAPL" , "SAAB", "VOLVO", "fake symbol")
  test <- valid_symbol(test_vector, .verbose = F)
  # sort is with a fake symbol correct
  expect_equal(colnames(test), c(test_vector[1:3], "FAKESYMBOL"))

  expect_equal(as.logical(test), c(T, F, F, F))

})

test_that("Various input works", {

  if(!internet_or_not()) skip()

  test_vector = c("AAPL", "SAAB")
  test_2 = c("AAPL", "SAAB", "VOLVO")
  test <- valid_symbol(symbols =test_vector,test_2 ,  .verbose = F)

  expect_equal(colnames(test), unique(c(test_vector,test_2 )))

expect_equal(as.logical(test), expected =c(T, F, F) )
# 2 list + a fake value
test <- valid_symbol(symbols =test_vector, c(test_2 , "FAKE.VALUE"), .verbose = F)

expect_equal(colnames(test), unique(c(test_vector, test_2, "FAKE.VALUE")))
expect_equal(as.logical(test), c(TRUE , FALSE, FALSE, FALSE))

})

test_that(".verbose parameters work", {

  if(!internet_or_not()) skip()

  # test for a message about the fake Symbol
  expect_message(valid_symbol("fake symbol"))
  # but no message if user don't want
  expect_no_message(valid_symbol("fake symbol", .verbose = F))

})


