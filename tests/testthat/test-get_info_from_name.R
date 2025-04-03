

test_that("get_info_from_name handling missing values", {

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
expect_null(get_info_from_name(names = NULL) )


})


test_that("get_info_from_name retourne une structure valide pour un nom unique", {

  res <- get_info_from_name(names = "Dow Jones")
  if(!internet_or_not()) skip()

  # Vérifier que le résultat est un data frame
  expect_s3_class(res, "data.frame")

  # Liste des colonnes attendues d'après la documentation
  expected_cols <- c("symbol", "name", "last_price", "sector", "type", "exchange", "searched")
  expect_true(all(expected_cols %in% names(res)))

  # Vérifier que la colonne 'searched' contient le terme recherché
  expect_true(all(grepl("Dow Jones", res$searched, ignore.case = TRUE)))
})

test_that("get_info_from_name fonctionne avec plusieurs noms et un filtre sur l'exchange", {
  if(!internet_or_not()) skip()

  # Appel avec plusieurs noms et en filtrant sur des échanges
  res <- get_info_from_name(names = c("RENAULT", "VOLVO"), exchange = c("STO", "PAR"))

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

test_that("get_info_from_name gère correctement les noms inconnus", {
  if(!internet_or_not()) skip()

  # Appel avec un nom qui n'est pas attendu, on peut espérer un résultat vide ou NA
  res <- get_info_from_name(names = "UneEntrepriseInconnueXYZ")

  # On s'attend à un data frame vide ou à NA
  expect_true(is.data.frame(res) && nrow(res) == 0 || is.na(res))
})
