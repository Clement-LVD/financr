test_that("market_summary works", {

  if(!internet_or_not()) skip()

test <-  market_summary()

expect_true(nrow(test) > 1)
expect_s3_class(test, "data.frame")

# Liste des colonnes attendues d'après la documentation
expected_cols <- c("symbol", "fullexchangename", "regularmarkettime_raw", "regularmarketchange_fmt")
expect_true(all(expected_cols %in% names(test)))

# Vérifier que la colonne 'searched' contient le terme recherché
expect_true(all(grepl("Dow Jones", test$searched, ignore.case = TRUE)))
})

test_that("market_summary filter out region", {

  if(!internet_or_not()) skip()
 df_fr <- market_summary(region = "FR")

 expect_s3_class(df_fr, "data.frame")

 expect_equal(unique(df_fr$region), "FR") # only the FR region


})


