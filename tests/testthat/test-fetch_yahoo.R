
test_that("Extracte correctement la première table d'un contenu HTML", {


  # Cas 2: Contenu sans aucune table (retourne NA)
  html_content_without_table <- '<html><body><p>No table here</p></body></html>'
  result <- extract_first_html_table(html_content_without_table)
  expect_true(is.na(result))  # Le résultat doit être NA car il n'y a pas de table


   # Cas 5: Contenu HTML mal formé (pas de table mais avec erreur dans la lecture)
  malformed_html <- "<html><body><div>Malformed content</div></body></html>"
  result <- extract_first_html_table(malformed_html)
  expect_true(is.na(result))  # Le résultat doit être NA, pas de table valide

})
