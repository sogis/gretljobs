SELECT 
    'Grundwasservorkommen' AS hinweis,
    'Das Vorhaben befindet sich innerhalb eines nutzbaren Grundwasservorkommens. 
     Die Abstände zwischen mehreren Sonden müssen daher mindestens 10 m betragen. 
    Zur Grundstücksgrenze muss ein Mindestabstand von 5 m eingehalten werden.' AS hinweistext,
    '0' AS tiefe_hinweis,
    '0' AS hinweis_oeffentlich,
    geometrie AS mpoly
FROM afu_grundwassergeometrie_pub_v1.grundwasserstrom_begrenzung_hgw;
