test_that("try_url works with internet", {

  if(!internet_or_not()) skip()

test <- try_url("https://wwW.google.com")
expect_type(test, "character")
expect_equal( length(test) , 1)



expect_message( {test <- try_url("pas valide du tout") })
expect_true(is.na(test))

expect_equal( length(test) , 1)

expect_silent( try_url("www.google.com", .verbose = F))

})

test_that("try_url works without internet", {

  test <- try_url(NULL)
  expect_null(test)

  # msg silent work
  expect_silent({test <- try_url(url  = NA, .verbose = F)} )
  expect_true(is.na(test ))

   test <- try_url(character(0))
   expect_null(test)

})
