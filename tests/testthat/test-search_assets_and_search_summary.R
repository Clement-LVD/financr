
test_that("search_assets handling missing values", {

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  expect_null(search_assets( NULL) )

  expect_true(is.na(search_assets(NA)))
})


test_that("search_assets return a valid structure", {

  res <- search_assets("Dow Jones")
  if(!internet_or_not()) skip()

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Liste des colonnes attendues d'après la documentation
  expected_cols <- c("symbol", "shortname", "longname"    ,   "exchange"   ,    "exchdisp"     ,  "quotetype"  ,    "typedisp"  ,     "score"
                   ,"isyahoofinance", "searched"      )
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient le terme recherché
  expect_true(all(grepl("Dow Jones", res$searched, ignore.case = TRUE)))
})

test_that("search_assets work with several names and filter", {
  if(!internet_or_not()) skip()

  # Appel avec plusieurs noms et en filtrant sur des échanges
  res <- search_assets(c("RENAULT", "VOLVO", NA), exchange = c("STO", "PAR"))

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Vérifier la présence des colonnes attendues
  expected_cols <- c("symbol", "shortname", "longname"    ,   "exchange"   ,    "exchdisp"     ,  "quotetype"  ,    "typedisp"  ,     "score"
                     ,"isyahoofinance", "searched"      )
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient bien l'un des termes recherchés
  expect_true(all(grepl("RENAULT|VOLVO", res$searched, ignore.case = TRUE)))

  # Optionnel : Vérifier que l'exchange retourné correspond à l'un des filtres (si les données le permettent)
  expect_true(any(res$exchange %in% c("STO", "PAR")))
})

test_that("search_assets deal with unknown values", {
  if(!internet_or_not()) skip()

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  res <- search_assets( "UneEntrepriseInconnueXYZ", NA)

  # On s'attend à un data frame vide ou à NA
  expect_true(is.data.frame(res) && nrow(res) == 0 || is.na(res))
})

#### fn 2 => search asset quick ####

test_that("search_asset_quick handling missing values", {

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  expect_null(search_asset_quick( NULL) )

  expect_true(is.na(search_asset_quick(NA)))
})


test_that("search_asset_quick return a valid structure", {
  if(!internet_or_not()) skip()

  res <- search_asset_quick("Dow Jones")

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Liste des colonnes attendues d'après la documentation
  expected_cols <- c("symbol", "name" , "exch" ,"type" , "exchdisp" ,"typedisp" , "searched"  )
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient le terme recherché
  expect_true(all(grepl("Dow Jones", res$searched, ignore.case = TRUE)))
})

test_that("search_asset_quick work with several names and filter", {
  if(!internet_or_not()) skip()

  # Appel avec plusieurs noms et en filtrant sur des échanges
  res <- search_asset_quick(texts = c("RENAULT", "VOLVO", NA))

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Vérifier la présence des colonnes attendues
  expected_cols <-c("symbol", "name" , "exch" ,"type" , "exchdisp" ,"typedisp" , "searched"  )
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient bien l'un des termes recherchés
  expect_true(all(grepl("RENAULT|VOLVO", res$searched, ignore.case = TRUE)))
})

test_that("search_asset_quick deal with unknown values", {
  if(!internet_or_not()) skip()

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  res <- search_asset_quick( "UneEntrepriseInconnueXYZ", NA)

  # On s'attend à un data frame vide ou à NA
  expect_true(is.data.frame(res) && nrow(res) == 0 || is.na(res))
})


### last function : scraping with search_summary ####
test_that("search_summary handling missing values", {

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
expect_null(search_summary( NULL) )


})


test_that("search_summary return a valid structure", {
  if(!internet_or_not()) skip()

  res <- search_summary( "Dow Jones")

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Liste des colonnes attendues d'après la documentation
  expected_cols <- c("symbol", "name", "last_price", "sector", "type", "exchange", "searched")
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient le terme recherché
  expect_true(all(grepl("Dow Jones", res$searched, ignore.case = TRUE)))
})

test_that("search_summary work with several names and filter", {
  if(!internet_or_not()) skip()

  # Appel avec plusieurs noms et en filtrant sur des échanges
  res <- search_summary( c("RENAULT", "VOLVO"), exchange = c("STO", "PAR"))

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Vérifier la présence des colonnes attendues
  expected_cols <- c("symbol", "name", "last_price", "sector", "type", "exchange", "searched")
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient bien l'un des termes recherchés
  expect_true(all(grepl("RENAULT|VOLVO", res$searched, ignore.case = TRUE)))

  # Optionnel : Vérifier que l'exchange retourné correspond à l'un des filtres (si les données le permettent)
  expect_true(any(res$exchange %in% c("STO", "PAR")))
})

test_that("search_summary deal with unknown values", {
  if(!internet_or_not()) skip()

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  res <- search_summary( "UneEntrepriseInconnueXYZ")

  # On s'attend à un data frame vide ou à NA
  expect_true(is.data.frame(res) && nrow(res) == 0 || is.na(res))
})
