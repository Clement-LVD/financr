

test_that("search_assets handle empty and null values", {

  # On recherche des symboles pour "Dow jones" en précisant le type "index"
  expect_null( search_assets(texts =NULL ))
  # Vérifier que le résultat est un data frame
  expect_equal(search_assets(texts =NA), NA)

  expect_equal(search_assets(texts =character(0)), NULL)

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


test_that("search_assets .verbose work", {
  if(!internet_or_not()) skip()

  # (no error)
  expect_silent(test <- search_assets(texts = "'lucre' n'est certainement pas utilisé par Yahoo, ou alors rat terrier"
                                      , type = "index", .verbose = FALSE))

  expect_true(is.na(test))
})
#### fn 2 => search asset quick ####

test_that("search_assets_quick handling missing values", {

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  expect_null(search_assets_quick( NULL) )

  expect_true(is.na(search_assets_quick(NA)))
})


test_that("search_assets_quick return a valid structure", {
  if(!internet_or_not()) skip()

  res <- search_assets_quick("Dow Jones")

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Liste des colonnes attendues d'après la documentation
  expected_cols <- c("symbol", "name" , "exch" ,"type" , "exchdisp" ,"typedisp" , "searched"  )
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient le terme recherché
  expect_true(all(grepl("Dow Jones", res$searched, ignore.case = TRUE)))
})

test_that("search_assets_quick work with several names and filter", {
  if(!internet_or_not()) skip()

  # Appel avec plusieurs noms et en filtrant sur des échanges
  res <- search_assets_quick(texts = c("RENAULT", "VOLVO", NA))

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Vérifier la présence des colonnes attendues
  expected_cols <-c("symbol", "name" , "exch" ,"type" , "exchdisp" ,"typedisp" , "searched"  )
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient bien l'un des termes recherchés
  expect_true(all(grepl("RENAULT|VOLVO", res$searched, ignore.case = TRUE)))
})

test_that("search_assets_quick deal with unknown values", {
  if(!internet_or_not()) skip()

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  res <- search_assets_quick( "UneEntrepriseInconnueXYZ", NA)

  # On s'attend à un data frame vide ou à NA
  expect_true(is.data.frame(res) && nrow(res) == 0 || is.na(res))
})

