
### last function : scraping with search_assets ####
test_that("search_assets with parameters handling missing values", {

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  expect_null(search_assets( NULL, get_values = T) )


})


test_that("search_assets with parameters return a valid structure", {
  if(!internet_or_not()) skip()

  res <- search_assets( "Dow Jones", get_values = T)

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Liste des colonnes attendues d'après la documentation
  expected_cols <- c('symbol', 'shortname', 'longname', 'exchange', 'exchdisp', 'quotetype', 'typedisp', 'score', 'isyahoofinance', 'searched', 'currency', 'exchangename', 'fullexchangename', 'instrumenttype', 'firsttradedate', 'regularmarkettime', 'hasprepostmarketdata', 'gmtoffset', 'timezone', 'exchangetimezonename', 'regularmarketprice', 'fiftytwoweekhigh', 'fiftytwoweeklow', 'regularmarketdayhigh', 'regularmarketdaylow', 'regularmarketvolume', 'chartpreviousclose', 'previousclose')
  expect_true(all( expected_cols %in% names(res) ))

  # Vérifier que la colonne 'searched' contient le terme recherché
  expect_true(all(grepl("Dow Jones", res$searched, ignore.case = TRUE)))

# work with several names and filter
  res <- search_assets( c("RENAULT", "VOLVO"), exchange = c("STO", "PAR"), get_values = T)

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Vérifier la présence des colonnes attendues
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient bien l'un des termes recherchés
  expect_true(all(grepl("RENAULT|VOLVO", res$searched, ignore.case = TRUE)))

  # Optionnel : Vérifier que l'exchange retourné correspond à l'un des filtres (si les données le permettent)
  expect_true(any(res$exchange %in% c("STO", "PAR")))
})

test_that("search_assets with parameters deal with unknown values", {
  if(!internet_or_not()) skip()

  falstxt <- "UneEntrepriseInconnueXYZUneEntrepriseInconnueXYZsdsdsdsdsdsdsdsdsdsdsdsdsdsds"
  res <- search_assets( falstxt, get_values = T)

  expect_true(is.na(res))

  # verif with other
  res <- search_assets( c(falstxt, "Dow jones") ,get_values = T)

  expect_s3_class(res, "data.frame")

  expect_true(all(grepl("Dow jones", res$searched, ignore.case = TRUE)))


})


