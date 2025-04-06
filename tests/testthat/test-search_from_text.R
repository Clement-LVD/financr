
test_that("search_assets renvoie un data frame avec la structure attendue pour un texte simple", {
  if(!internet_or_not()) skip()

  # On recherche des symboles pour "Dow jones" en précisant le type "index"
  res <- search_assets(texts = "Dow jones", type = "index")

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Liste des colonnes attendues d'après la documentation
  expected_cols <- c("symbol", "shortname", "longname", "exchange", "exchdisp",
                     "quotetype", "typedisp", "score", "isyahoofinance", "searched")

  # Vérifier que toutes les colonnes attendues sont présentes
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient la valeur recherchée
  expect_true(all(grepl("Dow jones", res$searched, ignore.case = TRUE)))
})


test_that("search_assets renvoie un data frame avec la structure attendue pour un texte simple", {

  # On recherche des symboles pour "Dow jones" en précisant le type "index"
  expect_null( search_assets(texts =NULL ))
  # Vérifier que le résultat est un data frame
 expect_equal(search_assets(texts =NA), NA)

 expect_equal(search_assets(texts =character(0)), NULL)

})


test_that("search_assets fonctionne avec plusieurs textes et filtres d'exchange", {
  if(!internet_or_not()) skip()

  # Rechercher plusieurs textes et préciser un filtre d'exchange
  res <- search_assets(texts = c("VOLVO car", "RENAULT"), exchange = c("STO", "PAR"))

  # Le résultat doit être un data frame et contenir au moins une ligne
  expect_s3_class(res, "data.frame")
  expect_gt(nrow(res), 0)

  # Vérifier que toutes les colonnes attendues sont présentes
  expected_cols <- c("symbol", "shortname", "longname", "exchange", "exchdisp",
                     "quotetype", "typedisp", "score", "isyahoofinance", "searched")
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' correspond à l'un des textes recherchés
  expect_true(all(grepl("VOLVO|RENAULT", res$searched, ignore.case = TRUE)))
})

test_that("L'argument .verbose fonctionne sans erreur", {
  if(!internet_or_not()) skip()

  # Appeler la fonction avec .verbose = TRUE ne doit pas provoquer d'erreur
  expect_silent(search_assets(texts = "Dow jones", type = "index", .verbose = TRUE))
})
